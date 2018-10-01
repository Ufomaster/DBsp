SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$    $Create date:   19.04.2011$
--$Modify:     Oleynik Yuriy$    $Modify date:   05.11.2012$
--$Version:    1.00$   $Description: Copy ТМЦ$
CREATE PROCEDURE [dbo].[sp_Tmc_Copy]
    @OldTMCID Int
AS
BEGIN
    SET NOCOUNT ON
	SET XACT_ABORT ON
	DECLARE @Err Int
    DECLARE @t TABLE(ID Int)
    DECLARE @NewID Int
    
	BEGIN TRAN
	BEGIN TRY    
        INSERT INTO dbo.Tmc(XMLData, ObjectTypeID, RegistrationDate, [Name], DeadCount, PartNumber, UnitID)
        OUTPUT INSERTED.ID INTO @t
        SELECT XMLData, ObjectTypeID, GetDate(), [Name], DeadCount, PartNumber + '_копия', UnitID
        FROM dbo.Tmc
        WHERE ID = @OldTMCID

        SELECT @NewID = ID FROM @t

        INSERT INTO TmcObjectLinks(ObjectID, TmcID)
        SELECT t.ObjectID, @NewID
        FROM dbo.TmcObjectLinks t
        WHERE t.TmcID = @OldTMCID
        
        INSERT INTO TMCAttributes (TMCID, AttributeID)
        SELECT @NewID, AttributeID FROM TMCAttributes a WHERE a.TmcID = @OldTMCID

		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SET @Err = @@ERROR;
		IF @@TRANCOUNT > 0 ROLLBACK TRAN;
		EXEC sp_RaiseError @ID = @Err;
		SET @NewID = -1;
	END CATCH;
    SELECT @NewID
END
GO