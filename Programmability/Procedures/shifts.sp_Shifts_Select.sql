SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   17.01.2014$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   30.03.2017$*/
/*$Version:    1.00$   $Decription: Смены. Выборка данных.$*/
CREATE PROCEDURE [shifts].[sp_Shifts_Select]
    @TypesID int,
    @Date datetime
AS
BEGIN
    SELECT @Date = dbo.fn_DateCropTime(@Date)
    SELECT
    /*    ROW_NUMBER() OVER (ORDER BY dbo.fn_DateCropTime(s.PlanStartDate)) AS ID,
        dbo.fn_DateCropTime(s.PlanStartDate) AS EventDate*/
        s.*,
        CASE WHEN s.FactStartDate IS NOT NULL AND s.FactEndDate IS NULL THEN 0 ELSE NULL END AS StatusImage,
        sg.Name AS GroupName,
        CASE WHEN s.Sign1Date IS NULL THEN NULL ELSE 1 END AS Sign1,
        CASE WHEN s.Sign2Date IS NULL THEN NULL ELSE 1 END AS Sign2,
        stn.Ico,
        stn.Name AS ShiftsTypesNames,
        RIGHT('00' + CAST(DATEPART(hh, st.TimeStart) AS varchar(2)), 2) + ':' + RIGHT('00' + CAST(DATEPART(mi, st.TimeStart) AS varchar(2)), 2) + ' - ' +
        RIGHT('00' + CAST(DATEPART(hh, st.TimeEnd) AS varchar(2)), 2) + ':' + RIGHT('00' + CAST(DATEPART(mi, st.TimeEnd) AS varchar(2)), 2) AS TimeString,
        
        sg.Name + ' ' + stn.Name + ' ' + RIGHT('00' + CAST(DATEPART(hh, st.TimeStart) AS varchar(2)), 2) + ':' + RIGHT('00' + CAST(DATEPART(mi, st.TimeStart) AS varchar(2)), 2) + ' - ' +
        RIGHT('00' + CAST(DATEPART(hh, st.TimeEnd) AS varchar(2)), 2) + ':' + RIGHT('00' + CAST(DATEPART(mi, st.TimeEnd) AS varchar(2)), 2) AS FullName
    FROM shifts.Shifts s
        INNER JOIN shifts.ShiftsTypes st ON st.ID = s.ShiftTypeID
        INNER JOIN shifts.ShiftsGroups sg ON sg.ID = st.ShiftsGroupsID
        LEFT JOIN shifts.ShiftsTypesNames stn ON stn.ID = st.ShiftsTypesNamesID
    WHERE ISNULL(s.IsDeleted, 0) = 0 AND    
         ISNULL(sg.ManufactureStructureID, st.ManufactureStructureID) = @TypesID 
                                              AND ( dbo.fn_DateCropTime(s.PlanStartDate) = @Date OR
                                                    dbo.fn_DateCropTime(s.PlanEndDate) = @Date OR /*
                                                    dbo.fn_DateCropTime(s.FactStartDate) = @Date OR
                                                    dbo.fn_DateCropTime(s.FactEndDate) = @Date OR*/
                                                    (s.FactEndDate IS NULL AND s.FactStartDate IS NOT NULL))
END
GO