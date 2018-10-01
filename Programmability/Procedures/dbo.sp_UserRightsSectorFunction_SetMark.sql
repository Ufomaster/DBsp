SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   24.04.2017$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   24.04.2017$*/
/*$Version:    1.00$   $Decription: Установка доступа емплоии на функцию на конкретный участок*/
create PROCEDURE [dbo].[sp_UserRightsSectorFunction_SetMark]
    @FieldName varchar(50),
    @EmployeeID int,
    @SectorID tinyint,
    @Value bit
AS
BEGIN
    DECLARE @Query Varchar(8000) 
    IF NOT EXISTS(SELECT ID FROM manufacture.StorageStructureSectorFunctionRights WHERE EmployeeID = @EmployeeID AND SectorID = @SectorID)
        SELECT @Query = 'INSERT INTO manufacture.StorageStructureSectorFunctionRights(EmployeeID, SectorID) SELECT ' + 
          CAST(@EmployeeID AS varchar) + ', ' + CAST(@SectorID AS varchar)

    SELECT @Query = ISNULL(@Query, '') + '    UPDATE manufacture.StorageStructureSectorFunctionRights
    SET ' + @FieldName + ' = ' + CASE @Value WHEN 1 THEN '0' WHEN 0 THEN '1' END + '
    WHERE EmployeeID = ' + CAST(@EmployeeID AS varchar) + ' AND SectorID = ' + CAST(@SectorID AS varchar)
    
    EXEC(@Query) 
   -- SELECT @Query
END
GO