SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuiriy$    		$Create date:   06.10.2015$*/
/*$Modify:     Oleynik Yuiriy$          $Modify date:   04.07.2018$*/
/*$Version:    1.00$   $Description: Обновление информации для выгрузки сецификации$*/

/*$Create:     Oleynik Yuiriy$    $Create date:   12.10.2012$*/
/*$Modify:     Oleynik Yuiriy$    $Modify date:   04.07.2018$*/
/*$Version:    1.00$   $Description: $*/
CREATE PROCEDURE [dbo].[sp_ProductionCardCustomizeMaterials_Select]
    @ID Int, /* идентификатор заказного листа*/
    @CreateDate datetime = NULL
AS
BEGIN
    SELECT
        pcm.ID,
        pcm.TmcID,
        pcm.Norma,
        pcm.OriginalNorma,
        pcm.PlanNorma,
        pcm.ProductionCardCustomizeID,
        pcm.Norma / pc.CardCountInvoice AS NormaOnCount,
        pcm.PlanNorma / pc.CardCountInvoice AS PlanNormaOnCount,
        '№ ' + pc.Number + ' от ' + dbo.fn_DateToString(pc.CreateDate, 'dd.mm.yy') +'(' + ISNULL(pc.[Name],'') + ')' AS [Name],
        t.[Name] AS MaterialName,
        t.IsHidden AS IsDeleted,
        pcm.is1CSpecNode,
        Status1C = s.[Status],
        s.ErrorMessage,
        s.VisibleCode,
/*        CASE 
            WHEN s.ID IS NOT NULL AND s.Code1C IS NULL      AND spd.[Count] > 0 THEN 1
            WHEN s.ID IS NOT NULL AND s.Code1C IS NOT NULL  AND spd.[Count] > 0 THEN 2
            WHEN s.ID IS NULL AND s.Code1C IS NULL THEN NULL            
        ELSE NULL
        END AS Status1C,*/
        ROW_NUMBER() OVER (PARTITION BY pcm.ProductionCardCustomizeID ORDER BY pcm.ID) AS RowNum
    FROM ProductionCardCustomizeMaterials pcm
    LEFT JOIN sync.[1CSpec] s ON s.ProductionCardCustomizeID = @ID AND s.Kind = 1
    LEFT JOIN (SELECT b.[1CSpecID], COUNT(ID) AS [Count] FROM sync.[1CSpecDetail] b 
               WHERE b.[1CSpecID] IN (SELECT ID FROM sync.[1CSpec] WHERE ProductionCardCustomizeID = @ID AND Kind = 1)
               GROUP BY b.[1CSpecID]) Spd ON spd.[1CSpecID] = s.ID
    INNER JOIN ProductionCardCustomize pc ON pc.ID = pcm.ProductionCardCustomizeID
    INNER JOIN Tmc t ON t.ID = pcm.TmcID
    WHERE pcm.ProductionCardCustomizeID = CASE WHEN @ID = -1 THEN pcm.ProductionCardCustomizeID ELSE @ID END
      AND ((pc.CreateDate >= @CreateDate AND @CreateDate IS NOT NULL) OR (@CreateDate IS NULL))
    ORDER BY pcm.ID
END
GO