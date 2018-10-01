SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Poliatykin Oleksii$    $Create date:   31.08.2017$
--$Modify:     Poliatykin Oleksii$    $Modify date:   18.01.2018$
--$Version:    1.00$   $Decription: Выводит разницу изменений в таблицах$

CREATE PROCEDURE [dbo].[sp_TableCompare_Select]
@TableNameMaster varchar(255),
@TableNameDetail varchar(255),
@ParentField varchar(255),
@VisibleAll bit
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @query varchar(max),
        @ColsAll varchar(max),
        @From varchar(max),
        @ParentJoin varchar(max),
        @FieldName varchar(max),
        @ColsChange varchar(max),
        @FromToSel varchar(max),
        @IntoSel varchar(max),
        @BCols varchar(max),
        @CCols varchar(max),
        @GCols varchar(max), 
        @LCols varchar(max), 
        @exceptMasterFields varchar(max),
        @exceptDetailFields varchar(max),
        @Compare bit
     
    -- ПАРАМЕТРЫ СРАВНЕНИЯ 
    set @exceptMasterFields = '' -- перечень полей через запятую БЕЗ ПРОБЕЛА, которые не участвуют в сравнении в Master таблице 
    set @exceptDetailFields = '' -- перечень полей через запятую БЕЗ ПРОБЕЛА, которые не участвуют в сравнении в Detail таблице      
    -- ВАЖНО -- @exceptDetailFields установить таким же и в процедуре dbo.sp_TableCompareDetail_Select

    SELECT
     @exceptDetailFields = isnull(@exceptDetailFields+',','') + c.name 
    FROM
        sys.foreign_key_columns AS fk
        INNER JOIN sys.tables AS t ON fk.parent_object_id = t.object_id
        INNER JOIN sys.columns AS c ON fk.parent_object_id = c.object_id AND fk.parent_column_id = c.column_id
    WHERE
        t.name = @TableNameDetail
        AND fk.parent_object_id = fk.referenced_object_id
   
    DECLARE Cur_col CURSOR STATIC LOCAL FOR
        select
              column_name as col 
            , case when column_name = a.id then 0 ELSE 1 end Compare
        from INFORMATION_SCHEMA.columns 
            left join (select id from  dbo.fn_StringToSTable(isnull(@exceptMasterFields,''))) a on a.id = column_name
        where TABLE_NAME=@TableNameMaster 

    DECLARE Cur_colDet CURSOR STATIC LOCAL FOR
        select
              column_name as col 
            , case when column_name = a.id then 0 ELSE 1 end Compare
        from INFORMATION_SCHEMA.columns 
            left join (select id from  dbo.fn_StringToSTable(isnull(@exceptDetailFields,''))) a on a.id = column_name
        where  column_name<>'id' 
        and TABLE_NAME=@TableNameDetail  
    
    set @ColsChange=''
    set @FromToSel ='' 
    set @IntoSel =''
    set @BCols = ''
    set @CCols = ''
    
    OPEN Cur_col
    FETCH NEXT FROM Cur_col INTO @FieldName, @Compare
    WHILE @@FETCH_STATUS=0               
    BEGIN
        set @BCols = @BCols + ' , b.'+@FieldName+' AS '+@FieldName+'_L_ ';
        set @CCols = @CCols + ' , c.'+@FieldName+' AS '+@FieldName+'_R_ ';
        if @Compare = 1 
        begin
            set @ColsChange = @ColsChange + ' , case when isnull(e.'+@FieldName+'_ch,0)<>isnull(f.'+@FieldName+'_ch,0) then 1 ELSE 0 end as '+@FieldName+'_C_ '
            set @FromToSel = @FromToSel + ' , BINARY_CHECKSUM(cast('+@FieldName+' as varchar(max))) as '+@FieldName+'_ch'
            set @IntoSel = @IntoSel + ' , cast('+@FieldName+' as varchar(max))'
        end 
        FETCH NEXT FROM Cur_col INTO @FieldName, @Compare                   
    END
    CLOSE Cur_col
    DEALLOCATE Cur_col  
    
    OPEN Cur_colDet
    FETCH NEXT FROM Cur_colDet INTO @FieldName, @Compare
    WHILE @@FETCH_STATUS=0               
    BEGIN
        if @Compare = 1 
        begin
            set @GCols = isnull(@GCols+',','') + ' cast(g.'+@FieldName+' as varchar(max))';
            set @LCols = isnull(@LCols+',','') + ' cast(  '+@FieldName+' as varchar(max))';
        end    
        FETCH NEXT FROM Cur_colDet INTO @FieldName, @Compare                   
    END
    CLOSE Cur_colDet
    DEALLOCATE Cur_colDet  
    
    IF (@ParentField<>'') and (@TableNameDetail<>'') 
        set  @ColsAll = ' select
        a.id as IDS
        , case
        when (isnull(b.con,0)=0)  and (ISNULL(c.con,0)<>0)  then 1
        when (isnull(b.con,0)<>0) and (ISNULL(c.con,0)=0)   then 2 
        when (b.con<>c.con) or (isnull(d.ch,0)>0) then 3 
        ELSE 0 end as _Info_L
        , case
        when (isnull(b.con,0)=0)  and (ISNULL(c.con,0)<>0)  then 2
        when (isnull(b.con,0)<>0) and (ISNULL(c.con,0)=0)   then 1 
        when (b.con<>c.con) or (isnull(d.ch,0)>0) then 3 
        ELSE 0 end as _Info_R
        '+@BCols+'
        '+@CCols+' '
    ELSE 
        set @ColsAll = ' select
        a.id as IDS
        , case
        when (isnull(b.con,0)=0)  and (ISNULL(c.con,0)<>0)  then 1
        when (isnull(b.con,0)<>0) and (ISNULL(c.con,0)=0)   then 2 
        when (b.con<>c.con) then 3 
        ELSE 0 end as _Info_L
        , case
        when (isnull(b.con,0)=0)  and (ISNULL(c.con,0)<>0)  then 2
        when (isnull(b.con,0)<>0) and (ISNULL(c.con,0)=0)   then 1 
        when (b.con<>c.con) then 3 
        ELSE 0 end as _Info_R
        '+@BCols+'
        '+@CCols+' ' ;
 
    set @From = ' from 
    (
    SELECT Id  from '+@TableNameMaster+'
    union 
    SELECT Id  from #'+@TableNameMaster+'2 
    ) a
    left join (select *, BINARY_CHECKSUM(cast(Id as Varchar(max))'+@IntoSel+' ) as con from '+@TableNameMaster+') b on a.id = b.id
    left join (select *, BINARY_CHECKSUM(cast(Id as Varchar(max))'+@IntoSel+' ) as con from #'+@TableNameMaster+'2) c on a.id = c.id 
    left join (select id '+@FromToSel+' from '+@TableNameMaster+') e on a.id = e.id
    left join (select id '+@FromToSel+' from #'+@TableNameMaster+'2) f on a.id = f.id
    '
    IF (@ParentField<>'') and (@TableNameDetail<>'') 
        set @ParentJoin = 'left join 
        (
         select 
         ISNULL(L.'+@ParentField+',g.'+@ParentField+') as ids,
         sum(case when L.id is null or G.id  is null then 1 ELSE 0 end) as ch
         from '+@TableNameDetail+' g
         full
         JOIN 
         (
         select  * ,
         BINARY_CHECKSUM('+@LCols+') as con
         from #'+@TableNameDetail+'2
         ) L on L.'+@ParentField+' = g.'+@ParentField+' and L.con = BINARY_CHECKSUM('+@GCols+')
         group by ISNULL(L.'+@ParentField+',g.'+@ParentField+')
         ) d  on d.ids = a.id' 
    ELSE
        set @ParentJoin = ' '
    IF @VisibleAll = 1 
        set @query =  @ColsAll + @ColsChange + @From + @ParentJoin
    ELSE  
        set @query = ' Select * from ( '+ @ColsAll + @ColsChange + @From + @ParentJoin + ') res where 
        _Info_L <> 0 or _Info_R <> 0 '
    EXEC(@query)

END
GO