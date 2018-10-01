SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   09.07.2015$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   04.08.2015$*/
/*$Version:    1.00$   $Description: Копирование связки свойств производства$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardProperties_Copy]
    @ID Int, /*Копируемый ИД.*/
    @TargetID int /*Куда копируем.*/
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @Err Int, @Order Int, @Level Int, @OutID int, @SObjectTypeID int, @TObjectTypeID int
   --проверки. копирование значения в справочник - можно разрешить.
     --копирование справочника в значение можно разрешить.
    SET @OutID = @TargetID
    SELECT @SObjectTypeID = p.ObjectTypeID
    FROM ProductionCardProperties p 
    WHERE p.ID = @ID
    SELECT @TObjectTypeID = p.ObjectTypeID
    FROM ProductionCardProperties p 
    WHERE p.ID = @TargetID    
   --проверяем нельзя копировать значение в значение
    IF EXISTS(SELECT a.AttributeID
              FROM ProductionCardProperties p 
              INNER JOIN ObjectTypesAttributes a ON a.ObjectTypeID = p.ObjectTypeID AND a.AttributeID = 5
              WHERE p.ID = @TargetID)
       AND
       EXISTS(SELECT a.AttributeID
              FROM ProductionCardProperties p 
              INNER JOIN ObjectTypesAttributes a ON a.ObjectTypeID = p.ObjectTypeID AND a.AttributeID = 5
              WHERE p.ID = @ID)
        RAISERROR ('Копирование значения в значение запрещено.', 16, 1)
    ELSE
    --проверяем нельзя копировать справочник в справочник
    IF EXISTS(SELECT a.AttributeID
              FROM ProductionCardProperties p 
              INNER JOIN ObjectTypesAttributes a ON a.ObjectTypeID = p.ObjectTypeID AND a.AttributeID = 4
              WHERE p.ID = @TargetID)
       AND
       EXISTS(SELECT a.AttributeID
              FROM ProductionCardProperties p 
              INNER JOIN ObjectTypesAttributes a ON a.ObjectTypeID = p.ObjectTypeID AND a.AttributeID = 4
              WHERE p.ID = @ID)
        RAISERROR ('Копирование справочник в справочник запрещено.', 16, 1)
    ELSE     
    --проверяем чтобы не копировали уже существующие значения внутри одного справочника.
    IF EXISTS(SELECT p.ID
              FROM ProductionCardProperties p
              WHERE p.ParentID = @TargetID AND p.ObjectTypeID = @SObjectTypeID)
        RAISERROR ('Копирование дублирующих значений в справочнике запрещено.', 16, 1)
    ELSE
    --проверяем чтобы не копировали себя в себя.
    IF @TargetID = @ID
        RAISERROR ('Копирование внутрь копируемого элемента запрещено.', 16, 1)
    ELSE
    --проверяем чтобы не копировали "не родные" значения в справочник.
    IF EXISTS(SELECT a.AttributeID
              FROM ProductionCardProperties p 
              INNER JOIN ObjectTypesAttributes a ON a.ObjectTypeID = p.ObjectTypeID AND a.AttributeID = 5
              WHERE p.ID = @ID) --копируется значение               
       AND       
       EXISTS(SELECT o.ID
              FROM ObjectTypes o
              WHERE o.ID = @SObjectTypeID AND o.ParentID <> @TObjectTypeID)
        RAISERROR ('Копирование чужих значений в справочнике запрещено.', 16, 1)
    ELSE    
    BEGIN              
        SET XACT_ABORT ON
        BEGIN TRAN
        BEGIN TRY    
             /*Заполняем врменную таблицу через WITH. Там должно быть то что копируем.*/
             /*Далее нужно сгенерировать новые айди - вставить записи.*/
             /*Раскидать парент ИД новых записей в соответствии со старыми.*/           
            ;WITH ResultTable (ID, ParentID, NodeLevel, NodeOrder, ObjectTypeID, NodeExpanded, Sort)
                AS
                (
                  /* Anchor member definition*/
                  SELECT
                      ID, ParentID, NodeLevel, NodeOrder,
                      ObjectTypeID,
                      NodeExpanded
                      /*,CONVERT(Varchar(300), RIGHT(REPLICATE('0',2 - LEN(CAST(e.NodeOrder AS Varchar(2)))) + CAST(e.NodeOrder AS Varchar(2)), 2))*/
                      ,CONVERT(Varchar(300), RIGHT('00' + CAST(e.NodeOrder AS Varchar(2)), 2))            
                  FROM ProductionCardProperties e
                  WHERE ID = @ID
                  UNION ALL
                  /* Recursive member definition*/
                  SELECT
                      e.ID, e.ParentID, e.NodeLevel, e.NodeOrder, e.ObjectTypeID, e.NodeExpanded
                      /*, CONVERT (Varchar(300), d.Sort /*+ '|'*/ + RIGHT(REPLICATE('0',2 - LEN(CAST(e.NodeOrder AS Varchar(2)))) + CAST(e.NodeOrder AS Varchar(2)), 2))*/
                      ,CONVERT(Varchar(300), d.Sort + RIGHT('00' + CAST(e.NodeOrder AS Varchar(2)), 2))
                  FROM ProductionCardProperties AS e
                  INNER JOIN ResultTable AS d ON e.ParentID = d.ID
                )
            --запомнили все что скопировали.
            SELECT * INTO #WithResult 
            FROM ResultTable
        
            --запомним ордер и левел парента.
            SELECT @Order = p.NodeOrder, @Level = p.NodeLevel
            FROM ProductionCardProperties p 
            WHERE p.ID = @TargetID
        
            --обрабатываем 
            --Можем тнуть мышей в любой нод для вставки. Вот тут есть правила - справочник можно кинуть только в значение, 
            -- а значение только в справочник, причем тот-же, но можно и подтянуть родителя в случае если справочник чужой,
            --вверху проверка отсечет кидание в справочник, поэтому обходим 2 варианта.
            --1) кинули значение в занчение
            --2) кинули справочник в значение

            /* создаем таблицу связок новых айди со старыми через временную таблицу со вставкой нужных данных в #tmp*/
            CREATE TABLE #PCP(ID Int IDENTITY(1, 1) NOT NULL,[ParentID] Int, Old_ID Int)
            /* таблица данных New_ID и Old_ID*/
            CREATE TABLE #tmp(New_ID Int, Old_ID Int)
            /*поскольку айдишку нужно начислить с некоего максимального идентификатора установим значение идентити в темповой таблице*/
            /* до нужного значения которое берем из ProductionCardProperties*/
            DECLARE @new_reseed_value Int SELECT @new_reseed_value = ISNULL(MAX(ID), 1) + 1 FROM ProductionCardProperties
            DBCC CHECKIDENT ('#PCP', RESEED, @new_reseed_value)
            
            /* генерим данные идентификаторов*/
            INSERT INTO #PCP(ParentID, Old_ID)
            OUTPUT INSERTED.ID, INSERTED.Old_ID INTO #tmp
            SELECT
                p.ParentID,
                p.ID
            FROM #WithResult p
            ORDER BY p.Sort

            /* наконец отключаем автонумерацию идентити и постим копию нашего дерева с новыми айдишками*/
            SET IDENTITY_INSERT dbo.ProductionCardProperties ON

            --помним что левел изменился. 
            INSERT INTO ProductionCardProperties([ID], [ParentID], [ObjectTypeID],
            [NodeExpanded], [NodeLevel], [NodeOrder])
            SELECT 
                tmp.New_ID,
                ISNULL(tmp2.New_ID, @TargetID),
                p.ObjectTypeID,
                p.NodeExpanded,
                @Level + LEN(Sort)/2 AS NewLevel, --генерим новый ЛЕВЕЛ. УВАГА - участвует Sort из WITH
                CASE WHEN tmp2.New_ID IS NULL THEN /*it is copying node*/(SELECT ISNULL(MAX(NodeOrder), 0) + 1 FROM ProductionCardProperties WHERE ParentID = @TargetID)
                ELSE p.NodeOrder
                END
            FROM #WithResult p
            LEFT JOIN #tmp tmp ON tmp.Old_ID = p.ID
            LEFT JOIN #tmp tmp2 ON tmp2.Old_ID = p.ParentID
            WHERE (tmp.Old_ID IS NOT NULL OR tmp2.Old_ID IS NOT NULL)
            ORDER BY p.Sort

            SELECT @OutID = tmp.New_ID
            FROM #WithResult p
            LEFT JOIN #tmp tmp ON tmp.Old_ID = p.ID
            LEFT JOIN #tmp tmp2 ON tmp2.Old_ID = p.ParentID
            WHERE tmp2.New_ID IS NULL
            ORDER BY p.Sort

            /*возвращаем взад автовставку идентити*/
            SET IDENTITY_INSERT dbo.ProductionCardProperties OFF

            DROP TABLE #PCP
            DROP TABLE #tmp

            
    /*             + Reorder для кинутой записи тут Апдейтим все без разбора 
                UPDATE ProductionCardProperties
                SET NodeOrder = NodeOrder - 1
                WHERE ParentID = @TargetID
            --елсе            
                ищем парент парента(который есть справчоник)
                SELECT @ParentParentID = ParentID, @ParentOrder = NodeOrder
                FROM ProductionCardProperties WHERE ID = @ParentID
                
                DELETE FROM ProductionCardProperties
                WHERE ID = @ParentID
                 + REORDER тут нужен для парента

                UPDATE ProductionCardProperties
                SET NodeOrder = NodeOrder - 1
                WHERE ParentID = @ParentParentID AND NodeOrder > @ParentOrder*/

            COMMIT TRAN
        END TRY
        BEGIN CATCH
            SET @Err = @@ERROR
            IF @@TRANCOUNT > 0 ROLLBACK TRAN
            EXEC sp_RaiseError @ID = @Err
        END CATCH
    END
    SELECT @OutID AS ID
END
GO