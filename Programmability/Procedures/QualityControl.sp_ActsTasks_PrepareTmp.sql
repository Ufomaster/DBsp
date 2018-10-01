SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   03.04.2015$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   23.02.2016$*/
/*$Version:    1.00$   $Description: Подготовка редактирования задач в акте*/
CREATE PROCEDURE [QualityControl].[sp_ActsTasks_PrepareTmp]
    @ID Int
AS
BEGIN    
    INSERT INTO #ActsTasks(_ID, [Name], AssignedToEmployeeID, ControlEmployeeID,[Status],CreateDate, 
        Comment, TasksID, BeginFromDate)              
    SELECT
        d.ID, d.[Name], d.AssignedToEmployeeID, d.ControlEmployeeID, ISNULL(t.[Status], d.[Status]), d.CreateDate, 
        d.Comment, d.TasksID, d.BeginFromDate
    FROM [QualityControl].ActsTasks d
    LEFT JOIN Tasks t ON t.ID = d.TasksID
    WHERE d.ActID = @ID
END
GO