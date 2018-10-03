SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Polyatykin Oleksey$    $Create date:   01.10.2018$*/
/*$Modify:     Polyatykin Oleksey$    $Create date:   03.10.2018$*/
/*$Version:    1.00$   $Description: Удаляем таблицы  Pallets_[JobStageID] и PalletsDetails_[JobStageID], если они существуют$*/

CREATE PROCEDURE [manufacture].[sp_Pallets_DropTables]
@JobStageID int
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @TableName varchar(50), @TableNameD varchar(50)

    SET @TableNameD = 'PalletsDetails_' + CONVERT (VARCHAR (30), @JobStageID) 
    SET @TableName = 'Pallets_' + Convert(varchar(30), @JobStageID)

    IF OBJECT_ID('[StorageData].['+@TableNameD+']') IS NOT NULL           
        EXEC ('DROP TABLE [StorageData].['+@TableNameD+']')

    IF OBJECT_ID('[StorageData].['+@TableName+']') IS NOT NULL
        EXEC ('DROP TABLE [StorageData].['+@TableName+']')

END
GO