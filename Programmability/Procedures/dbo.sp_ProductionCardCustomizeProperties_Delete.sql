SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   10.01.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   02.01.2013$*/
/*$Version:    1.00$   $Decription: удаление свойств ЗЛ$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardCustomizeProperties_Delete]
    @CustomizeID Int
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @Err Int, @EmployeeID Int
    SET XACT_ABORT ON
    
    /*IF EXISTS(SELECT * FROM dbo.EquipmentControl ec WHERE ec.EquipmentID = @ID)*/
    /*    RAISERROR ('Удаление основного средства запрещено, так как на него существуют точки контроля', 16, 1)*/

    BEGIN TRAN
    BEGIN TRY
        SELECT @EmployeeID = EmployeeID FROM #CurrentUser
        EXEC sp_ProductionCardCustomizeHistory_Insert @EmployeeID, @CustomizeID, 2

        /*удалим props*/
        DELETE
        FROM ProductionCardCustomizeProperties
        WHERE ProductionCardCustomizeID = @CustomizeID
        
        /*удалим layouts*/
        DELETE
        FROM ProductionCardCustomizeLayout
        WHERE ProductionCardCustomizeID = @CustomizeID
        
        /*удалим materials*/
        DELETE
        FROM ProductionCardCustomizeMaterials
        WHERE ProductionCardCustomizeID = @CustomizeID
        
        /*удалим chat*/
        DELETE a
        FROM ProductionCardCustomizeAdaptingsMesChat a
        INNER JOIN ProductionCardCustomizeAdaptingsMes mes ON mes.ID = a.ProductionCardCustomizeAdaptingsMesID
        INNER JOIN ProductionCardCustomizeAdaptings ad ON ad.ID = mes.ProductionCardCustomizeAdaptingsID 
        WHERE ad.ProductionCardCustomizeID = @CustomizeID
        
        /*удалим msg*/
        DELETE mes
        FROM ProductionCardCustomizeAdaptingsMes mes
        INNER JOIN ProductionCardCustomizeAdaptings ad ON ad.ID = mes.ProductionCardCustomizeAdaptingsID 
        WHERE ad.ProductionCardCustomizeID = @CustomizeID

        /*удалим adaptings*/
        DELETE
        FROM ProductionCardCustomizeAdaptings
        WHERE ProductionCardCustomizeID = @CustomizeID

        /*удалим комплекты*/        
        DELETE
        FROM ProductionCardCustomizeDetails
        WHERE ProductionCardCustomizeID = @CustomizeID
				
        /*удалим поля цода*/        
        DELETE
        FROM ProductionCardCustomizeDocDetails
        WHERE ProductionCardCustomizeID = @CustomizeID            
        
        /*удалим историю*/
        DELETE
        FROM ProductionCardCustomizeHistory
        WHERE ProductionCardCustomizeID = @CustomizeID            
         
        --курсор по всем связям зазаз-ЗЛ
        DECLARE @ProductionOrdersID Int, @SortOrder Int
        DECLARE #Cur CURSOR FOR SELECT poc.ProductionOrdersID, poc.SortOrder 
                                FROM ProductionOrdersProdCardCustomize poc 
                                WHERE poc.ProductionCardCustomizeID = @CustomizeID
        OPEN #Cur
        FETCH NEXT FROM #cur INTO @ProductionOrdersID, @SortOrder
        WHILE @@FETCH_STATUS = 0
        BEGIN        
            UPDATE dbo.ProductionOrdersProdCardCustomize
            SET SortOrder = SortOrder - 1
            WHERE ProductionOrdersID = @ProductionOrdersID AND SortOrder > @SortOrder

            FETCH NEXT FROM #cur INTO @ProductionOrdersID, @SortOrder
        END
        CLOSE #Cur
        DEALLOCATE #Cur

        DELETE
        FROM ProductionCardCustomize
        WHERE ID = @CustomizeID

        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO