SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   28.09.2012$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   28.09.2012$*/
/*$Version:    1.00$   $Description: добавление исключения проверок прав для полей для статуста ЗЛ$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardStatusesFields_Check]
    @ColID Int,
    @StatusID Int
AS
BEGIN
    IF EXISTS(SELECT ID FROM ProductionCardStatusesFields WHERE ColumnID = @ColID AND ProductionCardStatusesID = @StatusID)
        DELETE 
        FROM ProductionCardStatusesFields WHERE ColumnID = @ColID AND ProductionCardStatusesID = @StatusID
    ELSE
        INSERT INTO ProductionCardStatusesFields(ColumnID, ProductionCardStatusesID)
        SELECT @ColID, @StatusID
END
GO