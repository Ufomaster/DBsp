SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   30.01.2017$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   30.01.2017$*/
/*$Version:    1.00$   $Description: Вьюшка с данными департаментов для фильтра выборки операторов*/
create VIEW [dbo].[vw_DepartmentsOfOperators]
AS
    SELECT 
        ID, Name
    FROM dbo.Departments
    WHERE ID IN (79,80,81,82,25,98)
GO