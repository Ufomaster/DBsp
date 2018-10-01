SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   07.08.2012$*/
/*$Modify:     Zapadinskiy Anatoliy$    $Modify date:   07.08.2012$*/
/*$Version:    1.00$   $Decription: Проверяем можем ли добавить объект в схему $*/
create PROCEDURE [unknown].[sp_AStorageScheme_Check]
    @ActiveTreeID Int,
    @AStorageItemID Int,
    --позволяет провести проверку для перемещений
    @NodeID int = null
AS
BEGIN
    DECLARE @AStorageItemTypeID int, @AStorageItemTypeName varchar(100)    
    CREATE TABLE #T(ID Int, ParentID int, NodeOrder int, Sort varchar(255))
    SET NOCOUNT ON
	
    --1 проверка - чтобы в дереве выше не было такого же типа
    --получаем тип объекта, который планируем вставить
    SELECT @AStorageItemTypeID = sit.ID,
           @AStorageItemTypeName = sit.[Name]
    FROM AStorageItems si
        INNER JOIN AStorageItemsTypes sit on sit.ID = si.AStorageItemsTypeID
    WHERE si.ID = @AStorageItemID    
    	
    /*Получаем узлы дерева выше @ActiveTreeID*/
    SELECT
        ss.ID,
        ss.ParentID,
        ss.NodeOrder
    INTO #tmp
    FROM AStorageScheme ss;

    WITH ResultTable (ID, ParentID, NodeOrder, Sort)
    AS
    (
     --Anchor member definition
        SELECT
            ID, ParentID, NodeOrder,
            CONVERT(Varchar(MAX), RIGHT(REPLICATE('0',10 - LEN(CAST(NodeOrder AS Varchar(10)))) + cast(NodeOrder AS Varchar(10)), 10)) AS [Sort]
        FROM #tmp e
        WHERE ID = @ActiveTreeID

        UNION ALL
     --Recursive member definition

        SELECT
            e.ID, e.ParentID, e.NodeOrder,
            CONVERT (Varchar(MAX), RTRIM(Sort) + '|' + RIGHT(REPLICATE('0',10 - LEN(cast(e.NodeOrder AS Varchar(10)))) + cast(e.NodeOrder AS Varchar(10)), 10)) AS [Sort]
        FROM #tmp AS e
        INNER JOIN ResultTable AS d
            ON e.ID = d.ParentID
    )
    
    INSERT INTO #T
    SELECT ID, ParentID, NodeOrder, Sort
    FROM ResultTable
                   
    --если проверяем узел, который является корнем ветки, то надо проверить всех его чаилдов
    IF @NodeID is not NULL
    BEGIN   
        --для этого связываем все элементы выше со всеми элементами ниже узла (аналог CROSS JOIN только при нуле вернет то же, что и было)
        IF EXISTS(SELECT t.ID
                  FROM #T as t
                       LEFT JOIN(SELECT ss.ID, ss.ParentID, ss.NodeOrder
                                    --получаем список чаилдов
                                 FROM fn_AStorageSchemeNode_Select(@NodeID) as node
                                      LEFT JOIN AStorageScheme as ss on ss.ID = node.ID) as tab on tab.ID<>-1
                      LEFT JOIN AStorageScheme ss on t.ID = ss.ID
                      LEFT JOIN AStorageItems si on si.ID = ss.AStorageItemID
                      LEFT JOIN AStorageScheme ss1 on tab.ID = ss1.ID
                      LEFT JOIN AStorageItems si1 on si1.ID = ss1.AStorageItemID
                  WHERE si.AStorageItemsTypeID=si1.AStorageItemsTypeID)         
        RAISERROR ('Объект данного типа уже присутствует в дереве выше уровнем. Добавление/перемещение запрещено.', 16, 1)                                 
    END    
    ELSE
    BEGIN                       
        --В полученной таблице не должно быть объектов того-же типа
        IF EXISTS(SELECT top 1 si.[Name]
                  FROM #t t                       
	                  LEFT JOIN AStorageScheme ss on t.ID = ss.ID
                      LEFT JOIN AStorageItems si on si.ID = ss.AStorageItemID
                  WHERE si.AStorageItemsTypeID = @AStorageItemTypeID)    
            RAISERROR ('Объект данного типа уже присутствует в дереве выше уровнем. Добавление/перемещение запрещено.', 16, 1)
    END        
    --2 проверка - чтобы на данном уровне дерева не було таких же объектов
	IF EXISTS(SELECT *
              FROM AStorageScheme ss        
              WHERE ss.ParentID = @ActiveTreeID
                    AND ss.AStorageItemID = @AStorageItemID)
        RAISERROR ('Такой же объект уже находится на данном уровне дерева. Добавление одинаковых объектов на одном уровне запрещено.', 16, 1)                    
    
    DROP TABLE #t
    DROP TABLE #tmp
    SELECT @AStorageItemID 
END
GO