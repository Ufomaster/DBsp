SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   10.01.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   28.04.2012$*/
/*$Version:    1.00$   $Decription: Вставка или Апдейт свойств ЗЛ$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardCustomizeProperties_Update]
/*    @ArrayOfID Varchar(MAX),
    @ArrayOfVal Varchar(MAX),
    @ArrayOfValParents Varchar(MAX),*/  
    @CustomizeID Int
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @Err Int
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
         --старый механизм.    
/*        DECLARE @t TABLE(ID Int)
        DECLARE @ts TABLE(ID Int, Val Varchar(1000))

        --Парсим айдишки значений
        INSERT INTO @t(ID)
        SELECT ID 
        FROM dbo.fn_StringToITable(@ArrayOfID)
        WHERE ID > 0

        --Парсим ручные значения и то с чем они связаны - ИД справочника
        DECLARE @a1 TABLE(ID Int IDENTITY(1,1), Val Varchar(1000))
        DECLARE @a2 TABLE(ID Int IDENTITY(1,1), ParentID Int)
        
        INSERT INTO @a1(Val)
        SELECT REPLACE(a.ID, '%%21', ',')
        FROM dbo.fn_StringToSTable(@ArrayOfVal) a
        
        INSERT INTO @a2(ParentID)
        SELECT b.ID 
        FROM dbo.fn_StringToITable(@ArrayOfValParents) b
        
        --тут наш резалт распарсивания
        SELECT 
            a1.Val,
            a2.ParentID
        INTO #HandMadeValues
        FROM @a1 a1
        INNER JOIN @a2 a2 ON a1.ID = a2.ID

        -- для значчений справочников используем поле PropHistoryValueID FK на идентификатор таблицы истории дерева
        удалим удаленные
        DELETE a
        FROM ProductionCardCustomizeProperties a 
        LEFT JOIN @t b ON a.PropHistoryValueID = b.ID AND a.ProductionCardCustomizeID = @CustomizeID
        WHERE b.ID IS NULL AND a.ProductionCardCustomizeID = @CustomizeID 
        AND a.HandMadeValueOwnerID IS NULL -- и только те которые не ручные
        
        добавим добавленные    
        INSERT INTO ProductionCardCustomizeProperties(PropHistoryValueID, ProductionCardCustomizeID)
        SELECT b.ID, @CustomizeID
        FROM @t AS b
        LEFT JOIN ProductionCardCustomizeProperties a ON a.ProductionCardCustomizeID = @CustomizeID AND a.PropHistoryValueID = b.ID
        WHERE a.PropHistoryValueID IS NULL
        
        --для ручных значений нужно сохранить значение и ИД справочника к которому это значение ставить, используется
        -- 2 поля HandMadeValueOwnerID и HandMadeValue
        удалим удаленные ручные
        DELETE a
        FROM ProductionCardCustomizeProperties a 
        LEFT JOIN #HandMadeValues b ON a.HandMadeValueOwnerID = b.ParentID AND a.ProductionCardCustomizeID = @CustomizeID
        WHERE b.Val IS NULL AND a.ProductionCardCustomizeID = @CustomizeID 
        AND a.PropHistoryValueID IS NULL -- и только те которые ручные
        
        апдейтнем ручные
        UPDATE a
            SET a.HandMadeValue = b.Val
        FROM ProductionCardCustomizeProperties a 
        INNER JOIN #HandMadeValues b ON a.HandMadeValueOwnerID = b.ParentID AND a.ProductionCardCustomizeID = @CustomizeID
        WHERE a.HandMadeValue <> b.Val
        
        добавим добавленные ручные
        INSERT INTO ProductionCardCustomizeProperties(HandMadeValue, ProductionCardCustomizeID, HandMadeValueOwnerID)
        SELECT b.Val, @CustomizeID, b.ParentID
        FROM #HandMadeValues AS b
        LEFT JOIN ProductionCardCustomizeProperties a ON a.ProductionCardCustomizeID = @CustomizeID AND a.HandMadeValueOwnerID = b.ParentID
        WHERE a.HandMadeValueOwnerID IS NULL

        DROP TABLE #HandMadeValues*/


       -- для значчений справочников используем поле PropHistoryValueID FK на идентификатор таблицы истории дерева
        --удалим удаленные
        --#PropHistoryValues(PropHistoryValueID, HandMadeValue, HandMadeValueOwnerID, SourceType)
        DELETE a
        FROM ProductionCardCustomizeProperties a 
        LEFT JOIN #PropHistoryValues b ON a.PropHistoryValueID = b.PropHistoryValueID AND a.ProductionCardCustomizeID = @CustomizeID
        WHERE b.PropHistoryValueID IS NULL AND a.ProductionCardCustomizeID = @CustomizeID 
        AND a.HandMadeValueOwnerID IS NULL -- и только те которые не ручные
         --апдейтнем измененные
        UPDATE a
        SET a.SourceType = b.SourceType
        FROM ProductionCardCustomizeProperties a 
        INNER JOIN #PropHistoryValues b ON a.PropHistoryValueID = b.PropHistoryValueID AND a.ProductionCardCustomizeID = @CustomizeID
        WHERE a.ProductionCardCustomizeID = @CustomizeID AND a.HandMadeValueOwnerID IS NULL -- и только те которые не ручные
            AND (ISNULL(a.SourceType, -1) <> b.SourceType) -- только те которые таки изменились
        
        --добавим добавленные    
        INSERT INTO ProductionCardCustomizeProperties(PropHistoryValueID, ProductionCardCustomizeID, SourceType)
        SELECT b.PropHistoryValueID, @CustomizeID, b.SourceType
        FROM #PropHistoryValues AS b
        LEFT JOIN ProductionCardCustomizeProperties a ON a.ProductionCardCustomizeID = @CustomizeID AND a.PropHistoryValueID = b.PropHistoryValueID
        WHERE a.PropHistoryValueID IS NULL
        
        --для ручных значений нужно сохранить значение и ИД справочника к которому это значение ставить, используется
        -- 2 поля HandMadeValueOwnerID и HandMadeValue
        --удалим удаленные ручные
        DELETE a
        FROM ProductionCardCustomizeProperties a 
        LEFT JOIN #PropHistoryValues b ON a.HandMadeValueOwnerID = b.HandMadeValueOwnerID AND a.ProductionCardCustomizeID = @CustomizeID
        WHERE b.HandMadeValue IS NULL AND a.ProductionCardCustomizeID = @CustomizeID 
        AND a.PropHistoryValueID IS NULL -- и только те которые ручные в ProductionCardCustomizeProperties
        
        --апдейтнем ручные
        UPDATE a
        SET a.HandMadeValue = b.HandMadeValue,
            a.SourceType = b.SourceType
        FROM ProductionCardCustomizeProperties a 
        INNER JOIN #PropHistoryValues b ON a.HandMadeValueOwnerID = b.HandMadeValueOwnerID AND a.ProductionCardCustomizeID = @CustomizeID
        WHERE (a.HandMadeValue <> b.HandMadeValue) OR (ISNULL(a.SourceType, -1) <> b.SourceType) -- только те которые таки изменились
        
        --добавим добавленные ручные
        INSERT INTO ProductionCardCustomizeProperties(HandMadeValue, ProductionCardCustomizeID, HandMadeValueOwnerID, SourceType)
        SELECT b.HandMadeValue, @CustomizeID, b.HandMadeValueOwnerID, b.SourceType
        FROM #PropHistoryValues AS b
        LEFT JOIN ProductionCardCustomizeProperties a ON a.ProductionCardCustomizeID = @CustomizeID AND a.HandMadeValueOwnerID = b.HandMadeValueOwnerID
        WHERE a.HandMadeValueOwnerID IS NULL AND b.HandMadeValueOwnerID IS NOT NULL
        
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO