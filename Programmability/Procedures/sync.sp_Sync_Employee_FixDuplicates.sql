SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   13.08.2015$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   13.08.2015$*/
/*$Version:    1.00$   $Decription: Лекарство от  дубликатов. меняем @NewID и @OldID для 1-го емплоии. $*/
CREATE PROCEDURE [sync].[sp_Sync_Employee_FixDuplicates]
    @NewID int, 
    @OldID int,
    @DeleteRec bit = 1
AS
BEGIN
    RETURN
    SET NOCOUNT ON
    DECLARE @TableName varchar(255),  @object_id int, @UpdateColumn varchar(255),
         @Query varchar(800)

    DECLARE Cur CURSOR LOCAL FOR 
                              SELECT ss.[name] + '.' + s.[name] AS TableName,  a.object_id
                              FROM sys.foreign_keys a
                              INNER JOIN sys.objects s ON s.object_id = a.parent_object_id
                              INNER JOIN sys.schemas ss ON ss.schema_id = s.schema_id
                              INNER JOIN sys.objects ps ON ps.object_id = a.referenced_object_id
                              WHERE ps.Name Like 'Employees' and a.delete_referential_action_desc = 'NO_ACTION'
    OPEN Cur
    FETCH NEXT FROM Cur INTO @TableName, @object_id
    WHILE @@FETCH_STATUS = 0 
    BEGIN
        /*LinkColomn    */
        SELECT @UpdateColumn = s.name
        FROM sys.foreign_key_columns a
        LEFT JOIN sys.[columns] s ON s.object_id = a.parent_object_id AND s.column_id = a.parent_column_id
        WHERE a.constraint_object_id = @object_id
        
        SELECT @Query = ' UPDATE ' + @TableName + ' SET ' + @UpdateColumn + ' = ' + CAST(@NewID AS varchar) + ' WHERE ' + @UpdateColumn + ' = ' + CAST(@OldID AS varchar)
        
        EXEC(@Query)
        FETCH NEXT FROM Cur INTO @TableName, @object_id  
    END
    CLOSE Cur
    DEALLOCATE CUR
    IF @DeleteRec = 1    
        DELETE FROM Employees WHERE ID = @OldID
END
GO