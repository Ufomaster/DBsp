SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   25.03.2014$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   23.06.2015$*/
/*$Version:    1.00$   $Decription: $*/
CREATE PROCEDURE [manufacture].[sp_OperatorGetContainerData]
    @TMC int, /*ТМЦ ящика, который проверяется*/
    @ParentPTMCID int, /*Динамичский ID Он может быть равен 0. это значит был создан новый рТМЦ и его адишкку нужно найти*/
    @Value varchar(255),
    @JobStageChecksID int, --Айдишка упаковки
    @JobStageID int,
    @ContainerGroupColumnName varchar(50)
AS
BEGIN
    DECLARE @Query varchar(8000), @PTmcID int, @GroupColumnName varchar(50)
    --Если следующий элемент - НЕ упаковка, то ищем вложенный ТМЦ как АУТТМЦ
    IF EXISTS(SELECT a.TypeID
              FROM manufacture.JobStageChecks a
              WHERE a.SortOrder = (SELECT SortOrder + 1 FROM manufacture.JobStageChecks WHERE ID = @JobStageChecksID)
                 AND a.TypeID = 1 AND a.JobStageID = @JobStageID AND a.isDeleted = 0
              )
    BEGIN
        --смотрим какoй тмц у входящей внутрь упаковки и берем его для поисков.
        SELECT @PTmcID = a.TmcID
        FROM manufacture.JobStageChecks a
        WHERE a.SortOrder = (SELECT SortOrder + 1 FROM manufacture.JobStageChecks WHERE ID = @JobStageChecksID)
            AND a.TypeID = 1 AND a.JobStageID = @JobStageID AND a.isDeleted = 0

    END
    ELSE
    BEGIN
    --если OutNameTmcID инсерт - то ищем как сейчас, если OutNameTmcID не инсертный(линкед), то нужно смотреть номера из этой ТМЦ таблицы, а не OutputTmcID.
        IF EXISTS(SELECT a.ID FROM manufacture.JobStageChecks a WHERE a.JobStageID = @JobStageID 
                      AND a.ID = (SELECT OutputNameFromCheckID FROM manufacture.JobStages WHERE ID = @JobStageID)
                      AND a.CheckLink = 1
                 )
        BEGIN
        -- берёмс тмц продукции OutputNameFromCheckID
            SELECT @PTmcID = a.TmcID, @GroupColumnName = itc.GroupColumnName 
            FROM manufacture.JobStageChecks a 
            INNER JOIN manufacture.PTmcImportTemplateColumns itc ON itc.ID = a.ImportTemplateColumnID
            WHERE a.JobStageID = @JobStageID 
                AND a.ID = (SELECT OutputNameFromCheckID FROM manufacture.JobStages WHERE ID = @JobStageID)
                AND a.CheckLink = 1


            SELECT @Query = 
            'WITH OrderedTable AS
            (
            SELECT 
              ROW_NUMBER() OVER(ORDER BY a.ID ASC) AS RRNum, 
              ROW_NUMBER() OVER(ORDER BY a.ID DESC) AS RLNum,
              a.ID, 
              a.Value
            FROM StorageData.pTMC_' + CAST(@PTmcID AS Varchar) + ' AS a 
            INNER JOIN StorageData.G_' + CAST(@JobStageID AS Varchar) + ' AS g ON g.' + @GroupColumnName + ' = a.ID 
            WHERE g.' + @ContainerGroupColumnName + ' = ' +
            CASE WHEN @ParentPTMCID = 0 THEN 
               '(SELECT ID FROM StorageData.pTMC_' + CAST(@TMC AS Varchar) + ' WHERE Value = ''' + @Value + ''')'
            ELSE CAST(@ParentPTMCID AS Varchar) 
            END + ' AND a.StatusID = 3
            )

            SELECT ID, Value 
            FROM OrderedTable
            WHERE RRNum = 2
            UNION ALL
            SELECT ID, Value 
            FROM OrderedTable
            WHERE RLNum = 2     
            ORDER BY ID'
    
        END
        ELSE
        BEGIN
            -- берёмс тмц продукции входящей в тару
            SELECT @PTmcID = j.OutputTmcID
            FROM manufacture.JobStages j
            WHERE j.ID = @JobStageID

            SELECT @Query = 
            'WITH OrderedTable AS
            (
            SELECT 
              ROW_NUMBER() OVER(ORDER BY ID ASC) AS RRNum, 
              ROW_NUMBER() OVER(ORDER BY ID DESC) AS RLNum,
              ID, 
              Value
            FROM StorageData.pTMC_' + CAST(@PTmcID AS Varchar) + 
            ' WHERE ParentPTMCID = ' + 
            CASE WHEN @ParentPTMCID = 0 THEN 
               '(SELECT ID FROM StorageData.pTMC_' + CAST(@TMC AS Varchar) + ' WHERE Value = ''' + @Value + ''')'
            ELSE CAST(@ParentPTMCID AS Varchar) 
            END + ' AND ParentTMCID = ' + CAST(@TMC AS Varchar) + ' 
            )

            SELECT ID, Value 
            FROM OrderedTable
            WHERE RRNum = 2
            UNION ALL
            SELECT ID, Value 
            FROM OrderedTable
            WHERE RLNum = 2     
            ORDER BY ID'
    
        END
    END

    EXEC (@Query)
   --SELECT @Query
END
GO