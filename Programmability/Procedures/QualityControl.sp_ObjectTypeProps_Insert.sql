SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   13.10.2014$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   30.03.2015$*/
/*$Version:    1.00$   $Description: Добавление характеристики группы$*/
CREATE PROCEDURE [QualityControl].[sp_ObjectTypeProps_Insert]
    @Name varchar(1000),
    @ResultKind tinyint,
    @ValueToCheck varchar(1000),
    @AssignedToQC bit,
    @AssignedToTestAct bit, 
    @ObjectTypeID int,
    @ImportanceID int
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	DECLARE @Err Int
    DECLARE @t TABLE(ID Int)    

	BEGIN TRAN
	BEGIN TRY    
        INSERT INTO QualityControl.ObjectTypeProps(Name, ResultKind, ValueToCheck, AssignedToQC, AssignedToTestAct, SortOrder, ObjectTypeID, ImportanceID)
        OUTPUT INSERTED.ID INTO @t
        SELECT @Name, @ResultKind, @ValueToCheck, @AssignedToQC, @AssignedToTestAct, ISNULL(MAX(SortOrder) + 1, 1), @ObjectTypeID, @ImportanceID
        FROM QualityControl.ObjectTypeProps
        WHERE ObjectTypeID = @ObjectTypeID       
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SET @Err = @@ERROR;
		IF @@TRANCOUNT > 0 ROLLBACK TRAN;
		EXEC sp_RaiseError @ID = @Err;
	END CATCH;
    SELECT ID FROM @t
END
GO