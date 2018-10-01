SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$    $Create date:   01.12.2011$
--$Modify:     Oleynik Yuriy$    $Modify date:   03.08.2015$
--$Version:    1.00$   $Description: Удаление связки свойств производства$
CREATE PROCEDURE [dbo].[sp_ProductionCardProperties_Delete]
    @ID Int --праймари кей записи свойств
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @Err Int    
    DECLARE @Order Int, @ParentOrder Int
    DECLARE @ParentID Int, @ParentParentID Int, @AttributeID int
    DECLARE @T TABLE(ID Int)
    --@ParentID = родитель записи.
    SELECT @ParentID = p.ParentID, @Order = p.NodeOrder, @AttributeID = ota.AttributeID
    FROM ProductionCardProperties p 
    INNER JOIN ObjectTypesAttributes ota ON p.ObjectTypeID = ota.ObjectTypeID AND (ota.AttributeID IN (4,5))
    WHERE p.ID = @ID
    
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        IF @AttributeID = 5 --если удалем значение то проверяем пустой ли остался справочник после удаления    
        BEGIN
            --ищем записи других чайлдов этого же родителя. Если они есть - не удаляем родителя.
            IF EXISTS(SELECT p.ID FROM ProductionCardProperties p WHERE p.ParentID = @ParentID AND p.ID <> @ID) 
            BEGIN
                ;WITH ResultTable (ID, ParentID, NodeLevel, NodeOrder, Sort) AS
                (  SELECT
                        ID, ParentID, NodeLevel, NodeOrder
                        --,CONVERT(Varchar(300), RIGHT(REPLICATE('0',2 - LEN(CAST(e.NodeOrder AS Varchar(2)))) + CAST(e.NodeOrder AS Varchar(2)), 2))
                        ,CONVERT(Varchar(300), RIGHT('00' + CAST(e.NodeOrder AS Varchar(2)), 2))            
                    FROM ProductionCardProperties e
                    WHERE ID = @ID
                    UNION ALL
                    /* Recursive member definition*/
                    SELECT
                        e.ID, e.ParentID, e.NodeLevel, e.NodeOrder
                        --, CONVERT (Varchar(300), d.Sort /*+ '|'*/ + RIGHT(REPLICATE('0',2 - LEN(CAST(e.NodeOrder AS Varchar(2)))) + CAST(e.NodeOrder AS Varchar(2)), 2))
                        ,CONVERT(Varchar(300), d.Sort + RIGHT('00' + CAST(e.NodeOrder AS Varchar(2)), 2))
                    FROM ProductionCardProperties AS e
                    INNER JOIN ResultTable AS d ON e.ParentID = d.ID
                )
                DELETE FROM ProductionCardProperties WHERE ID IN (SELECT ID FROM ResultTable)

                -- + Reorder тут
                UPDATE ProductionCardProperties
                SET NodeOrder = NodeOrder - 1
                WHERE ParentID = @ParentID AND NodeOrder > @Order
            END
            ELSE
            BEGIN
                ;WITH ResultTable (ID, ParentID, NodeLevel, NodeOrder, Sort)
                AS
                (  SELECT
                        ID, ParentID, NodeLevel, NodeOrder
                        --,CONVERT(Varchar(300), RIGHT(REPLICATE('0',2 - LEN(CAST(e.NodeOrder AS Varchar(2)))) + CAST(e.NodeOrder AS Varchar(2)), 2))
                        ,CONVERT(Varchar(300), RIGHT('00' + CAST(e.NodeOrder AS Varchar(2)), 2))            
                    FROM ProductionCardProperties e
                    WHERE ID = @ID
                    UNION ALL
                    /* Recursive member definition*/
                    SELECT
                        e.ID, e.ParentID, e.NodeLevel, e.NodeOrder
                        --, CONVERT (Varchar(300), d.Sort /*+ '|'*/ + RIGHT(REPLICATE('0',2 - LEN(CAST(e.NodeOrder AS Varchar(2)))) + CAST(e.NodeOrder AS Varchar(2)), 2))
                        ,CONVERT(Varchar(300), d.Sort + RIGHT('00' + CAST(e.NodeOrder AS Varchar(2)), 2))
                    FROM ProductionCardProperties AS e
                    INNER JOIN ResultTable AS d ON e.ParentID = d.ID
                )

                DELETE FROM ProductionCardProperties
                WHERE ID IN (SELECT ID FROM ResultTable)
                
                --ищем парент нашего справочника
                SELECT @ParentParentID = ParentID, @ParentOrder = NodeOrder
                FROM ProductionCardProperties
                WHERE ID = @ParentID
                --удаляем его, так как он оказался пустой после удаления
                DELETE p 
                FROM ProductionCardProperties p
                INNER JOIN ObjectTypesAttributes ota ON ota.ObjectTypeID = p.ObjectTypeID AND ota.AttributeID = 4 --можно удалить только если это справочник.
                WHERE p.ID = @ParentID
                -- + REORDER тут нужен для парента

                UPDATE ProductionCardProperties
                SET NodeOrder = NodeOrder - 1
                WHERE ParentID = @ParentParentID AND NodeOrder > @ParentOrder
            END
        END
        ELSE
        IF @AttributeID = 4 --если удалем справочник, то просто удаляем
        BEGIN
            ;WITH ResultTable (ID, ParentID, NodeLevel, NodeOrder, Sort)
            AS
            (  SELECT
                    ID, ParentID, NodeLevel, NodeOrder
                    --,CONVERT(Varchar(300), RIGHT(REPLICATE('0',2 - LEN(CAST(e.NodeOrder AS Varchar(2)))) + CAST(e.NodeOrder AS Varchar(2)), 2))
                    ,CONVERT(Varchar(300), RIGHT('00' + CAST(e.NodeOrder AS Varchar(2)), 2))            
                FROM ProductionCardProperties e
                WHERE ID = @ID
                UNION ALL
                /* Recursive member definition*/
                SELECT
                    e.ID, e.ParentID, e.NodeLevel, e.NodeOrder
                    --, CONVERT (Varchar(300), d.Sort /*+ '|'*/ + RIGHT(REPLICATE('0',2 - LEN(CAST(e.NodeOrder AS Varchar(2)))) + CAST(e.NodeOrder AS Varchar(2)), 2))
                    ,CONVERT(Varchar(300), d.Sort + RIGHT('00' + CAST(e.NodeOrder AS Varchar(2)), 2))
                FROM ProductionCardProperties AS e
                INNER JOIN ResultTable AS d ON e.ParentID = d.ID
            )

            DELETE FROM ProductionCardProperties
            WHERE ID IN (SELECT ID FROM ResultTable)
            
            -- + Reorder тут
            UPDATE ProductionCardProperties
            SET NodeOrder = NodeOrder - 1
            WHERE ParentID = @ParentID AND NodeOrder > @Order                
        END        

        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO