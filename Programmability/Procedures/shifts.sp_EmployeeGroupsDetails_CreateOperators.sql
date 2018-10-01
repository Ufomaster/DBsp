SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   14.05.2014$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   14.05.2014$*/
/*$Version:    1.00$   $Decription: $*/
create PROCEDURE [shifts].[sp_EmployeeGroupsDetails_CreateOperators]
    @ArrayOfEmployeeID varchar(8000) 
AS
BEGIN
    SET NOCOUNT ON;
    
    /*DelphiConst = 'urOperatorAssignableRole' ID = 4*/
    DECLARE @RoleID INT
    
	SET XACT_ABORT ON
	DECLARE @Err Int
	BEGIN TRAN
	BEGIN TRY
        SELECT @RoleID = a.RoleID
        FROM UserRightsObjectRights a
        WHERE a.ObjectID = 4 AND a.RightValue = 3
        
        IF @RoleID IS NULL 
           RAISERROR('Роль оператора не создана',16, 1) 

        DECLARE @T table (ID int)

        INSERT INTO Users(EmployeeID, [Login], [Password]) 
        OUTPUT INSERTED.ID INTO @T
        SELECT i.ID, e.FullName, ''
        FROM dbo.fn_StringToITable(@ArrayOfEmployeeID) i
        INNER JOIN vw_Employees e ON e.ID = i.ID
        LEFT JOIN Users u ON u.EmployeeID = e.ID
        WHERE u.ID IS NULL

        INSERT INTO RoleUsers(RoleID, UserID)
        SELECT @RoleID, a.ID 
        FROM @T a
        LEFT JOIN RoleUsers ru ON ru.RoleID = @RoleID AND ru.UserID = a.ID
        WHERE ru.ID IS NULL

		COMMIT TRAN        
	END TRY
	BEGIN CATCH
		SET @Err = @@ERROR;
		IF @@TRANCOUNT > 0 ROLLBACK TRAN;
		EXEC sp_RaiseError @ID = @Err;
	END CATCH;
END
GO