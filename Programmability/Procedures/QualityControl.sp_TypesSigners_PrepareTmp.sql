SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   06.11.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   06.11.2013$*/
/*$Version:    1.00$   $Description: Подготовка редактирования подписчиков типа протокола$*/
create PROCEDURE [QualityControl].[sp_TypesSigners_PrepareTmp]
    @TypeID Int
AS
BEGIN
    INSERT INTO #TypesSigners(_ID, EmailOnly, DepartmentPositionID)
    SELECT
        s.ID, s.EmailOnly, s.DepartmentPositionID
    FROM [QualityControl].TypesSigners s
    WHERE s.TypesID = @TypeID
END
GO