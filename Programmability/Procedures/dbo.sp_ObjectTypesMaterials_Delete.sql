SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Zapadinskiy Anatoliy$    $Create date:   19.01.2012$
--$Modify:     Oleynik Yuriy$	        $Modify date:   26.06.2015$
--$Version:    1.00$   $Description: Удаление связки значения справочников с материалами$
CREATE PROCEDURE [dbo].[sp_ObjectTypesMaterials_Delete]
    @ID Int --праймари кей таблицы ObjectTypesMaterials
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @Err Int, @ConsumptionRatesID Int
        
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        
	    --проверяем является ли запись опубликованной
        IF EXISTS(SELECT * FROM ObjectTypesMaterials otm 
                  WHERE otm.ID = @ID AND otm.BeginDate IS NOT NULL)
           AND --если на материал есть формулы - тогда не удаляем, иначе тоже удаляем
           EXISTS(SELECT * FROM ConsumptionRates cr 
                  WHERE cr.ObjectTypesMaterialID = @ID)
        BEGIN
          --опубликованные записи не удаляем, а ставим дату закрытия
          UPDATE ObjectTypesMaterials
          SET EndDate = Getdate()
          WHERE ID = @ID          
        END
        ELSE
        BEGIN
          --записи в разработке удаляем          
          DECLARE CRS CURSOR STATIC LOCAL FOR 
          SELECT ID
          FROM ConsumptionRates AS cr
          WHERE cr.ObjectTypesMaterialID = @ID
          
          OPEN CRS
      
          FETCH NEXT FROM CRS INTO @ConsumptionRatesID
                              
          WHILE @@FETCH_STATUS = 0
          BEGIN     
            EXEC dbo.[sp_ConsumptionRates_Delete] @ConsumptionRatesID

            FETCH NEXT FROM CRS INTO @ConsumptionRatesID
          END            
          
          DELETE FROM ObjectTypesMaterials WHERE ID = @ID 
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