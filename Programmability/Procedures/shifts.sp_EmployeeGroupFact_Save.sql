SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   02.06.2015$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   18.09.2015$*/
/*$Version:    1.00$   $Decription: Сохранение промежутков.$*/
CREATE PROCEDURE [shifts].[sp_EmployeeGroupFact_Save]
    @StartDate datetime,
    @EndDate datetime,
    @ArrayOfEmployeeID varchar(1000),
    @WorkPlaceID int,
    @ShiftID int
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ID int, @IP varchar(50)
    DECLARE @t TABLE(ID int)
	SET XACT_ABORT ON
    
	DECLARE @Err Int
	BEGIN TRAN
	BEGIN TRY
        SELECT @IP = s.IP 
        FROM manufacture.StorageStructure s
        WHERE s.ID = @WorkPlaceID
        
        INSERT INTO shifts.EmployeeGroupsFact(StartDate, EndDate, IP, WorkPlaceID, ShiftID, AutoCreate)
        OUTPUT INSERTED.ID INTO @t
        SELECT @StartDate, @EndDate, @IP, @WorkPlaceID, @ShiftID, 0
        
        SELECT @ID = ID FROM @t
        
        INSERT INTO shifts.EmployeeGroupsFactDetais(EmployeeGroupsFactID, EmployeeID)
        SELECT @ID, ID
        FROM dbo.fn_StringToITable(@ArrayOfEmployeeID)
		COMMIT TRAN        
	END TRY
	BEGIN CATCH
		SET @Err = @@ERROR;
		IF @@TRANCOUNT > 0 ROLLBACK TRAN;
		EXEC sp_RaiseError @ID = @Err;
	END CATCH;
END
GO