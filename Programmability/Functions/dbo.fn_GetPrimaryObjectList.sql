SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Anatoliy Zapadinskiy$    $Create date:   26.12.2012$
--$Modify:     Anatoliy Zapadinskiy$    $Modify date:   26.12.2012$
--$Version:    1.00$   $Decription: возвращает список привязанных основных средств для выбранного TMC$
CREATE FUNCTION [dbo].[fn_GetPrimaryObjectList] (@TmcID int)
    RETURNS varchar(2000)
AS
BEGIN           
	DECLARE @Res varchar(2000)
    SET @Res = ''
          
    SELECT 
    	   @Res = @Res + ', ' + otroot.[Name]
    FROM ObjectTypes ot
        LEFT JOIN dbo.TmcObjectLinks ol ON ol.ObjectID = ot.ID AND ol.TmcID = @TmcID
        LEFT JOIN dbo.Tmc t ON t.ObjectTypeID = ot.ID AND t.ID = @TmcID
        LEFT JOIN ObjectTypes otroot on (ot.ID is not null) AND (otroot.ID = dbo.fn_GetPrimaryObject(ot.ID))
    WHERE ol.ObjectID is not null 
          AND t.ObjectTypeID IS NULL 
    GROUP BY otroot.[Name]

	RETURN Substring(@Res,3,len(@Res)) 
END
GO