SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$    $Create date:   13.05.2011$
--$Modify:     Oleynik Yuriy$    $Modify date:   13.05.2011$
--$Version:    1.00$   $Description: Модификация отчета$
CREATE PROCEDURE [dbo].[sp_Reports_Update]
    @ID Bigint,
    @ReportGroupID Int = NULL,
--	@EmployeeID bigint = null,
    @SysName Varchar (50) = NULL,
    @Name Varchar (250) = NULL,
	--@CreateDate datetime = null,
    @ChangeDate Datetime = NULL,
	--@VersionMajor int = null,
	--@VersionMinor int = null,
    @Description Varchar (2048) = NULL,
    @Params Varchar (2048) = NULL,
    @Report Varbinary (MAX) = NULL,
    @OutID Bigint = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE @Err Int;
    BEGIN TRAN
    BEGIN TRY
        UPDATE Reports SET
            ReportGroupID = ISNULL(@ReportGroupID, ReportGroupID),
--            EmployeeID = ISNULL(@EmployeeID, EmployeeID),
            [SysName] = ISNULL(@SysName, [SysName]),
            [Name] = ISNULL(@Name, [Name]),
            --CreateDate = ISNULL(@CreateDate, CreateDate),
            ChangeDate = ISNULL(@ChangeDate, ChangeDate),
            VersionMajor = CASE
                               WHEN @Report IS NULL THEN VersionMajor
                           ELSE
                               CASE WHEN VersionMinor >=9999 THEN VersionMajor + 1 ELSE VersionMajor END
                           END,
            VersionMinor = CASE
                               WHEN @Report IS NULL THEN VersionMinor
                           ELSE
                               CASE WHEN VersionMinor >=9999 THEN 0 ELSE VersionMinor + 1 END
                           END,
            [Description] = ISNULL(@Description, [Description]),
            Params = ISNULL(@Params, Params),
            Report = ISNULL(@Report, Report)
        WHERE ID = @ID;

        SET @OutID = @ID;
        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR;
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        EXEC sp_RaiseError @ID = @Err;
        SET @OutID = -1;
    END CATCH
END
GO