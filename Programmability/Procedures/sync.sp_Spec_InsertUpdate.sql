SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuiriy$    		$Create date:   06.10.2015$*/
/*$Modify:     Oleynik Yuiriy$          $Modify date:   04.07.2018$*/
/*$Version:    1.00$   $Description: Обновление информации для выгрузки сецификации$*/
CREATE PROCEDURE [sync].[sp_Spec_InsertUpdate]
    @PCCID Int,
    @EmployeeID int,
    @DepartmentCode1C varchar(36),
    @ProdDepartmentCode1C varchar(36)
AS
BEGIN
    SET NOCOUNT ON
    --SET @ProdDepartmentCode1C = 'dec639db-e2f9-11e6-96da-0050569e8704'

    IF EXISTS(SELECT * 
              FROM ProductionCardCustomizeMaterials a 
              INNER JOIN Tmc t ON t.ID = a.TmcID AND t.IsHidden = 1
              WHERE a.ProductionCardCustomizeID = @PCCID)
    BEGIN
        RAISERROR ('Создание в 1с спецификации с удалёнными материалами запрещено', 16, 1)
        RETURN
    END

    IF NOT EXISTS(SELECT c.ID 
                  FROM ProductionCardCustomize c
                  INNER JOIN Tmc t ON t.ID = c.TmcID
                  WHERE c.ID = @PCCID)
    BEGIN
        RAISERROR ('Готовая продукция в ЗЛ не указана', 16, 1)
        RETURN
    END

    DECLARE @CardCountInvoice int, @ZLNum varchar(20), @fix varchar(10), @TechCardCode1C varchar(36), @ReleaseDate datetime,
      @WeightGross decimal(18, 2), @WeightNet decimal(18, 2), @PackingID tinyint, @PackingName varchar(255), 
        @PackingNameEng varchar(255), @WeightPlaceCount smallint, @ParentZLNumber varchar(30)
    
    SELECT @CardCountInvoice = CardCountInvoice, @ZLNum = pc.Number, 
    @fix = CASE WHEN TypeID = 218 THEN 'ПВХ'
                WHEN TypeID = 8031 THEN 'картону'
           ELSE ''
           END,
    @TechCardCode1C = tc.Code1C,
    @WeightGross = pc.WeightGross,
    @WeightNet = pc.WeightNet,
    @PackingID = pc.PackingID,
    @PackingName = p.Name,
    @PackingNameEng = p.NameEng,
    @WeightPlaceCount = pc.WeightPlaceCount,
    @ParentZLNumber = sborka.Number
    FROM ProductionCardCustomize pc
    LEFT JOIN Packings p ON p.ID = pc.PackingID
    LEFT JOIN manufacture.TechnologicalCards tc ON tc.ID = pc.TechnologicalCardID
    LEFT JOIN (SELECT TOP 1 pccs.Number, det.LinkedProductionCardCustomizeID
               FROM ProductionCardCustomizeDetails det
               INNER JOIN ProductionCardCustomize pccs ON pccs.ID = det.ProductionCardCustomizeID 
               WHERE det.LinkedProductionCardCustomizeID = @PCCID
               ORDER BY det.ID DESC) AS sborka ON sborka.LinkedProductionCardCustomizeID = pc.ID
    WHERE pc.ID = @PCCID

    SELECT @ReleaseDate = MAX(rd.ReleaseDate)
    FROM ProductionCardCustomizeReleaseDates rd 
    WHERE rd.ProductionCardCustomizeID = @PCCID
    

    DECLARE @Err Int, @1CSpecID Int
    DECLARE @T TABLE(ID Int)
    DECLARE @Uzli TABLE(ID Int, MatID int)

    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        --В наборе СЛ, есть записи, в которых будет Указано что это узел. Такие записи нужно отобрать вначале, создать для них Спецификации.
        
        --Удаляем удалённые детали. Шапка остается всегда, даже если удалился СЛ.
        EXEC [sync].sp_Spec_Delete @PCCID                                                   
        
        --Ищем и создаём узлы.      
        DECLARE @UzelSpecID int, @UzelMatID int      
        DECLARE CRS CURSOR STATIC LOCAL FOR SELECT cr.ID
                                            FROM ProductionCardCustomizeMaterials AS cr
                                            WHERE cr.ProductionCardCustomizeID = @PCCID AND ISNULL(cr.is1CSpecNode,0) = 1
                                            ORDER BY cr.ID
        OPEN CRS
        FETCH NEXT FROM CRS INTO @UzelMatID
        WHILE @@FETCH_STATUS = 0
        BEGIN
            /*Все детали шапки, удалятся по Каскадному удалению, если СЛ пересоздан.*/
            -- Если уже есть такой узел - апдейт.
            -- «Тиражні аркуші ПВХ/картону » + «Наименование ЗЛ» + «/» + «№ЗЛ» 
            IF NOT EXISTS(SELECT * FROM sync.[1CSpecDetail] d WHERE d.ProductionCardCustomizeMaterialsID = @UzelMatID AND d.NormKind = 2)
            BEGIN
                --шапка узла спецификации
                INSERT INTO sync.[1CSpec]([Name], Kind, TMCCode1C, DepartmentCode1C, [Status], EmployeeID, ProductionCardCustomizeID, ZLDepartmentCode1C, ProductClassCode1C,
                WeightGross, WeightNet, PackingID, PackingName, PackingNameEng, WeightPlaceCount, ParentZLNumber)
                OUTPUT INSERTED.ID, @UzelMatID INTO @Uzli
                SELECT LEFT('Тиражні аркуші ' + @fix + ' ' + pc.[Name] + '/' + @ZLNum, 100), 2, t.Code1C, @DepartmentCode1C, 0, @EmployeeID, @PCCID, @ProdDepartmentCode1C, pt.ProductClassCode1C,
                @WeightGross, @WeightNet, @PackingID, @PackingName, @PackingNameEng, @WeightPlaceCount, @ParentZLNumber
                FROM ProductionCardCustomizeMaterials m
                INNER JOIN ProductionCardCustomize pc ON pc.ID = m.ProductionCardCustomizeID AND pc.ID = @PCCID
                INNER JOIN ProductionCardTypes pt ON pt.ProductionCardPropertiesID = pc.TypeID
                INNER JOIN Tmc t ON t.ID = m.TmcID
                WHERE m.ID = @UzelMatID

                SELECT @UzelSpecID = ID FROM @Uzli WHERE MatID = @UzelMatID
                --деталь узловой спецификации
                INSERT INTO sync.[1CSpecDetail](NormKind, TMCCode1C, [1CSpecNodeID], Amount, UnitCode1C, [1CSpecID], ProductionCardCustomizeMaterialsID, Position1C) 
                SELECT 1, t.Code1C, NULL, m.PlanNorma/@CardCountInvoice, u.Code1C, @UzelSpecID, @UzelMatID, ROW_NUMBER() OVER (ORDER BY m.ID)
                FROM ProductionCardCustomizeMaterials m 
                INNER JOIN Tmc t ON t.ID = m.TmcID
                INNER JOIN Units u ON u.ID = t.UnitID
                WHERE m.ID = @UzelMatID
            END
            ELSE
            BEGIN
              SELECT @UzelSpecID = sd.[1CSpecNodeID]
              FROM sync.[1CSpecDetail] sd
              WHERE sd.ProductionCardCustomizeMaterialsID = @UzelMatID
              -- уже существует, нужно апдейтнуть.
              INSERT INTO @Uzli(ID, MatID)
              SELECT @UzelSpecID, @UzelMatID

              UPDATE a            
              SET 
                [Name] = LEFT('Тиражні аркуші ' + @fix + ' ' + c.[Name] + '/' + @ZLNum,100),
                Kind = 2,
                TMCCode1C = t.Code1C,
                DepartmentCode1C = @DepartmentCode1C,
                [Status] = 0,
                CreateDate = GetDate(),
                EmployeeID = @EmployeeID,
                ZLDepartmentCode1C = @ProdDepartmentCode1C,
                ErrorMessage = NULL,
                ProductClassCode1C = pt.ProductClassCode1C,
                TCCode1C = @TechCardCode1C,
                WeightGross = @WeightGross,
                WeightNet = @WeightNet,
                PackingID = @PackingID,
                PackingName = @PackingName,
                PackingNameEng = @PackingNameEng,
                WeightPlaceCount = @WeightPlaceCount,
                ParentZLNumber = @ParentZLNumber
              FROM sync.[1CSpec] a
              INNER JOIN ProductionCardCustomize c ON c.ID = a.ProductionCardCustomizeID AND c.ID = @PCCID
              INNER JOIN ProductionCardTypes pt ON pt.ProductionCardPropertiesID = c.TypeID
              LEFT JOIN Tmc t ON t.ID = c.TmcID
              WHERE a.ID = @UzelSpecID          
            END

            FETCH NEXT FROM CRS INTO @UzelMatID
        END
        CLOSE CRS
        DEALLOCATE CRS
        --узлы созданы и хранятся в @Uzli

        --далее ищем шапку не узловую.
        IF EXISTS(SELECT * FROM sync.[1CSpec] s WHERE s.ProductionCardCustomizeID = @PCCID AND s.Kind = 1)
        BEGIN
            SELECT @1CSpecID = ID
            FROM sync.[1CSpec] 
            WHERE ProductionCardCustomizeID = @PCCID AND Kind = 1 --она должна быть одна. Если оказалось более 1-й неузловой - ошибка.
            /*Шапка будет всегда, даже при перегенерации.*/
            /*Все детали шапки, удалятся по Каскадному удалению, если СЛ пересоздан.*/
            UPDATE a
            SET
                [Name] = LEFT(c.[Name] + '/' + c.Number, 100),
                Kind = 1,
                TMCCode1C = t.Code1C,
                DepartmentCode1C = @DepartmentCode1C,
                [Status] = 0,
                CreateDate = GetDate(),
                EmployeeID = @EmployeeID,
                TCCode1C = @TechCardCode1C, 
                ReleaseDate = @ReleaseDate,
                Amount = @CardCountInvoice,
                ZLDepartmentCode1C = @ProdDepartmentCode1C,
                ErrorMessage = NULL,
                ProductClassCode1C = pt.ProductClassCode1C,
                WeightGross = @WeightGross,
                WeightNet = @WeightNet,
                PackingID = @PackingID,
                PackingName = @PackingName,
                PackingNameEng = @PackingNameEng,
                WeightPlaceCount = @WeightPlaceCount,
                ParentZLNumber = @ParentZLNumber
            FROM sync.[1CSpec] a
            INNER JOIN ProductionCardCustomize c ON c.ID = a.ProductionCardCustomizeID AND c.ID = @PCCID
            INNER JOIN ProductionCardTypes pt ON pt.ProductionCardPropertiesID = c.TypeID
            INNER JOIN Tmc t ON t.ID = c.TmcID
            WHERE a.ID = @1CSpecID
        END    
        ELSE
        BEGIN
            INSERT INTO sync.[1CSpec]([Name], Kind, TMCCode1C, DepartmentCode1C, [Status], EmployeeID, ProductionCardCustomizeID, TCCode1C, ReleaseDate, Amount, ZLDepartmentCode1C, ProductClassCode1C,
             WeightGross, WeightNet, PackingID, PackingName, PackingNameEng, WeightPlaceCount, ParentZLNumber)            
            OUTPUT INSERTED.ID INTO @T
            SELECT LEFT(c.[Name] + '/' + c.Number, 100), 1, t.Code1C, @DepartmentCode1C, 0, @EmployeeID, @PCCID, @TechCardCode1C, @ReleaseDate, @CardCountInvoice, @ProdDepartmentCode1C, pt.ProductClassCode1C,
             @WeightGross, @WeightNet, @PackingID, @PackingName, @PackingNameEng, @WeightPlaceCount, @ParentZLNumber
            FROM ProductionCardCustomize c
            INNER JOIN Tmc t ON t.ID = c.TmcID
            INNER JOIN ProductionCardTypes pt ON pt.ProductionCardPropertiesID = c.TypeID
            WHERE c.ID = @PCCID

            SELECT @1CSpecID = ID
            FROM @T
        END

        --обрабатываем сгенерированный СЛ. детали уже должны быть удалены.

        INSERT INTO sync.[1CSpecDetail](NormKind, TMCCode1C, [1CSpecNodeID], Amount, UnitCode1C, [1CSpecID], ProductionCardCustomizeMaterialsID, Position1C) 
        SELECT src.NormKind, src.Code1C, src.ID, src.Norma/@CardCountInvoice, src.UCode1C, src.[1CSpecID], src.MatID, ROW_NUMBER() OVER (ORDER BY src.ID)
        FROM (
            SELECT 2 AS NormKind, t.Code1C, a.ID, @CardCountInvoice AS Norma /*m1.Norma*/, u.Code1C AS UCode1C, @1CSpecID AS [1CSpecID], a.MatID
            FROM @Uzli a --@Uzli(ID, MatID)
            INNER JOIN ProductionCardCustomizeMaterials m1 ON m1.ID = a.MatID
            INNER JOIN Tmc t ON t.ID = m1.TmcID
            INNER JOIN Units u ON u.ID = t.UnitID

            UNION ALL        
                    
            SELECT 1, t.Code1C, NULL, m.PlanNorma, u.Code1C, @1CSpecID, m.ID
            FROM ProductionCardCustomizeMaterials m 
            INNER JOIN Tmc t ON t.ID = m.TmcID
            INNER JOIN Units u ON u.ID = t.UnitID
            WHERE m.ProductionCardCustomizeID = @PCCID AND ISNULL(m.is1CSpecNode, 0) = 0
            ) AS src

        UPDATE a            
        SET 
            [Status] = 1
        FROM sync.[1CSpec] a
        WHERE ID IN (SELECT @1CSpecID UNION ALL SELECT ID FROM @Uzli)

        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO