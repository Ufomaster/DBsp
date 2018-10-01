SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   05.12.2013$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   25.05.2015$*/
/*$Version:    1.00$   $Description: Перемещение полей участников $*/
CREATE PROCEDURE [QualityControl].[sp_ActsDetails_MoveXMLFields]
    @ID Int,
    @Direction Int,
    @ActDetailsID int
AS
BEGIN
    DECLARE @XMLData xml, @XML xml
    SELECT @XML = XMLData FROM #ActsDetails WHERE ID = @ActDetailsID
    DECLARE @Err Int
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        SELECT
                nref.value('(ID)[1]', 'int') AS ID, 
                nref.value('(ActFieldsID)[1]', 'varchar(255)') AS ActFieldsID,
                nref.value('(Value)[1]', 'varchar(8000)') AS [Value], 
                nref.value('(SortOrder)[1]', 'int') AS SortOrder 
        INTO #tmp
        FROM @XML.nodes('/Data/Props') R(nref)
        ORDER BY SortOrder
      
        DECLARE @Order int
        IF @Direction = 1 /* VK_UP*/
        BEGIN
            SELECT @Order = SortOrder
            FROM #tmp
            WHERE ID = @ID
            
            /*выберем предидущий порядок*/
            SELECT TOP 1 @Order = SortOrder
            FROM #tmp
            WHERE SortOrder < @Order
            ORDER BY SortOrder DESC

            /*сдвинем предыдущую запись вниз, если есть что сдвигать*/
            IF @Order IS NOT NULL
                UPDATE #tmp
                SET SortOrder = SortOrder + 1
                WHERE SortOrder = @Order
            ELSE
                SET @Order = 1
           /*наконец проставим себе индекс если возможно*/
           UPDATE #tmp
           SET SortOrder = @Order
           WHERE ID = @ID
        END
        ELSE

        IF @Direction = 2 /* VK_DOWN*/
        BEGIN
            SELECT @Order = SortOrder
            FROM #tmp
            WHERE ID = @ID
            /*выберем следующий порядок*/
            SELECT TOP 1 @Order = SortOrder
            FROM #tmp
            WHERE SortOrder > @Order
            ORDER BY SortOrder
            /*сдвинем след. запись вверх, если есть что сдвигать*/
            IF @Order IS NOT NULL
                UPDATE #tmp
                SET SortOrder = SortOrder - 1
                WHERE SortOrder = @Order
            ELSE
                SET @Order = (SELECT MAX(SortOrder + 1) FROM #tmp)
           /*наконец проставим себе индекс если возможно*/
           IF @Order IS NULL
               SET @Order = 1
           UPDATE #tmp
           SET SortOrder = @Order
           WHERE ID = @ID
        END
        

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