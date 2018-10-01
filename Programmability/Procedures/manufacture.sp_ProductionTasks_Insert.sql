SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   19.02.2016$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   21.04.2016$*/
/*$Version:    1.00$   $Decription: Поиск и создание сменного задания. Автоматическое$*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_Insert]
    @SectorID int,
    @ShiftID int
AS
BEGIN
    DECLARE @ID int
    DECLARE @T table(ID int)
    
    IF @SectorID IS NULL OR @ShiftID IS NULL
    BEGIN
        SELECT 0 AS ID
        RETURN
    END
    
    SET @ID = NULL
    SELECT @ID = pt.ID
    FROM manufacture.ProductionTasks pt 
    WHERE pt.ShiftID = @ShiftID AND pt.StorageStructureSectorID = @SectorID
    
    IF @ID IS NULL BEGIN
        INSERT INTO manufacture.ProductionTasks(CreateDate, StorageStructureSectorID, ShiftID)
        OUTPUT INSERTED.ID INTO @T
        SELECT GetDate(), @SectorID, @ShiftID
        
        SELECT @ID = ID FROM @T
    END

    SELECT @ID AS ID
END
GO