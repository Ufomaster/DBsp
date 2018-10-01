SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   06.12.2013$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   25.05.2015$*/
/*$Version:    1.00$   $Description: Удаление из темповой таблицы $*/
CREATE PROCEDURE [QualityControl].[sp_ActsDetails_InsertXMLField]
    @ActFieldID int, 
    @ActDetailsID int
AS
BEGIN
	SET NOCOUNT ON
    DECLARE @XMLData xml, @XML xml
    DECLARE @Err Int
                
    DECLARE @Order Int
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        SELECT @XML = XMLData FROM #ActsDetails WHERE ID = @ActDetailsID
        --Выборка существующих данных

        SELECT
                nref.value('(ID)[1]', 'int') AS ID,
                nref.value('(ActFieldsID)[1]', 'varchar(255)') AS ActFieldsID,
                nref.value('(Value)[1]', 'varchar(8000)') AS [Value], 
                nref.value('(SortOrder)[1]', 'int') AS SortOrder 
        INTO #tmp
        FROM @XML.nodes('/Data/Props') R(nref)
        ORDER BY SortOrder
        -- Если исходный хмл нуловый, знаичт список пуст.
        IF @XML IS NULL
            INSERT INTO #tmp(ID, ActFieldsID, [Value], SortOrder) --добавляем первый элемент
            SELECT 1, @ActFieldID, NULL, 1
        ELSE
            INSERT INTO #tmp(ID, ActFieldsID, [Value], SortOrder)
            SELECT    
                (SELECT MAX(ISNULL(ID, 0)) + 1 FROM #tmp),
                @ActFieldID,
                NULL,
                (SELECT MAX(ISNULL(SortOrder, 0)) + 1 FROM #tmp)
        
        SELECT @XMLData = CAST('<?xml version="1.0" encoding="utf-16"?><Data>' AS Nvarchar(MAX)) +
            (SELECT ID, ActFieldsID, [Value], SortOrder
             FROM #tmp
             ORDER BY SortOrder
             FOR Xml PATH ('Props')) + '</Data>'
        
        UPDATE #ActsDetails
        SET XMLData = @XMLData
        WHERE ID = @ActDetailsID
        
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