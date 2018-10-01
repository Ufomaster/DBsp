SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   16.01.2015$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   16.01.2015$*/
/*$Version:    1.00$   $Description: Откат изменений к версии из историии (по виду ЗЛ)$*/
create PROCEDURE [dbo].[sp_ProductionCardProperties_Undo]
    @ParentID Int,
    @HistoryID Int
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Err Int
    DECLARE @NullParentID int /*P*/

    ALTER TABLE [dbo].[ProductionCardProperties]
    NOCHECK CONSTRAINT [FK_ProductionPCardProperties_ProductionPCardProperties_ID]
            
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        --в хистори публикуется узел второго уровня, но с парентом НУЛЛ. ЗЛ ссылаются на него. В дальнейшенй работе учитываем этот момент
        -- места помечены /*P*/
        SELECT @NullParentID = ID FROM ProductionCardProperties WHERE ParentID = @ParentID /*P*/
            
        DECLARE @T TABLE(ID Int);
        
        WITH ResultTable (ID, ParentID, NodeLevel, NodeOrder)
        AS
        (
            /* Anchor member definition*/
            SELECT
                ID, ParentID, NodeLevel, NodeOrder
            FROM ProductionCardProperties e
            WHERE ID = @ParentID
            UNION ALL
            /* Recursive member definition*/
            SELECT
                e.ID, e.ParentID, e.NodeLevel, e.NodeOrder
            FROM ProductionCardProperties AS e
            INNER JOIN ResultTable AS d ON e.ParentID = d.ID
        )

        --удаляем старые записи.
        DELETE b FROM ProductionCardProperties b
        WHERE b.ID IN (SELECT ID FROM ResultTable WHERE ID <> @ParentID AND ParentID <> @ParentID/*P*/)  

        /* создаем таблицу связок новых айди со старыми через временную таблицу со вставкой нужных данных в #tmp*/
        CREATE TABLE #Details(ID Int IDENTITY(1, 1) NOT NULL,[ParentID] Int, Old_ID Int)
        /* таблица данных New_ID и Old_ID*/
        CREATE TABLE #tmp(New_ID Int, Old_ID Int)
        /*поскольку айдишку нужно начислить с некоего максимального идентификатора установим значение идентити в темповой таблице*/
        /* до нужного значения которое берем из ProductionCardProperties*/
        DECLARE @new_reseed_value Int SELECT @new_reseed_value = ISNULL(MAX(ID), 1) + 1 FROM ProductionCardProperties

        DBCC CHECKIDENT ('#Details', RESEED, @new_reseed_value)
        /* генерим данные идентификаторов*/
        INSERT INTO #Details(ParentID, Old_ID)
        OUTPUT INSERTED.ID, INSERTED.Old_ID INTO #tmp
        SELECT
            CASE WHEN Prnt.ParentID IS NULL THEN @NullParentID /*P*/ ELSE hd.ParentID END,
            hd.ID
        FROM ProductionCardPropertiesHistoryDetails hd
        LEFT JOIN ProductionCardPropertiesHistoryDetails Prnt ON Prnt.ID = hd.ParentID AND Prnt.ProductionCardPropertiesHistoryID = @HistoryID
        INNER JOIN ObjectTypes t ON t.id = hd.ObjectTypeID
        WHERE hd.ProductionCardPropertiesHistoryID = @HistoryID AND hd.ParentID IS NOT NULL
        ORDER BY hd.NodeLevel

        /* наконец отключаем автонумерацию идентити и постим копию нашего дерева с новыми айдишками*/
        SET IDENTITY_INSERT dbo.ProductionCardProperties ON
        INSERT INTO ProductionCardProperties(ID, ParentID, ObjectTypeID, NodeExpanded, NodeLevel, NodeOrder)
        SELECT
            tmp.New_ID,
            ISNULL(tmp2.New_ID, @NullParentID /*P*/) AS New_ID,
            p.ObjectTypeID,
            0,
            p.NodeLevel,
            p.NodeOrder
        FROM ProductionCardPropertiesHistoryDetails p
        LEFT JOIN #tmp tmp ON tmp.Old_ID = p.ID
        LEFT JOIN #tmp tmp2 ON tmp2.Old_ID = p.ParentID
        WHERE (tmp.Old_ID IS NOT NULL OR tmp2.Old_ID IS NOT NULL)
        ORDER BY p.NodeLevel, p.ParentID, p.NodeOrder

        /*возвращаем взад автовставку идентити*/
        SET IDENTITY_INSERT dbo.ProductionCardProperties OFF

        DROP TABLE #Details
        DROP TABLE #tmp

        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH

    ALTER TABLE [dbo].[ProductionCardProperties]
    CHECK CONSTRAINT [FK_ProductionPCardProperties_ProductionPCardProperties_ID]    
END
GO