SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$	$Create date:   24.02.2011$
--$Modify:     Yuriy Oleynik$	$Modify date:   24.02.2011$
--$Version:    1.00$   $Decription: Генерируем Айдишку и имя поля$
CREATE PROCEDURE [dbo].[sp_TmcTree_GenFieldName]
AS
BEGIN
    DECLARE @ID Int, @Count Int, @FieldName Varchar(20)
    
    SELECT @Count = COUNT(*)
    FROM #Properties
    
    SELECT @ID = ISNULL(MAX(ID), 0)
    FROM #Properties
/*  --все пропуски      
    SELECT br.ID - 1,
    a.*,
    br.*
    FROM #Properties a
    FULL JOIN #Properties br ON br.ID - 1 = a.ID
    WHERE a.ID IS NULL*/
    
    IF @Count < @ID -- то у нас есть удаление, и соотв. пропуск айдишки.
        SELECT TOP 1 @ID = br.ID - 1    
        FROM #Properties a
        FULL JOIN #Properties br ON br.ID - 1 = a.ID
        WHERE a.ID IS NULL AND br.ID > 1
    ELSE
        SELECT @ID = @ID + 1
        
    SELECT @ID AS ID, CAST('fld_' + CAST(@ID AS Varchar) AS Varchar(10)) 
END
GO