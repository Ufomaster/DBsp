SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   16.05.2014$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   20.05.2014$*/
/*$Version:    1.00$   $Decription: $*/
CREATE PROCEDURE [manufacture].[sp_MDSWriteStatistic]
    @StorageStructureID int,
    @EndPackExecSpeed int, 
    @EndCodeValidExecSpeed int, 
    @EndSortOrderExecSpeed int, 
    @EndLinksExecSpeed int,
    @ErrorText varchar(8000),
    @IterationLog varchar(8000),
    @PackExecArray varchar(255),
    @CodeValidExecArray varchar(255),
    @SortOrderExecArray varchar(255),
    @LinksExecArray varchar(255),
    @LastLogWriteDelay int
AS
BEGIN   
    SET NOCOUNT ON;
    UPDATE manufacture.StressTestMonitor  
    SET 
      LastError = @ErrorText,
      LastResponse = GetDate(),
      PackExecSpeed = @EndPackExecSpeed,
      CodeValidExecSpeed = @EndCodeValidExecSpeed,
      SortOrderExecSpeed = @EndSortOrderExecSpeed,
      LinksExecSpeed = @EndLinksExecSpeed,
      [Status] = CASE WHEN @ErrorText <> '(C) 
(S) 
(L) 
(A) ' THEN 0 ELSE 1 END,
      IterationLog = @IterationLog,
      PackExecArray = @PackExecArray,
      CodeValidExecArray = @CodeValidExecArray,
      SortOrderExecArray = @SortOrderExecArray,
      LinksExecArray = @LinksExecArray,
      LastLogWriteDelay = @LastLogWriteDelay
    WHERE StorageStructureID = @StorageStructureID
    SELECT NULL;
END
GO