SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Zapadinskiy Anatoliy$    $Create date:   19.01.2012$
--$Modify:     Oleynik Yuriy$    $Modify date:   02.11.2015$$
--$Version:    1.00$   $Description: Изменение материала в связке значения справочников с материалами$
CREATE PROCEDURE [dbo].[sp_ObjectTypesMaterials_Modify]
    @ID Int, --праймари кей записи ObjectTypesMaterialsID
    @TmcID Int, --праймари кей материал Tmc
    @GroupName varchar(30) = NULL--группировка одинаковых тмц
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @Err Int, @ObjectTypeID Int
   
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY

        SELECT @ObjectTypeID = ObjectTypeID
        FROM ObjectTypesMaterials otm
        WHERE otm.ID = @ID
        IF @GroupName = '' 
            SET @GroupName = NULL

	    --проверяем на существования такой записи
        IF EXISTS(SELECT * FROM ObjectTypesMaterials otm 
                  WHERE otm.ObjectTypeID = @ObjectTypeID AND otm.TmcID = @TmcID
                        AND otm.BeginDate IS NULL
                        AND otm.ID <> @ID
                        AND (otm.GroupName = @GroupName OR (otm.GroupName IS NULL AND @GroupName IS NULL)))
            RAISERROR('Значение уже существует', 16, 1)

	    --проверяем является ли запись опубликованной
        IF EXISTS(SELECT * FROM ObjectTypesMaterials otm
                  WHERE otm.ID = @ID AND otm.BeginDate IS NOT NULL)
            RAISERROR('Нельзя менять материал для опубликованных связей', 16, 1)    

        UPDATE ObjectTypesMaterials
        SET TmcID = @TmcID, GroupName = @GroupName
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