SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$    $Create date:   07.09.2011$
--$Modify:     Yuriy Oleynik$    $Modify date:   21.01.2014$
--$Version:    1.00$   $Decription: Проверка дубликата номера счета$
CREATE PROCEDURE [dbo].[sp_Invoice_NumberIsValid]
      @ID Int,
      @Number Varchar(50)
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS(SELECT * FROM Invoice i WHERE i.NumberStr = @Number AND i.ID <> @ID AND YEAR(i.[Date]) = YEAR(GETDATE()))
        SELECT 0
    ELSE 
        SELECT 1
END
GO