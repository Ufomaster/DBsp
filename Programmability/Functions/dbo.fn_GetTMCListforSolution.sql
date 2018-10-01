SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Lutsenko Anastasiya$    $Create date:   21.05.2014$
--$Modify:     Lutsenko Anastasiya$    $Modify date:   21.05.2014$
--$Version:    1.00$   $Decription: возвращает список $
create FUNCTION [dbo].[fn_GetTMCListforSolution] (@SolutionID int, @Type int)
    RETURNS varchar(4000)
AS
BEGIN           
	DECLARE @TmcName varchar(4000), @Article varchar(4000)
    SET @TmcName=''
    SET @Article=''

SELECT 
       @TmcName=@TmcName + ', ' + CAST(Tmc.[Name] AS varchar(4000)),
       @Article=@Article + ', ' + CAST(Tmc.PartNumber AS varchar(4000))
FROM Solutions s
LEFT JOIN SolutionTmc St ON St.SolutionID=S.ID
LEFT JOIN Tmc ON TMC.ID=St.TmcID
WHERE Tmc.[Name] is not null and Tmc.PartNumber is not null and s.ID=@SolutionID
group by Tmc.[Name], Tmc.PartNumber
    
	RETURN CASE WHEN @Type=1 THEN Substring(@TmcName,3,len(@TmcName))
                WHEN @Type=2 THEN Substring(@Article,3,len(@Article))
           END     
END
GO