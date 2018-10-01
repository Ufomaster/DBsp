SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$    $Create date:   31.03.2011$
--$Modify:     Yuriy Oleynik$    $Modify date:   31.03.2011$
--$Version:    1.00$   $Decription: выборка констант прав$
CREATE PROCEDURE [dbo].[sp_UserRightsObjects_ForDelphiCode]
AS
BEGIN
    DECLARE @Text Varchar(MAX)
    SET @Text = ''
    SELECT 
        @Text = CAST(@Text AS Varchar(MAX)) + Char(13) + Char(10) + 
        a.DelphiConst + ' = ' + CAST(a.ID AS Varchar) + ';  // ' + a.[Name]
    FROM UserRightsObjects a
    WHERE a.IcoIndex = 45

    SELECT LTRIM(@text)
END
GO