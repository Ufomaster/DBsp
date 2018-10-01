SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   03.10.2013$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   03.10.2013$*/
/*$Version:    1.00$   $Decription: возвращает xml настроек как таблицу$*/
create FUNCTION [dbo].[fn_XMLPropsValues2Table] (@XML xml)
    RETURNS @Res TABLE (ID int, FieldName varchar(255), Val varchar(3000))
AS
BEGIN
    INSERT INTO @Res(ID, FieldName, Val)
    SELECT nref.value('(ID)[1]', 'int'), nref.value('(FieldName)[1]', 'varchar(255)'), nref.value('(Value)[1]', 'varchar(1000)') 
    FROM @XML.nodes('/Data/Props') R(nref)
    
    RETURN
END
GO