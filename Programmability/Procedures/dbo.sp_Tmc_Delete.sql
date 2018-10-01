SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$    $Create date:   09.03.2011$
--$Modify:     Oleynik Yuriy$    $Modify date:   17.12.2013$
--$Version:    1.00$   $Description: Удаление ТМЦ$
CREATE PROCEDURE [dbo].[sp_Tmc_Delete]
    @TMCID Int
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @Err Int

    IF EXISTS(SELECT * FROM dbo.Equipment e WHERE e.TmcID = @TMCID)
        RAISERROR ('Удаление тмц запрещено, так как по ней существуют ОС', 16, 1)
    ELSE
    IF EXISTS(SELECT * FROM dbo.InvoiceDetail id WHERE id.TmcID = @TMCID)
        RAISERROR ('Удаление тмц запрещено, так как выбранная позиция указана в счетах', 16, 1)
    ELSE
    IF EXISTS(SELECT * FROM dbo.SolutionTmc st WHERE st.TmcID = @TMCID)
        RAISERROR ('Удаление тмц запрещено. Выбранная позиция используется в списании в работах', 16, 1)
    ELSE
    IF EXISTS(SELECT * FROM dbo.SolutionsDeclared spd WHERE spd.TMCID = @TMCID)
        RAISERROR ('Удаление тмц запрещено. Выбранная позиция указана в регламентных работах', 16, 1)
    ELSE    
    IF EXISTS(SELECT * FROM dbo.ObjectTypesMaterials otm WHERE otm.TmcID = @TMCID)
        RAISERROR ('Удаление тмц запрещено. Выбранная позиция указана в нормах расхода производства карт', 16, 1)
    ELSE
    IF EXISTS(SELECT * FROM dbo.ProductionCardCustomizeDetails pcd WHERE pcd.TmcID = @TMCID)
        RAISERROR ('Удаление тмц запрещено. Выбранная позиция указана в материалах детальной части ЗЛ', 16, 1)
    ELSE
    IF EXISTS(SELECT * FROM dbo.ProductionCardCustomizeMaterials pcm WHERE pcm.TmcID = @TMCID)
        RAISERROR ('Удаление тмц запрещено. Выбранная позиция указана в сопроводительном листе ЗЛ', 16, 1)
    ELSE    
    BEGIN
        SET XACT_ABORT ON
        BEGIN TRAN
        BEGIN TRY
            DELETE FROM Tmc WHERE ID = @TMCID --в остальных таблицах каскадное удаление.
            COMMIT TRAN
        END TRY
        BEGIN CATCH
            SET @Err = @@ERROR
            IF @@TRANCOUNT > 0 ROLLBACK TRAN
            EXEC sp_RaiseError @ID = @Err
        END CATCH
    END
END
GO