SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   07.05.2015$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   07.05.2015$*/
/*$Version:    1.00$   $Description: Удаление задач*/
CREATE PROCEDURE [dbo].[sp_Tasks_Delete]
    @ID int
AS
BEGIN
    DELETE FROM Tasks WHERE ID = @ID
END
GO