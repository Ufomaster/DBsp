SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   17.03.2015$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   17.03.2015$*/
/*$Version:    1.00$   $Decription: Массовая вставка продукции в акты отбора проб*/
create PROCEDURE [QualityControl].[sp_ActOfSamplingDetails_MassInsert]
    @ActID Int,
    @Text varchar(8000),
    @InCount int = NULL,
    @OutCount int = NULL,
    @UnitID int = NULL
AS
BEGIN
    INSERT INTO [QualityControl].[ActOfSamplingDetails](ActOfSamplingID,
        ProductsIDInfo, UnitID, Quantity, UnUsedQuantity)
    SELECT 
    @ActID,
    a.ID, 
    @UnitID, 
    @InCount, 
    @OutCount
    FROM dbo.fn_StringToSTable(@Text) a
END
GO