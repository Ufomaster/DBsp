SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   07.11.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   20.11.2013$*/
/*$Version:    1.00$   $Description: Обновление доступа к заполнению блоков полей типов протоколов$*/
create PROCEDURE [QualityControl].[sp_TypesStatusesBlocks_Check]
    @ColID int = NULL,
    @StatusID Int
AS
BEGIN
    IF EXISTS(SELECT ID FROM [QualityControl].TypesStatusesFields WHERE colid = @ColID AND TypesStatusesID = @StatusID)
        DELETE
        FROM [QualityControl].TypesStatusesFields WHERE colid = @ColID AND TypesStatusesID = @StatusID
    ELSE
        INSERT INTO [QualityControl].TypesStatusesFields(colid, TypesStatusesID)
        SELECT @ColID, @StatusID
END
GO