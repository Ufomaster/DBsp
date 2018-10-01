SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Poliatykin Oleksii$    $Create date:   31.08.2017$
--$Modify:     Poliatykin Oleksii$    $Modify date:   18.01.2018$ 
--$Version:    1.00$   $Decription: Обновляет таблицы из таких же таблиц Name+2 по Id c учетом детейловой$

CREATE PROCEDURE [dbo].[sp_TableCompare_SetUpdate]
@TableNameMaster nvarchar(255),
@TableNameDetail nvarchar(255),
@ParentField nvarchar(255),
@ID int
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @query nvarchar(max)
    DECLARE @query1 nvarchar(max)
    DECLARE @query2 nvarchar(max)
    DECLARE @queryUp nvarchar(max)
    DECLARE @FieldName nvarchar(max)
    DECLARE @FieldNameForign nvarchar(max)
    DECLARE @BCols nvarchar(max)
    DECLARE @CCols nvarchar(max)
    DECLARE @GCols nvarchar(max)
    DECLARE @LCols nvarchar(max)
    DECLARE @tL int
    DECLARE @tR int
    DECLARE @Err Int
    
    DECLARE Cur_col CURSOR STATIC LOCAL FOR
        select column_name as col  from INFORMATION_SCHEMA.columns 
        where column_name<>'id' and TABLE_NAME=@TableNameMaster 

    DECLARE Cur_colDet CURSOR STATIC LOCAL FOR
         SELECT
             c.column_name AS col,
             f.ForeignKeyColumn
         FROM
             INFORMATION_SCHEMA.columns c
             LEFT JOIN 
             (
               SELECT
                   c.name AS ForeignKeyColumn
               FROM
                   sys.foreign_key_columns AS fk
                   INNER JOIN sys.tables AS t ON fk.parent_object_id = t.object_id
                   INNER JOIN sys.columns AS c ON fk.parent_object_id = c.object_id AND fk.parent_column_id = c.column_id
               WHERE
                   t.name = @TableNameDetail
                   AND fk.parent_object_id = fk.referenced_object_id
             ) f ON f.ForeignKeyColumn = c.column_name
         WHERE
             c.column_name <> 'id'
             AND c.TABLE_NAME = @TableNameDetail
    set @query = N'select @tL = tL.id  , @tR = tR.id   from  '+@TableNameMaster+' tL full join  #'+@TableNameMaster+'2 tR on tL.id = tR.id
                 where tL.id = '+cast(@ID as nvarchar(20))+'  or tR.id = '+cast(@ID as nvarchar(20)) 

    EXEC sp_executesql 
    @stmt = @query,
    @params = N'@id as int, @tL as int output, @tR as int output',
    @id = @id,
    @tl = @tL OUTPUT,
    @tr = @tR OUTPUT;
    
    set @BCols = ''
    set @CCols = 'ID'
    OPEN Cur_col
    FETCH NEXT FROM Cur_col INTO @FieldName
    WHILE @@FETCH_STATUS=0               
    BEGIN
        set @BCols = @BCols + ' , '+@FieldName+' =  t2.'+@FieldName;
        set @CCols = @CCols + ' , '+@FieldName;
        FETCH NEXT FROM Cur_col INTO @FieldName                     
    END
    CLOSE Cur_col
    DEALLOCATE Cur_col  
    set @BCols = SUBSTRING(@BCols, 3 , LEN(@BCols))
    set @query1 = ' UPDATE '+@TableNameMaster+'
                   SET '+@BCols+'
                   FROM  '+@TableNameMaster+' t1 
                   JOIN #'+@TableNameMaster+'2 t2  on t1.id = t2.id
                   WHERE  t1.id = ' + cast(@ID as varchar(20))
    set @query2 = ' IF objectproperty(OBJECT_ID('''+@TableNameMaster+'''), ''TableHasIdentity'') = 1 ' +
                  ' SET IDENTITY_INSERT  #'+@TableNameMaster+'2 Off '+
                  ' IF objectproperty(OBJECT_ID('''+@TableNameMaster+'''), ''TableHasIdentity'') = 1 ' +
                  ' SET IDENTITY_INSERT '+@TableNameMaster+' On ' +
                  ' INSERT into '+@TableNameMaster+' ('+@CCols+')
                   SELECT 
                  '+@CCols+'
                   FROM #'+@TableNameMaster+'2 WHERE id = ' + cast(@ID as varchar(20))+
                  ' IF objectproperty(OBJECT_ID('''+@TableNameMaster+'''), ''TableHasIdentity'') = 1 ' +
                  ' SET IDENTITY_INSERT '+@TableNameMaster+' Off ' 

    set @query = N'delete '+@TableNameMaster+' where id = '+ cast(@ID as nvarchar(20));   
  
    BEGIN TRAN
    BEGIN TRY
        IF  isnull(@tL,0) = isnull(@tR, -1) -- данные присутствуют в двух таблицах
            EXEC(@query1);  -- обновляем даныне
        IF  (isnull(@tL,0) = 0) and  (isnull(@tR, 0) <> 0) -- данные присутствуют только в правой таблице
            EXEC(@query2);  -- вставлям данные 
        IF  (isnull(@tL,0) <> 0) and  (isnull(@tR, 0) = 0) -- данные присутствуют только в левой таблице
            EXEC(@query);  -- удаляем данные  
        IF (len(@TableNameDetail) > 0) and (len(@ParentField) >0) -- обновление детейлов если таблица указана
        BEGIN
            set @LCols = ''
            OPEN Cur_colDet
            FETCH NEXT FROM Cur_colDet INTO @FieldName, @FieldNameForign
            WHILE @@FETCH_STATUS=0               
            BEGIN
                IF @FieldNameForign is null 
                    set @LCols = @LCols + ' ,   '+@FieldName;
                FETCH NEXT FROM Cur_colDet INTO @FieldName, @FieldNameForign       
            END
            CLOSE Cur_colDet
            set @LCols = SUBSTRING(@LCols, 3 , LEN(@LCols))   
            set @queryUp = ''
            OPEN Cur_colDet
            FETCH NEXT FROM Cur_colDet INTO @FieldName, @FieldNameForign
            WHILE @@FETCH_STATUS=0               
            BEGIN
                IF @FieldNameForign is not null -- формируе запрос для обновления индексов полей которые ссылаются сами на себя
                    set @queryUp = @queryUp + 
                    ' UPDATE se
                        SET se.'+@FieldNameForign+' = t.'+@FieldNameForign+'
                        FROM '+@TableNameDetail+' se
                        INNER JOIN 
                        (
                        select 
                        x.id,
                        y.id as '+@FieldNameForign+'
                        from 
                        (
                        select
                           a.id,
                           b.id as OldID,
                           b.'+@FieldNameForign+'
                        from 
                        (select BINARY_CHECKSUM('+@LCols+') ch ,  *  from '+@TableNameDetail+' where '+@ParentField+' = '+ cast(@ID as nvarchar(20))+') a 
                        left join 
                        (select BINARY_CHECKSUM('+@LCols+') ch ,  *  from #'+@TableNameDetail+'2 where '+@ParentField+' = '+ cast(@ID as nvarchar(20))+') b 
                        on a.ch = b.ch
                        ) x
                        left join 
                        (
                        select
                           a.id,
                           b.id as OldID,
                           b.'+@FieldNameForign+'
                        from 
                        (select BINARY_CHECKSUM('+@LCols+') ch ,  *  from '+@TableNameDetail+' where '+@ParentField+' = '+ cast(@ID as nvarchar(20))+') a 
                        left join 
                        (select BINARY_CHECKSUM('+@LCols+') ch ,  *  from #'+@TableNameDetail+'2 where '+@ParentField+' = '+ cast(@ID as nvarchar(20))+') b 
                        on a.ch = b.ch
                        ) y
                        on x.'+@FieldNameForign+' = y.oldid
                        ) t
                            ON t.ID = se.ID'                    
                FETCH NEXT FROM Cur_colDet INTO @FieldName, @FieldNameForign       
            END
            CLOSE Cur_colDet
            DEALLOCATE Cur_colDet               
            set @query = N'delete '+@TableNameDetail+' where '+@ParentField+' = '+ cast(@ID as nvarchar(20));   
            EXEC(@query) -- удаляем данные из подчененной таблицы
            set @query = N'INSERT INTO '+@TableNameDetail+' ('+@LCols+')
                           SELECT '+@LCols+' FROM #'+@TableNameDetail+'2 where '+@ParentField+' = '+ cast(@ID as nvarchar(20));   
            EXEC(@query)  -- вставляем данные в подчиненную таблицу 
            EXEC(@queryUp) -- обновляем индексы полей которые ссылаются сами на себя
        END 
    COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO