SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$    $Create date:   13.05.2011$
--$Modify:     Oleynik Yuriy$    $Modify date:   13.05.2011$
--$Version:    1.00$   $Description: Добавление отчета$
CREATE PROCEDURE [dbo].[sp_Reports_Insert]
    --@ID int OUTPUT,
    @ReportGroupID Int,
	--@EmployeeID bigint,
    @Name Varchar(250) ,
	--@VersionMajor int,
	--@VersionMinor int,
    @Description Varchar(2048),
    @Params Varchar(2048) = NULL,
    @Report Varbinary(MAX) = NULL,
    @OutID Bigint = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON
    BEGIN TRY
    BEGIN TRAN
        --DECLARE @Employee bigint
        DECLARE @t TABLE(ID Bigint);
        --SELECT @Employee = EmployeeID FROM Users WHERE UserName = SUSER_NAME()

        INSERT INTO Reports(ID, ReportGroupID, /*EmployeeID,*/ NAME, CreateDate, ChangeDate,
            VersionMajor, VersionMinor, Description, Params, Report)
        OUTPUT INSERTED.ID INTO @t
        SELECT ISNULL(MAX(ID), 0) + 1, @ReportGroupID, /*@EmployeeID,*/ @Name, getdate(), getdate(),
            1, 0, @Description, @Params, @Report
        FROM Reports

        SELECT @OutID = ID FROM @t;
        IF (@@TRANCOUNT > 0) COMMIT TRAN
    END TRY
    BEGIN CATCH
        DECLARE @Err Int
        SET @Err = @@ERROR;
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        EXEC sp_RaiseError @ID = @Err;
        SET @OutID = -1;
        RETURN -1
    END CATCH
END
GO