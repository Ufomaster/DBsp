SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$    $Create date:   03.03.2017$
--$Modify:     Oleynik Yuriy$    $Modify date:   03.03.2017$
--$Version:    1.00$   $Description: ТМЦ$
CREATE PROCEDURE [dbo].[sp_TmcPCC_Insert]
    @Name varchar(255),
    @TMCID int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT @Name = RIGHT(@Name, LEN(@Name)-PATINDEX('%[0-9]%',@Name) + 1)
    SELECT @Name = RIGHT(REVERSE(@Name), LEN(REVERSE(@Name))-PATINDEX('%[0-9]%',REVERSE(@Name)) + 1)
    SELECT @Name = REPLACE(REVERSE(@Name), '/', ',')
    DELETE FROM TmcPCC
    WHERE TmcID = @TmcID
    
    INSERT INTO TmcPCC(TmcID, ProductionCardCustomizeID, CardCount)
    SELECT @TMCID, pc.ID, FLOOR(24/(SELECT COUNT(ID) FROM dbo.fn_StringToSTable(@Name) WHERE ID LIKE '%[0-9][0-9][0-9][0-9]%' OR ID LIKE '%[0-9][0-9][0-9][0-9][0-9]%'))
    FROM dbo.fn_StringToSTable(@Name) a
    INNER JOIN ProductionCardCustomize pc ON pc.Number = a.ID AND pc.StatusID NOT IN (6,7,9,10,11)
    WHERE a.ID LIKE '%[0-9][0-9][0-9][0-9]%' OR a.ID LIKE '%[0-9][0-9][0-9][0-9][0-9]%'  
END
GO