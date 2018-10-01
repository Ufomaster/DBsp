SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   25.11.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   25.11.2013$*/
/*$Version:    1.00$   $Description: Добавление подписантов в темп таблицу при создании протокола$*/
create PROCEDURE [QualityControl].[sp_Protocols_InsertEmployeeTmpDetails]
    @TypesID Int
AS
BEGIN
    INSERT INTO #ProtocolsSigners(_ID, EmployeeID, EmailOnly, SignDate)
    SELECT
        s.ID, e.ID, s.EmailOnly, NULL
    FROM [QualityControl].TypesSigners s
    INNER JOIN dbo.vw_Employees e ON e.DepartmentPositionID = s.DepartmentPositionID
    WHERE s.TypesID = @TypesID
    ORDER BY s.ID
END
GO