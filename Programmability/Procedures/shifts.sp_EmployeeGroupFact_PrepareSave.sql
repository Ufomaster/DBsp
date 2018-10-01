SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   08.06.2015$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   18.09.2015$*/
/*$Version:    1.00$   $Decription: Чистка перед сохранением промежутков.$*/
CREATE PROCEDURE [shifts].[sp_EmployeeGroupFact_PrepareSave]
    @ArrayOfWorkPlaceID varchar(8000),
    @ShiftID int
AS
BEGIN
    SET NOCOUNT ON;
	SET XACT_ABORT ON
    
	DECLARE @Err Int
	BEGIN TRAN
	BEGIN TRY
        /*удаляем все по текущей связкуе Смена-РМ*/
        UPDATE a
        SET a.IsDeleted = 1
        FROM shifts.EmployeeGroupsFact a
        WHERE a.ShiftID = @ShiftID AND a.WorkPlaceID IN (SELECT ID FROM dbo.fn_StringToITable(@ArrayOfWorkPlaceID))
            AND a.AutoCreate = 0
        
        UPDATE b
        SET b.IsDeleted = 1
        FROM shifts.EmployeeGroupsFactDetais b
        WHERE b.EmployeeGroupsFactID IN (SELECT ID FROM shifts.EmployeeGroupsFact a
                                         WHERE a.ShiftID = @ShiftID 
                                         AND a.WorkPlaceID IN (SELECT ID FROM dbo.fn_StringToITable(@ArrayOfWorkPlaceID))
                                         AND a.AutoCreate = 0
                                         )
        
		COMMIT TRAN        
        
	END TRY
	BEGIN CATCH
		SET @Err = @@ERROR;
		IF @@TRANCOUNT > 0 ROLLBACK TRAN;
		EXEC sp_RaiseError @ID = @Err;
	END CATCH;
END
GO