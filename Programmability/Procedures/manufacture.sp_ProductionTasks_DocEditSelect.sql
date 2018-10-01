SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   10.03.2016$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   26.08.2016$*/
/*$Version:    1.00$   $Decription: Выборка для редактирования документов$*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_DocEditSelect]
    @ID int
AS
BEGIN
    SELECT d.*,
        CanBeEdited = 1,
        CanBeDeleted = 
            CASE 
                WHEN MaxID.ID IS NULL OR con.ID IS NOT NULL OR d.ProductionTasksOperTypeID = 7 THEN 0
            ELSE 1
            END 
    FROM manufacture.ProductionTasksDocs d
    LEFT JOIN  manufacture.ProductionTasksDocs con ON con.ID = d.LinkedProductionTasksDocsID OR con.LinkedProductionTasksDocsID = d.ID
    LEFT JOIN (SELECT MAX(ID) AS ID FROM manufacture.ProductionTasksDocs WHERE ProductionTasksID = @ID) AS MaxID ON MaxID.ID = d.ID
    WHERE d.ProductionTasksID = @ID
END
GO