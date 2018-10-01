SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Anatoliy Zapadinskiy$	$Create date:   11.05.2012$
--$Modify:     Oleynik Yuriy$	$Modify date:   03.10.2012$
--$Version:    1.01$   $Decription: Сохранение истории ObjectTypes$
CREATE PROCEDURE [dbo].[sp_TmcTreeHistory_Insert]
    @ObjectTypeID Int,
    @EmployeeID Int,
    @OperationType Int    /*0-insert, 1-update, 2-delete*/    
AS
BEGIN
    INSERT INTO dbo.ObjectTypesHistory(ObjectTypeID, [Name], XMLSchema, ModifyEmployeeID, OperationTypeID)
    SELECT 
        ID,
    	[Name],
        XMLSchema,
        @EmployeeID,
        @OperationType
	FROM ObjectTypes
    WHERE ID = @ObjectTypeID
END
GO