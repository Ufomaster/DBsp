SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   13.08.2012$*/
/*$Modify:     Yuriy Oleynik$    		$Modify date:   12.02.2016$*/
/*$Version:    2.00$   $Decription: Редактирование объекта в структуре склада$*/
CREATE PROCEDURE [manufacture].[sp_StorageStructure_Modify]
    @NodeID Int,
    @Name varchar(255),
    @NodeImageIndex Int,
    @IP varchar(255),
    @HiddenForSelect bit
AS
BEGIN
	SET NOCOUNT ON
    
    --Проверка на дубликаты имени
    IF EXISTS(SELECT * FROM manufacture.StorageStructure ss 
    		  WHERE IsNull(ss.ParentID,0) = (SELECT IsNull(ParentID,0) FROM manufacture.StorageStructure WHERE ID = @NodeID)
              	    AND ss.[Name] = @Name
                    AND ss.ID <> @NodeID)
    BEGIN
        RAISERROR ('Объект с таким именем уже существует на данном уровне дерева. Добавление одинаковых объектов на одном уровне запрещено.', 16, 1)
    END
    ELSE BEGIN
        UPDATE manufacture.StorageStructure
        SET NodeImageIndex = @NodeImageIndex,
            [Name] = @Name,
            IP = @IP, 
            HiddenForSelect = @HiddenForSelect
        WHERE ID = @NodeID
    END
END
GO