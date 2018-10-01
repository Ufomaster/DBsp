SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   13.08.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   13.08.2012$*/
/*$Version:    1.00$   $Decription: Выдача элементов хранилища$*/
create PROCEDURE [unknown].[sp_AStorageStructure_TakeOut]
    @Number Varchar(255),
    @Type Int,
    @EmployeeID Int
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @ID Int
    IF @type = 0 OR @type = 1
        SELECT @ID = a.ID FROM AStorageStructure a
        WHERE a.Number = @Number
    IF @type = 2
        SELECT @ID = a.ID FROM AStorageStructure a
        WHERE a.MetaData = @Number
    
    IF @ID IS NULL
    BEGIN
        SELECT 1 -- error элемент не найден
        RETURN
    END
 
    IF (@type <> 1) AND EXISTS(SELECT * FROM AStorageStructureInOut WHERE AStorageStructureID = @ID AND InDate IS NULL)
    BEGIN
        SELECT 2 --Error элмент уже выдан
        RETURN
    END
    ELSE
    IF (@type = 1) AND EXISTS(SELECT i.* 
                              FROM AStorageStructureInOut i
                              INNER JOIN AStorageStructure ss ON ss.ParentID = @ID AND i.AStorageStructureID = ss.ID
                              WHERE i.InDate IS NULL)
    BEGIN
        SELECT 3 --Error элементы уже выданы
        RETURN
    END

    IF (@type <> 1)
    BEGIN
        INSERT INTO AStorageStructureInOut([AStorageStructureID], [OutDate], [OutEmployeeID])
        SELECT @ID, GetDate(), @EmployeeID
        
        SELECT 0
    END
    ELSE
    IF (@type = 1)
    BEGIN
        INSERT INTO AStorageStructureInOut([AStorageStructureID], [OutDate], [OutEmployeeID])
        SELECT ID, GetDate(), @EmployeeID
        FROM AStorageStructure 
        WHERE ParentID = @ID

        SELECT 0
    END    
END
GO