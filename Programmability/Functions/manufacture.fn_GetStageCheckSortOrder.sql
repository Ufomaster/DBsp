SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Zapadinskiy Anatoliy$    $Create date:   07.02.2014$
--$Modify:     Zapadinskiy Anatoliy$    $Modify date:   18.04.2014$
--$Version:    1.00$   $Decription: возвращает следующий порядковый номер для проверки текущего этапа$
create FUNCTION [manufacture].[fn_GetStageCheckSortOrder] (@StageID int)
    RETURNS tinyint
AS
BEGIN
    DECLARE @res tinyint
    
    IF EXISTS(SELECT TOP 1 ID FROM manufacture.JobStageChecks jsc WHERE (jsc.JobStageID = @StageID) AND (jsc.isDeleted <> 1))
    BEGIN
        SELECT @res = MAX(jsc.SortOrder) + 1 FROM manufacture.JobStageChecks jsc WHERE (jsc.JobStageID = @StageID) AND (jsc.isDeleted <> 1)
    END
    ELSE
        SET @res =  1
    
    RETURN @res
END
GO