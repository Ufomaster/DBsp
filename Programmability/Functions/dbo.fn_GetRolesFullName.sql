SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Poliatykin Oleksii$    $Create date:   06.09.2017$
--$Modify:     Poliatykin Oleksii$    $Modify date:   06.09.2017$
--$Version:    1.00$   $Decription: Выводит полное имя роли с учетом пути влеженности$

create FUNCTION [dbo].[fn_GetRolesFullName] (@id int
)
RETURNS varchar(1000)
AS
BEGIN
    declare @st varchar (max) 
    ;
    WITH ResultTable   
    AS 
    (
    SELECT ID, [Name] , ParentID FROM Roles 
    union all  
    SELECT r.ID,  rt.name, rt.ParentID 
    FROM ResultTable as rt 
        JOIN Roles r ON r.ParentID = rt.id 
     )
     select  @st = isnull(@st+'.','') + isnull(b.name,'')
     from 
     (
     select ROW_NUMBER() OVER(PARTITION BY a.ID order by a.ID ) as sort , * 
     from ResultTable a
     where a.id = @id
     ) b
     order by sort desc
RETURN @st
END
GO