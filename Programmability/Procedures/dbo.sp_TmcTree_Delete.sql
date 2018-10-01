SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$	$Create date:   23.02.2011$
--$Modify:     Oleynik Yuriy$	$Modify date:   07.09.2015$
--$Version:    1.00$   $Description: Удаление типа объекта$
CREATE PROCEDURE [dbo].[sp_TmcTree_Delete]
    @ID Int
AS
BEGIN
	SET NOCOUNT ON
    DECLARE @Err Int

    IF EXISTS(SELECT * FROM ObjectTypes WHERE ParentID = @ID)
        RAISERROR ('Удаление непустых узлов запрещено (ObjectTypes)', 16, 1)
    ELSE
    IF EXISTS(SELECT * FROM Tmc WHERE ObjectTypeID = @ID)
        RAISERROR ('Удаление типа объекта, в котором есть объекты, запрещено (Tmc)', 16, 1)
    ELSE
    IF EXISTS(SELECT * FROM ProductionCardProperties WHERE ObjectTypeID = @ID)
        RAISERROR ('Удаление справочника или значения справочника, которое используется в конструкторе дерева взаимосвязей, запрещено (ProductionCardProperties)', 16, 1)
    ELSE
    IF EXISTS(SELECT * FROM ProductionCardPropertiesHistoryDetails WHERE ObjectTypeID = @ID)
        RAISERROR ('Удаление справочника или значения справочника, которое опубликовано в дереве взаимосвязей, запрещено (ProductionCardPropertiesHistoryDetails)', 16, 1)
    ELSE
    IF EXISTS(SELECT * FROM ObjectTypesMaterials WHERE ObjectTypeID = @ID)
        RAISERROR ('Удаление справочника или значения справочника, которое используется в материалах, запрещено (ObjectTypesMaterials)', 16, 1)
    ELSE
    IF EXISTS(SELECT * FROM ObjectTypesMaterials WHERE ObjectTypeID = @ID)
        RAISERROR ('Удаление типа объекта, которое используется в привязке норм расходов материалов, запрещено (ObjectTypesMaterials)', 16, 1)
    ELSE
    IF EXISTS(SELECT * FROM ConsumptionRatesDetails WHERE ObjectTypeID = @ID)
        RAISERROR ('Удаление типа объекта, которое используется в условиях срабатывания формулы расчета нормы расхода материалов, запрещено (ConsumptionRatesDetails)', 16, 1)
                
    DECLARE @ParentID Int, @Order Int
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        SELECT
            @ParentID = ot.ParentID,
            @Order = ot.NodeOrder
        FROM ObjectTypes ot
        WHERE ot.ID = @ID
        
        DELETE 
        FROM ObjectTypes 
        WHERE ID = @ID

        UPDATE ObjectTypes
        SET NodeOrder = NodeOrder -1
        WHERE ISNULL(ParentID,-1) = ISNULL(@ParentID, -1) AND NodeOrder > @Order
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO