SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   20.11.2014$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   30.03.2015$*/
/*$Version:    1.00$   $Description: Перегрузка характеристик из род. группы$*/
CREATE PROCEDURE [QualityControl].[sp_ObjectTypeProps_LoadParent]
    @ObjectTypeID int  
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	DECLARE @Err Int
    DECLARE @t TABLE(ID Int)    
    DECLARE @SortOrder INT

	BEGIN TRAN
	BEGIN TRY
        SELECT @SortOrder = MAX(SortOrder) FROM QualityControl.ObjectTypeProps WHERE ObjectTypeID = @ObjectTypeID
        IF @SortOrder IS NULL
            SET @SortOrder = 0
        
        INSERT INTO QualityControl.ObjectTypeProps(Name, ResultKind, ValueToCheck, AssignedToQC, AssignedToTestAct, SortOrder, ObjectTypeID, ImportanceID)
        SELECT 
            Name, ResultKind, ValueToCheck, AssignedToQC, AssignedToTestAct, 
            @SortOrder + ROW_NUMBER() OVER(ORDER BY SortOrder), 
            @ObjectTypeID, ImportanceID
        FROM QualityControl.ObjectTypeProps
        WHERE ObjectTypeID = (SELECT a.ParentID FROM ObjectTypes a WHERE a.ID = @ObjectTypeID)
        
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SET @Err = @@ERROR;
		IF @@TRANCOUNT > 0 ROLLBACK TRAN;
		EXEC sp_RaiseError @ID = @Err;
	END CATCH;
END
GO