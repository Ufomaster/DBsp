SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$    $Create date:   30.12.2011$
--$Modify:     Oleynik Yuriy$    $Modify date:   07.03.2012$
--$Version:    1.00$   $Description: Публикация дерева$
CREATE PROCEDURE [dbo].[sp_ProductionCardProperties_Publish]
    @RootID Int = NULL
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @Err Int    
    
    DECLARE @T TABLE(ID Int)
    DECLARE @HistoryID Int
        
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
         -- нужно проверить нет ли в ветках значений с атрибутом дефолтового значения(6) в колве более чем 1
         -- и ругнуться.
        /* вставляем шапку историии дерева с датой начала действия*/
        INSERT INTO ProductionCardPropertiesHistory(RootProductionCardPropertiesID, StartDate)
        OUTPUT INSERTED.ID INTO @T
        SELECT @RootID, GetDate()

        SELECT @HistoryID = ID FROM @T
        /* создаем таблицу связок новых айди со старыми через временную таблицу со вставкой нужных данных в #tmp*/
        CREATE TABLE #ProductionCardDetails(ID Int IDENTITY(1, 1) NOT NULL,[ParentID] Int,Old_ID Int)
        /* таблица данных New_ID и Old_ID*/
        CREATE TABLE #tmp(New_ID Int, Old_ID Int)
        /*поскольку айдишку нужно начислить с некоего максимального идентимфикатора установим значение идентити в темповой таблице*/
        /* до нужного значения которое берем из ProductionCardPropertiesHistoryDetails*/
        DECLARE @new_reseed_value Int SELECT @new_reseed_value = ISNULL(MAX(ID), 1) + 1 FROM ProductionCardPropertiesHistoryDetails

        DBCC CHECKIDENT ('#ProductionCardDetails', RESEED, @new_reseed_value)
        /* генерим данные идентификаторов*/
        INSERT INTO #ProductionCardDetails(ParentID, Old_ID)
        OUTPUT INSERTED.ID, INSERTED.Old_ID INTO #tmp
        SELECT
            p.ParentID,
            p.ID
        FROM fn_ProductionCardPropertiesNode_Select(@RootID) p1
        INNER JOIN ProductionCardProperties p ON p.ID = p1.ID
        LEFT JOIN ObjectTypes ot ON p.ObjectTypeID = ot.ID

        UNION ALL
        SELECT NULL, @RootID

/*        FROM ProductionCardProperties p
        LEFT JOIN ObjectTypes ot ON p.ObjectTypeID = ot.ID
        ORDER BY p.NodeLevel, p.ParentID, p.NodeOrder*/

        /* наконец отключаем автонумерацию идентити и постим копию нашего дерева с новыми айдишками*/
        SET IDENTITY_INSERT dbo.ProductionCardPropertiesHistoryDetails ON
        INSERT INTO ProductionCardPropertiesHistoryDetails([ID], [ParentID], 
          [ProductionCardPropertiesHistoryID], [NodeLevel], [NodeOrder], [ObjectTypeID], [Required], [FixedEdit])
        SELECT 
            tmp.New_ID,
            tmp2.New_ID,
            @HistoryID,
            p.NodeLevel,
            p.NodeOrder,
            p.ObjectTypeID,
            CASE WHEN ota.ID IS NULL THEN 1 ELSE 0 END,
            CASE WHEN otaF.ID IS NULL THEN 1 ELSE 0 END
        FROM ProductionCardProperties p
        LEFT JOIN ObjectTypesAttributes ota ON ota.AttributeID = 8 AND ota.ObjectTypeID = p.ObjectTypeID
        LEFT JOIN ObjectTypesAttributes otaF ON otaF.AttributeID = 7 AND otaF.ObjectTypeID = p.ObjectTypeID        
        LEFT JOIN #tmp tmp ON tmp.Old_ID = p.ID
        LEFT JOIN #tmp tmp2 ON tmp2.Old_ID = p.ParentID
        WHERE (tmp.Old_ID IS NOT NULL OR tmp2.Old_ID IS NOT NULL)
        ORDER BY p.NodeLevel, p.ParentID, p.NodeOrder

        /*возвращаем взад автовставку идентити*/
        SET IDENTITY_INSERT dbo.ProductionCardPropertiesHistoryDetails OFF

        DROP TABLE #ProductionCardDetails
        DROP TABLE #tmp

        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO