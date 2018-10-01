SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$    $Create date:   30.11.2011$
--$Modify:     Oleynik Yuriy$    $Modify date:   28.12.2011$
--$Version:    1.00$   $Description: Добавление связки свойств производства$
CREATE PROCEDURE [dbo].[sp_ProductionCardProperties_Insert]
    @ID Int, --праймари кей записи ObjectTypes
    @TargetID Int = -1 --праймари кей записи ProductionCardProperties
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @Err Int    

    DECLARE @ParentID Int, @TargetObjectTypeParentID Int, @TargetObjectTypeID Int
    DECLARE @T TABLE(ID Int)
        
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        IF NOT EXISTS(SELECT * FROM ObjectTypesAttributes ota 
                      WHERE ota.AttributeID = 5 AND ota.ObjectTypeID = @ID)
            RAISERROR('Добавление элементов, которые не явлюятся значениями справочников производства, запрещено', 16, 1)
        
        IF @TargetID = -1 --пустой список уровни 0 и 1. Ордер у всех 1
        BEGIN
            INSERT INTO ProductionCardProperties(ParentID, ObjectTypeID, NodeLevel, NodeOrder)
            OUTPUT INSERTED.ID INTO @T
            SELECT NULL, ot.ParentID, 0, 1 FROM ObjectTypes ot WHERE ot.ID = @ID

            INSERT INTO ProductionCardProperties(ParentID, ObjectTypeID, NodeLevel, NodeOrder)
            OUTPUT INSERTED.ID INTO @T
            SELECT ID, @ID, 1, 1 FROM @T
        END
        ELSE
        BEGIN
            SELECT 
                @TargetObjectTypeParentID = ot.ParentID,
                @TargetObjectTypeID = ot.ID 
            FROM ObjectTypes ot
            INNER JOIN ProductionCardProperties p ON p.ID = @TargetID AND p.ObjectTypeID = ot.ID

            SELECT
                @ParentID = ot.ParentID
            FROM ObjectTypes ot
            WHERE ot.ID = @ID
            
            IF EXISTS(SELECT * FROM ProductionCardProperties pcp 
                      WHERE pcp.ObjectTypeID = @ID AND pcp.ParentID = @TargetID)
                RAISERROR('Значение уже существует', 16, 1)
            IF EXISTS(SELECT * FROM ProductionCardProperties pcp 
                      WHERE pcp.ObjectTypeID = @ID AND pcp.ParentID = (SELECT ParentID FROM ProductionCardProperties WHERE ID = @TargetID))
                RAISERROR('Значение уже существует', 16, 1)
            
            IF (@ParentID = @TargetObjectTypeParentID) --кидаем айтем в айтем того же типа. Level - the same, Order - +1
            BEGIN
                INSERT INTO ProductionCardProperties(ParentID, ObjectTypeID, NodeLevel, NodeOrder)
                OUTPUT INSERTED.ID INTO @T
                SELECT p.ParentID, @ID, p.NodeLevel,  MAX(pc.NodeOrder) + 1 
                FROM ProductionCardProperties p 
                INNER JOIN ProductionCardProperties pc ON pc.ParentID = p.ParentID
                WHERE p.ID = @TargetID
                GROUP BY p.ParentID, p.NodeLevel
            END
            ELSE
            IF (@ParentID = @TargetObjectTypeID) --кидаем айтем в свой же тип
            BEGIN               
                INSERT INTO ProductionCardProperties(ParentID, ObjectTypeID, NodeLevel, NodeOrder)
                OUTPUT INSERTED.ID INTO @T
                SELECT @TargetID, @ID, p.NodeLevel, MAX(p.NodeOrder) + 1
                FROM ProductionCardProperties p
                WHERE p.ParentID = @TargetID
                GROUP BY p.NodeLevel
            END
            ELSE
            BEGIN --кидаем в айтем у которого ещё нет ни значения ни типа справочника, кидаемого мышой
                INSERT INTO ProductionCardProperties(ParentID, ObjectTypeID, NodeLevel, NodeOrder)
                OUTPUT INSERTED.ID INTO @T
                SELECT @TargetID, ot.ParentID, p.NodeLevel + 1, ISNULL(MAX(pc.NodeOrder), 0) + 1
                FROM ObjectTypes ot
                LEFT JOIN ProductionCardProperties pc ON pc.ParentID = @TargetID
                INNER JOIN ProductionCardProperties p ON p.ID = @TargetID
                WHERE ot.ID = @ID
                GROUP BY p.NodeLevel, ot.ParentID

                INSERT INTO ProductionCardProperties(ParentID, ObjectTypeID, NodeLevel, NodeOrder)
                SELECT t.ID, @ID, pc.NodeLevel + 2, 1 -- + 2 потому что мамку вставили с + 1
                FROM @T t
                INNER JOIN ProductionCardProperties pc ON pc.ID = @TargetID
            END            
        END
        COMMIT TRAN
        SELECT ID FROM @T
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO