SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   17.08.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   17.08.2012$*/
/*$Version:    1.00$   $Decription: $*/
create PROCEDURE [unknown].[sp_AStorageStructure_MDSImportLogError]
    @Number Varchar(255),
    @Error Varchar(2000),
    @ErrorCode Tinyint
AS
BEGIN
    SET NOCOUNT ON
    INSERT INTO AStorageStructureImportLog ([Number], [Error], [ErrorCode])
    SELECT @Number, @Error, @ErrorCode 
END
GO