SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   03.08.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   03.08.2012$*/
/*$Version:    1.00$   $Decription: резервирование номеров$*/
create PROCEDURE [unknown].[sp_AStorageScheme_Reservate]
    @ReservCount Int, 
    @ItemID Int, 
    @TypeID Int,
    @EmployeeID Int
AS
BEGIN
    SET NOCOUNT ON   
    INSERT INTO dbo.AStorageStructureReserv(AStorageItemsID, LastIndex, ReservCount, EmployeeID)
    SELECT @ItemID, LastIndex, @ReservCount, @EmployeeID 
    FROM AStorageItemsTypes 
    WHERE ID = @TypeID
    
    UPDATE AStorageItemsTypes 
    SET LastIndex = LastIndex + @ReservCount 
    WHERE ID = @TypeID
END
GO