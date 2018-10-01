SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   14.10.2014$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   30.03.2015$*/
/*$Version:    1.00$   $Description: Редактирование характеристики группы$*/
CREATE PROCEDURE [QualityControl].[sp_TMCProps_Update]
    @PropID int,
    @Name varchar(1000),
    @ResultKind tinyint,
    @ValueToCheck varchar(1000),
    @AssignedToQC bit,
    @AssignedToTestAct bit, 
    @TMCID int,
    @TMCPropID int,
    @ImportanceID int
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	DECLARE @Err Int
    DECLARE @t TABLE(ID Int)    

	BEGIN TRAN
	BEGIN TRY 
        IF @PropID IS NOT NULL
        BEGIN
            IF NOT EXISTS(SELECT ID FROM QualityControl.TMCProps WHERE ObjectTypePropsID = @PropID AND TMCID = @TMCID)
                INSERT INTO QualityControl.TMCProps(Name, ResultKind, ValueToCheck, AssignedToQC, AssignedToTestAct, ObjectTypePropsID, TMCID, [Status], ImportanceID)
                OUTPUT INSERTED.ID INTO @t
                SELECT @Name, @ResultKind, @ValueToCheck, @AssignedToQC, @AssignedToTestAct, @PropID, @TMCID, 1, @ImportanceID
            ELSE
                UPDATE QualityControl.TMCProps 
                SET Name = @Name, 
                ResultKind = @ResultKind, 
                ValueToCheck = @ValueToCheck, 
                AssignedToQC = @AssignedToQC, 
                AssignedToTestAct = @AssignedToTestAct,
                ImportanceID = @ImportanceID,
                [Status] = 1
                WHERE ObjectTypePropsID = @PropID AND TMCID = @TMCID
        END
        ELSE
            UPDATE QualityControl.TMCProps 
            SET Name = @Name, 
            ResultKind = @ResultKind, 
            ValueToCheck = @ValueToCheck, 
            AssignedToQC = @AssignedToQC, 
            AssignedToTestAct = @AssignedToTestAct,
            ImportanceID = @ImportanceID
            WHERE ID = @TMCPropID       
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