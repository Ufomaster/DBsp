SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Zapadinskiy Anatoliy$    $Create date:   19.01.2012$
--$Modify:     Oleynik Yuriy$	$Modify date:   04.10.2012$
--$Version:    1.00$   $Description: Публикуем привязку материала к значению справочника$
CREATE PROCEDURE [dbo].[sp_ObjectTypesMaterials_Publish]
    @ID Int --праймари кей записи ObjectTypesMaterialsID
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @Err Int, @TmcID Int, @ObjectTypeID Int
        
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
	    --проверяем является ли запись опубликованной
        IF EXISTS(SELECT * FROM ObjectTypesMaterials otm 
                  WHERE otm.ID = @ID AND otm.BeginDate IS NOT NULL)
            RAISERROR('Данный материал уже опубликован', 16, 1)

          SELECT @TmcID = TmcID, @ObjectTypeID = ObjectTypeID
          FROM ObjectTypesMaterials otm
          WHERE otm.ID = @ID

          --ищем последнюю опубликованную запись и закрываем ее
/*          UPDATE tab
          SET EndDate = Getdate()
          FROM (SELECT top 1 EndDate
                FROM ObjectTypesMaterials
                WHERE ObjectTypeID = @ObjectTypeID
                      AND MaterialID = @MaterialID 
                      AND BeginDate is not null
                      AND EndDate is null
                ORDER BY EndDate DESC) tab
 */
          UPDATE ObjectTypesMaterials
          SET BeginDate = Getdate()
          WHERE ID = @ID

        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO