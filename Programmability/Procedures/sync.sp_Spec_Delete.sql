SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuiriy$    		$Create date:   13.10.2015$*/
/*$Modify:     Oleynik Yuiriy$          $Modify date:   13.10.2015$*/
/*$Version:    1.00$   $Description: очистка связки сецификации$*/
CREATE PROCEDURE [sync].[sp_Spec_Delete]
    @PCCID Int
AS
BEGIN 
    /* процедура выхывается внутри других процедур и обрамляется транзакцией с кечем*/
    DELETE a 
    FROM sync.[1CSpecDetail] a
    WHERE a.[1CSpecID] IN (SELECT ID 
                           FROM sync.[1CSpec] b
                           WHERE b.ProductionCardCustomizeID = @PCCID AND b.Kind = 2)
    DELETE a 
    FROM sync.[1CSpecDetail] a
    WHERE a.[1CSpecID] = (SELECT ID 
                          FROM sync.[1CSpec] b
                          WHERE ProductionCardCustomizeID = @PCCID AND b.Kind = 1)
    DELETE a 
    FROM sync.[1CSpec] a
    WHERE a.ProductionCardCustomizeID = @PCCID AND a.Kind = 2
END
GO