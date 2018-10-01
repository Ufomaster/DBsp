SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   13.08.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   13.08.2012$*/
/*$Version:    1.00$   $Decription: Возврат элементов хранилища$*/
create PROCEDURE [unknown].[sp_AStorageStructure_TakeIn]
    @Number Varchar(255),
    @EmployeeID Int
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @ID Int, @InOutID Int
    SELECT @ID = a.ID FROM AStorageStructure a
    WHERE a.Number = @Number
    
    SELECT @InOutID = ID FROM AStorageStructureInOut 
    WHERE AStorageStructureID = @ID AND InDate IS NULL

    IF @ID IS NULL
    BEGIN
        SELECT 1 /* error элемент не найден*/
        RETURN
    END
    
    IF @InOutID IS NULL
    BEGIN
        SELECT 2 /* error элемент не выдавался*/
        RETURN
    END

    UPDATE AStorageStructureInOut
    SET InDate = GetDate(), 
        InEmployeeID =  @EmployeeID    
    WHERE AStorageStructureID = @ID

    SELECT 0
END
GO