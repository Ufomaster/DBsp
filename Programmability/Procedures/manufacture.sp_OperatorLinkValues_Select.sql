SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   11.03.2014$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   06.10.2014$*/
/*$Version:    1.00$   $Decription: $*/
CREATE PROCEDURE [manufacture].[sp_OperatorLinkValues_Select]
    @JobStageID int,
    @CurColName varchar(255),
    @CurDynamicID int,
    @ParentColName varchar(255),
    @ParentDynamicID int
AS
BEGIN
    -- нужно поверить входит ли @CurDynamicID в тару @ParentDynamicID по таблице G_@JobStageID
    DECLARE @Query varchar(8000)
    
    SELECT @Query = 'SELECT COUNT(a.Col) AS Cnt
    FROM (SELECT g.' + @CurColName + ' AS Col
    FROM StorageData.G_' + CAST(@JobStageID AS varchar) + ' g
    WHERE ' + CASE 
                  WHEN @ParentColName <> '' THEN ' g.' + @ParentColName + ' = ' + CAST(@ParentDynamicID AS varchar) + ' AND ' 
              ELSE ''
              END +
          'g.' + @CurColName + ' = ' + CAST(@CurDynamicID AS Varchar) + '
    GROUP BY g.' + @CurColName + ') a'

    EXEC (@Query)
END
GO