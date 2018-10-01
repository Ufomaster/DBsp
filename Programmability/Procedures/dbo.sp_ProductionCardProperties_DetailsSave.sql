SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   16.03.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   25.10.2017$*/
/*$Version:    1.00$   $Decription: Сохраняем$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardProperties_DetailsSave]
    @ProductionCardCustomizeID Int
AS
BEGIN
    IF OBJECT_ID('tempdb..#ProductionCardCustomizeDetails') IS NOT NULL
    BEGIN    
      /*удалим удалённые*/
      DELETE se
      FROM dbo.ProductionCardCustomizeDetails se
      LEFT JOIN #ProductionCardCustomizeDetails t ON t._ID = se.ID
      WHERE t._ID IS NULL AND se.ProductionCardCustomizeID = @ProductionCardCustomizeID
/*      удалим из сопроводительного листа
      DELETE m
      FROM dbo.ProductionCardCustomizeMaterials m
      LEFT JOIN #ProductionCardCustomizeDetails t ON t.TmcID = m.TmcID      
      WHERE m.ProductionCardCustomizeID = @ProductionCardCustomizeID AND t.ID IS NULL*/
      
--      DELETE m
--      FROM dbo.Materials m
--      LEFT JOIN ProductionCardCustomizeDetails p ON p.MaterialID = m.ID
--      WHERE m.TypeID = 2 AND p.ID IS NULL

      /*вставим новые материалы */
--      DECLARE @T TABLE(ID Int, tmpID Int)
--      DECLARE @Name Varchar(255), @tmpID Int, @UnitID Int
--      DECLARE #cur CURSOR FOR SELECT d.[Name], d.ID, d.UnitID
--                              FROM #ProductionCardCustomizeDetails d
--                              LEFT JOIN ProductionCardCustomizeDetails pa ON pa.ID = d._ID AND pa.ProductionCardCustomizeID = @ProductionCardCustomizeID
--                              WHERE pa.ID IS NULL AND d.[Name] IS NOT NULL AND d.MaterialID IS NULL
--      OPEN #cur
--      FETCH NEXT FROM #cur INTO @Name, @tmpID, @UnitID
--      WHILE @@FETCH_STATUS = 0 
--      BEGIN
          --проверим - есть ли такой материал уже в материалах по имени.
--          IF EXISTS(SELECT * FROM Materials WHERE [Name] COLLATE Cyrillic_General_CI_AS = @Name)
--          BEGIN --если есть, проставим MaterialID из таблицы Materials в темповую таблицу, какбудто материал уже есть такой.
--              UPDATE a 
--              SET a.MaterialID = m.ID
--              FROM #ProductionCardCustomizeDetails a
--              INNER JOIN Materials m ON m.[Name] COLLATE Cyrillic_General_CI_AS = a.[Name]
--              WHERE a.ID = @tmpID
--          END
--          ELSE
  --        BEGIN -- это полностью новый материал. его нужно просто вставить.
--              INSERT INTO Materials([Name], TypeID, UnitID)
--              OUTPUT INSERTED.ID, @tmpID INTO @T
--              VALUES(@Name, 2, @UnitID)
              
--              UPDATE d
--              SET
--                  d.MaterialID = a.ID
--              FROM #ProductionCardCustomizeDetails d
--              INNER JOIN @T a ON a.tmpID = d.ID
--              WHERE d.ID = @tmpID
--
--              DELETE FROM @T
--          END
          
--          FETCH NEXT FROM #cur INTO @Name, @tmpID, @UnitID
--      END
--      CLOSE #Cur
--      DEALLOCATE #Cur
     
      /*проапдейтим материалы*/
--      UPDATE m
--      SET m.[Name] = d.[Name], m.UnitID = d.UnitID
--      FROM Materials m
--      INNER JOIN #ProductionCardCustomizeDetails d ON d.MaterialID = m.ID AND d.[Name] <> ''
      
      /*изменим изменённые*/
      UPDATE se
      SET se.Norma = t.Norma,
          se.TmcID = t.TmcID,
          se.LinkedProductionCardCustomizeID = t.LinkedProductionCardCustomizeID,
          se.UnitID = t.UnitID,
          se.MaterialKind = t.MaterialKind,
          se.Kind = t.Kind
      FROM dbo.ProductionCardCustomizeDetails se
      INNER JOIN #ProductionCardCustomizeDetails t ON t._ID = se.ID
      WHERE se.ProductionCardCustomizeID = @ProductionCardCustomizeID
      
      /*Добавим добавленные*/
      INSERT INTO ProductionCardCustomizeDetails(ProductionCardCustomizeID, Norma,
        LinkedProductionCardCustomizeID, TmcID, UnitID, MaterialKind, Kind)
      SELECT
        @ProductionCardCustomizeID, 
        d.Norma,
        d.LinkedProductionCardCustomizeID, 
        d.TmcID,
        d.UnitID,
        d.MaterialKind,
        d.Kind
      FROM #ProductionCardCustomizeDetails d
      LEFT JOIN ProductionCardCustomizeDetails pa ON pa.ID = d._ID AND pa.ProductionCardCustomizeID = @ProductionCardCustomizeID
      WHERE pa.ID IS NULL
   END
END
GO