SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$    $Create date:   22.09.2011$
--$Modify:     Yuriy Oleynik$    $Modify date:   19.03.2012$
--$Version:    1.00$   $Decription: Проверка версий$
CREATE PROCEDURE [dbo].[sp_Versions_Check]
    @ID Int,
    @Type Int,
    @Major Int,
    @Minor Int
AS
BEGIN
    IF @Type = 0 
    BEGIN
        SELECT
            v.ID, 
            v.Major, 
            v.Minor, 
            CAST(v.Major AS Varchar) + '.' + RIGHT('0' + CAST(v.Minor AS Varchar), 2) AS Version,
            CASE WHEN v.Major = @Major AND v.Minor = @Minor THEN 1 ELSE 0 END AS isValid,
            CASE WHEN v.UpdateTime < GetDate() THEN DATEADD(n, 10, GetDate()) 
            ELSE v.UpdateTime 
            END AS UpdateTime,
            GetDate() AS ServerDate            
        FROM dbo.Versions v
        WHERE v.ID = @ID
    END
    ELSE
    IF @Type = 1
    BEGIN
        SELECT 
            v.ID,
            v.DBMajor, 
            v.DBMinor, 
            CAST(v.DBMajor AS Varchar) + '.' + RIGHT('0' + CAST(v.DBMinor AS Varchar), 2) AS Version,
            CASE WHEN v.DBMajor = @Major AND v.DBMinor = @Minor THEN 1 ELSE 0 END AS isValid,
            CASE WHEN v.UpdateTime < GetDate() THEN DATEADD(n, 10, GetDate()) 
            ELSE v.UpdateTime 
            END AS UpdateTime,
            GetDate() AS ServerDate
        FROM dbo.Versions v
        WHERE v.ID = @ID
    END
END
GO