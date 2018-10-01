SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Poliatykin Oleksii$    $Create date:   31.08.2017$
--$Modify:     Poliatykin Oleksii$    $Modify date:   18.01.2018$
--$Version:    1.00$   $Decription: Выводит разницу изменений в таблицах детейлов без учета поля Id$

CREATE PROCEDURE [dbo].[sp_TableCompareDetail_Select]
@TableName nvarchar(255),
@ParentField nvarchar(255),
@ParentID nvarchar(255)
AS
BEGIN
    DECLARE @query varchar(max),
        @GCols varchar(max),
        @LCols varchar(max),
        @FieldName varchar(max),
        @exceptDetailFields varchar(max),
        @Compare bit
    
    set @exceptDetailFields = '' -- перечень полей через запятую БЕЗ ПРОБЕЛА, которые не участвуют в сравнении в таблице 
   
    SELECT
     @exceptDetailFields = isnull(@exceptDetailFields+',','') + c.name 
    FROM
        sys.foreign_key_columns AS fk
        INNER JOIN sys.tables AS t ON fk.parent_object_id = t.object_id
        INNER JOIN sys.columns AS c ON fk.parent_object_id = c.object_id AND fk.parent_column_id = c.column_id
    WHERE
        t.name = @TableName
        AND fk.parent_object_id = fk.referenced_object_id
 
    DECLARE Cur_col CURSOR STATIC LOCAL FOR
      select
              column_name as col 
            , case when column_name = a.id then 0 else 1 end Compare
        from INFORMATION_SCHEMA.columns 
            left join (select id from  dbo.fn_StringToSTable(isnull(@exceptDetailFields,''))) a on a.id = column_name
        where  column_name<>'id' and TABLE_NAME=@TableName 
   
    OPEN Cur_col
    FETCH NEXT FROM Cur_col INTO @FieldName, @Compare
    WHILE @@FETCH_STATUS=0               
    BEGIN
        IF @Compare = 1
        begin
            set @GCols = isnull(@GCols+',','') + ' cast(g.'+@FieldName+' as varchar(max))';
            set @LCols = isnull(@LCols+',','') + ' cast(  '+@FieldName+' as varchar(max))';
        end
        FETCH NEXT FROM Cur_col INTO @FieldName, @Compare
    END
    CLOSE Cur_col
    DEALLOCATE Cur_col  
    
    set @query = '
        SELECT 
        case when L.Id is null then 1 else 0 end as _Del1,
        case when g.Id is null then 1 else 0 end as _Del2,
        g.* ,
        BINARY_CHECKSUM('+@GCols+' ) as con
        , L.*
        FROM '+@TableName+' g
        FULL JOIN 
        (
        SELECT  * ,
        BINARY_CHECKSUM('+@LCols+' ) as con
        FROM #'+@TableName+'2  
        ) L on L.'+@ParentField+' = g.'+@ParentField+' and L.con = BINARY_CHECKSUM('+@GCols+' )
        WHERE g.'+@ParentField+' = '+@ParentID+' or L.'+@ParentField+' = '+@ParentID
    EXEC(@query)
END
GO