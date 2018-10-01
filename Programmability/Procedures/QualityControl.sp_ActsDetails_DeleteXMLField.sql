SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   06.12.2013$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   25.05.2015$*/
/*$Version:    1.00$   $Description: Удаление поля $*/
CREATE PROCEDURE [QualityControl].[sp_ActsDetails_DeleteXMLField]
    @ID Int,
    @ActDetailsID int
AS
BEGIN
    DECLARE @XMLData xml, @XML xml, @Order int
    DECLARE @Err Int
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        SELECT @XML = XMLData FROM #ActsDetails WHERE ID = @ActDetailsID

        SELECT
                nref.value('(ID)[1]', 'int') AS ID, 
                nref.value('(ActFieldsID)[1]', 'varchar(255)') AS ActFieldsID,
                nref.value('(Value)[1]', 'varchar(8000)') AS [Value], 
                nref.value('(SortOrder)[1]', 'int') AS SortOrder 
        INTO #tmp
        FROM @XML.nodes('/Data/Props') R(nref)
        ORDER BY SortOrder
        
        
        SELECT
            @Order = t.SortOrder
        FROM #tmp t
        WHERE t.ID = @ID
                
        DELETE
        FROM #tmp
        WHERE ID = @ID

        UPDATE #tmp
        SET SortOrder = SortOrder - 1
        WHERE SortOrder > @Order

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