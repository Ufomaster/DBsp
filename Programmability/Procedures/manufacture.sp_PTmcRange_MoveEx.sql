SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   02.06.2014$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   13.02.2018$*/
/*$Version:    2.00$   $Description: Перемещаем диапазон + запись в хистори + возвращение результата $*/
CREATE PROCEDURE [manufacture].[sp_PTmcRange_MoveEx]
	@TmcID int
	, @FromValue varchar(255)
    , @ToValue varchar(255)
    , @StorageStructureID smallint
    , @EmployeeID int
    , @StatusID tinyint
    , @MultiTMC bit
    , @JobStageID int
    , @isCheck bit = 0 /* If true - don't move, only return data for check */
    , @MoveType tinyint = 2
with recompile
AS
BEGIN
	SET NOCOUNT ON;
    --SET ANSI_WARNINGS OFF;

    DECLARE	@STmcID varchar(11), @SomeTmcID int, @SomeColumnName varchar(18), @GroupColumnName varchar(18), @ColumnName varchar(18)
            , @TmcName varchar(500), @TStorageStructureID smallint, @Query varchar(MAX), @QueryCheckStorage varchar(MAX)
            , @JoinRow varchar(5000), @SelectRow varchar(5000), @TTmcID int, @minID int, @maxID int, @Err Int, @OperationID Int
            , @sortorder int, @TmcID2 int, @TmcParentID int, @ValueFrom2 varchar(255), @ValueTo2 varchar(255), @TableNameHistory Varchar(255)
            , @Time datetime, @TimeT datetime, @TimeA datetime, @TID int, @setPackedDateToNull bit, @CheckNullInStorageStructure bit
            , @QueryT varchar(5000), @TaraType tinyint, @Amount decimal(38,10)
    /*------------*/
	/*PREPaRe DATA*/
    /*------------*/

    IF (@FromValue is null OR @FromValue = '') AND (@ToValue is not null) AND (@ToValue <> '')
        SET @FromValue = @ToValue

    IF (@ToValue is null OR @ToValue = '') AND (@FromValue is not null) AND (@FromValue <> '')
        SET @ToValue = @FromValue

            -- приём на склад        переместить  в брак            вернуть брак         переместить брак   отгрузить
            --(pmmMoveToStorage = 9, pmmMove = 2, pmmSetFailed = 4, pmmReturnFailed = 7, pmmMoveFailed = 8, pmmShip = 10);
    IF @MoveType = 7
        SET @setPackedDateToNull = 1
    ELSE
        SET @setPackedDateToNull = 0

    IF @MoveType in (9, 10)
        SET @CheckNullInStorageStructure = 0
    ELSE
        SET @CheckNullInStorageStructure = 1

    IF object_id('tempdb..#tmpID') IS NOT NULL DROP TABLE #tmpID
    IF object_id('tempdb..#TmpCheckStorage') IS NOT NULL DROP TABLE #TmpCheckStorage
    IF object_id('tempdb..#tID') IS NOT NULL DROP TABLE #tID
    IF object_id('tempdb..#TmpResult') IS NOT NULL DROP TABLE #TmpResult

   /* SET @TimeA = GetDate()*/

   /* SELECT @QueryT = '@TmcID: ' + Cast(@TmcID as varchar(11)) + ', @FromValue: ' + @FromValue + ', @ToValue: ' + @ToValue + ', @StorageStructureID: ' + Cast(@StorageStructureID as varchar(11)) +
                    ', @EmployeeID: ' + Cast(@EmployeeID as varchar(11)) + ', @StatusID: ' + Cast(@StatusID as varchar(11)) + ', @MultiTMC: ' + Cast(@MultiTMC as varchar(11)) +
                    ', @JobStageID: ' + Cast(@JobStageID as varchar(11)) + ', @isCheck: ' + Cast(@isCheck as varchar(11)) + ', @MoveType: ' + Cast(@MoveType as varchar(11)) +
                    ', @setPackedDateToNull' + Cast(@setPackedDateToNull as varchar(11)) + ', @CheckNullInStorageStructure' + Cast(@CheckNullInStorageStructure as varchar(11))
*/
    CREATE TABLE #TmpCheckStorage(StorageStructureID int, TmcID int, Value varchar(255), ID int, StatusID tinyint, isPacked bit, [type] tinyint)
    CREATE TABLE #TmpResult(StorageStructureID int, TmcID int, Value varchar(255), ID int, StatusID int, IsPacked bit, [type] tinyint)

    SET @STmcID = Convert(Varchar(11), @TmcID)

    SELECT TOP 1 @SomeColumnName = itc.GroupColumnName, @sortorder = jsc.SortOrder, @TaraType = jsc.TypeID
    FROM manufacture.JobStageChecks jsc
    INNER JOIN manufacture.JobStages js on jsc.JobStageID = js.ID
    INNER JOIN manufacture.PTmcImportTemplateColumns itc on itc.ID = jsc.ImportTemplateColumnID
    WHERE js.ID = @JobStageID
          AND itc.TmcID = @TmcID
          AND ISNULL(jsc.isDeleted, 0) = 0

    IF @MultiTMC = 1
    BEGIN
        /*----------------------------*/
        /* Check for GroupTable Exists*/
        /*----------------------------*/

        IF NOT EXISTS(SELECT * FROM information_schema.tables t
                      WHERE t.TABLE_SCHEMA = 'StorageData'
                            AND t.TABLE_NAME = 'G_' + CAST(@JobStageID AS Varchar(13)))
        BEGIN
            RAISERROR ('Данные отсутствуют', 16, 1)
            RETURN
        END

        /*-----------------------------*/
        /* Get data for checks and move*/
        /*-----------------------------*/

        SELECT @SelectRow = '', @JoinRow = '', @QueryCheckStorage = NULL, @JoinRow = ''
        DECLARE CRSI CURSOR STATIC LOCAL FOR
                                          SELECT itc.GroupColumnName, jsc.TmcID, jsc.TypeID
                                          FROM manufacture.JobStages js
                                          INNER JOIN manufacture.PTmcImportTemplates it on (js.ID = it.JobStageID) AND (IsNull(it.isDeleted,0) = 0)
                                          INNER JOIN manufacture.JobStageChecks jsc on jsc.JobStageID = js.ID AND ISNULL(jsc.isDeleted,0) = 0
                                          INNER JOIN manufacture.PTmcImportTemplateColumns itc on itc.TemplateImportID = it.ID AND itc.ID = jsc.ImportTemplateColumnID
                                          WHERE js.ID = @JobStageID
                                                AND jsc.CheckLink = 1
                                                AND (jsc.TypeID = 2 OR (jsc.TypeID = 1 AND jsc.SortOrder >= @SortOrder))
                                          ORDER BY itc.ID
        OPEN CRSI
        FETCH NEXT FROM CRSI INTO @GroupColumnName, @TTmcID, @TaraType
        /*Insert only unique values*/
        WHILE @@FETCH_STATUS=0
        BEGIN
            SET @SelectRow = ' [' + CAST(@TTmcID AS Varchar(13))  + '].StorageStructureID' + ' as StorageStructureID,'
            SET @JoinRow = ' LEFT JOIN StorageData.pTMC_'+ CAST(@TTmcID AS Varchar(13)) + ' as [' + CAST(@TTmcID AS Varchar(13))  + '] on g.' + @GroupColumnName + ' = [' + CAST(@TTmcID AS Varchar(13))  + '].ID '

            SET @QueryCheckStorage = IsNull(@QueryCheckStorage + ' UNION ','') + '
            SELECT DISTINCT ' + @SelectRow + '
                   ' + CAST(@TTmcID AS Varchar(13)) + ' as TmcID,
                   [' + CAST(@TTmcID AS Varchar(13))  + '].ID as pID,
                   [' + CAST(@TTmcID AS Varchar(13))  + '].Value as pValue,
                   [' + CAST(@TTmcID AS Varchar(13))  + '].StatusID as StatusID,
                   CASE WHEN [' + CAST(@TTmcID AS Varchar(13))  + '].ParentTMCID IS NULL THEN 0 ELSE 1 END AS isPacked,
                   ' + CAST(@TaraType AS varchar) + '
            FROM (SELECT top 1 t.ID FROM [StorageData].pTMC_'+ @STmcID+' t WHERE Value = '''+ @FromValue +''' ) as tmin,
                 (SELECT top 1 t.ID FROM [StorageData].pTMC_'+ @STmcID+' t WHERE Value = '''+ @ToValue +''' ) as tmax,
                 StorageData.G_' + CAST(@JobStageID AS Varchar(13)) +  ' as g
                 LEFT JOIN StorageData.pTMC_' + @STmcID + ' as pack on pack.ID = g.' + @SomeColumnName +
                 @JoinRow + '
            WHERE pack.ID between (CASE WHEN tmin.ID > tmax.ID THEN tmax.ID ELSE tmin.ID END) AND (CASE WHEN tmin.ID<tmax.ID THEN tmax.ID ELSE tmin.ID END)'

            FETCH NEXT FROM CRSI INTO @GroupColumnName, @TTmcID, @TaraType
        END
        CLOSE CRSI
        DEALLOCATE CRSI

        SET @QueryCheckStorage = 'INSERT INTO #TmpCheckStorage (StorageStructureID, TmcID, ID, Value, StatusID, isPacked, type) ' + @QueryCheckStorage
        EXEC (@QueryCheckStorage)
    END
    ELSE
    BEGIN
        SET @QueryCheckStorage =
            'INSERT INTO #TmpCheckStorage (StorageStructureID, TmcID, ID, Value, StatusID, isPacked, type)
             SELECT StorageStructureID, TmcID, p.ID, p.Value, p.StatusID
                    , CASE WHEN p.ParentTMCID is null THEN 0 ELSE 1 END, ' + CAST(@TaraType AS varchar) + '
             FROM StorageData.pTMC_' + @STmcID + ' p,
                 (SELECT top 1 t.ID FROM [StorageData].pTMC_'+ @STmcID+' t WHERE Value = '''+ @FromValue +''' ) as tmin,
                 (SELECT top 1 t.ID FROM [StorageData].pTMC_'+ @STmcID+' t WHERE Value = '''+ @ToValue +''' ) as tmax
             WHERE p.ID between (CASE WHEN tmin.ID > tmax.ID THEN tmax.ID ELSE tmin.ID END) AND (CASE WHEN tmin.ID<tmax.ID THEN tmax.ID ELSE tmin.ID END)'
        EXEC (@QueryCheckStorage)
    END

    IF @isCheck = 0
    BEGIN
        /*----------------------------------------------*/
        /* Check for Different StorageStructureID exists*/
        /*----------------------------------------------*/

/*            IF EXISTS(SELECT count(*)
                  FROM
                      (SELECT StorageStructureID
                      FROM #TmpCheckStorage
                      GROUP BY StorageStructureID) l
                  HAVING count(*) > 1)
            RAISERROR ('Материалы числятся за разными местами хранения (складами). Одновременное перемещение материалов с разных складов запрещено', 16, 1)
        */
        /*----------------------------------------------*/
        /* Check for Different Statuses exists*/
        /*----------------------------------------------*/

        IF EXISTS(SELECT count(*)
                  FROM
                      (SELECT StatusID
                      FROM #TmpCheckStorage
                      GROUP BY StatusID) l
                  HAVING count(*) > 1)
        BEGIN
            RAISERROR ('Материалы находятся в разных статусах. Перемещение материалов с разными статусами запрещено', 16, 1)
            RETURN
        END


        /*----------------------------------------------*/
        /* Check for Statuses = 'Списан'*/
        /*----------------------------------------------*/

        IF EXISTS(SELECT *
                  FROM #TmpCheckStorage
                  Where StatusID = 3)
        BEGIN
            RAISERROR ('Перемещение материалов в статусе ''Cписан'' запрещено', 16, 1)
            RETURN
        END

        /*----------------------------------------------*/
        /* Check for TMC packed into packages exists*/
        /* We should't move tmc, which included into otherone*/
        /*----------------------------------------------*/

        IF EXISTS(SELECT *
                  FROM #TmpCheckStorage
                  WHERE isPacked = 1)
        BEGIN
            RAISERROR ('Материалы упакованы в тару. Перемещать можно только самую большую тару, в которую входит это ТМЦ', 16, 1)
            RETURN
        END

        /*-----------------------------------------*/
        /* Check permissions for StorageStructureID*/
        /*-----------------------------------------*/

        IF EXISTS(SELECT *
                  FROM
                      (SELECT StorageStructureID
                          FROM #TmpCheckStorage
                          WHERE (StorageStructureID is not null AND @CheckNullInStorageStructure = 0) OR @CheckNullInStorageStructure = 1
                          GROUP BY StorageStructureID
                       ) tab
                      LEFT JOIN (SELECT rss.*
                                 FROM RoleStorageStructure rss
                                      INNER JOIN RoleUsers ru on (rss.RoleID = ru.RoleID)
                                      INNER JOIN Users u on (u.ID = ru.UserID) and (u.EmployeeID = @EmployeeID)) rss on tab.StorageStructureID = rss.StorageStructureID
                  WHERE rss.ID is null)
        BEGIN
            RAISERROR ('Со складов, где находятся выбранные материалы, перемещение для Вас запрещено.', 16, 1)
            RETURN
        END

        IF NOT EXISTS(SELECT tab.StorageStructureID
                      FROM
                          (SELECT @StorageStructureID as StorageStructureID) tab
                          LEFT JOIN RoleStorageStructure rss on tab.StorageStructureID = rss.StorageStructureID
                          LEFT JOIN RoleUsers ru on (rss.RoleID = ru.RoleID)
                          LEFT JOIN Users u on (u.ID = ru.UserID) and (u.EmployeeID = @EmployeeID)
                      WHERE u.ID is not null
                      UNION
                      SELECT @StorageStructureID
                      WHERE @CheckNullInStorageStructure = 0 AND @StorageStructureID is null)
        BEGIN
            RAISERROR ('На выбранный склад перемещение для Вас запрещено.', 16, 1)
            RETURN
        END

        /*-----------------------------------------*/
        /* Check for Different Statuses Exists ???*/
        /* Проблемы с возвратом бракованной продукции*/
        /*-----------------------------------------*/
    END

    /*-----------------------------------------*/
    /* Prepare data to move*/
    /*-----------------------------------------*/
    INSERT INTO #TmpResult (StorageStructureID, TmcID, ID, Value, StatusID, isPacked, type)
    SELECT StorageStructureID, TmcID, ID, Value, StatusID, isPacked, type
    FROM #TmpCheckStorage

    /*-----------------------------------------------*/
    /* BEGIN Prepare all embedded materials for move */
    /*-----------------------------------------------*/
    DECLARE CRSI CURSOR STATIC LOCAL FOR
                                      SELECT TmcID
                                      FROM #TmpCheckStorage
                                      GROUP BY TmcID
    OPEN CRSI
    FETCH NEXT FROM CRSI INTO @TTmcID
    WHILE @@FETCH_STATUS=0
    BEGIN
        SET @TmcParentID = @TTmcID

        SELECT @sortorder = m.SortOrder
        FROM manufacture.JobStageChecks m
        WHERE m.JobStageID = @JobStageID AND m.TmcID = @TmcParentID AND ISNULL(m.isDeleted,0) = 0

        /*check the existance of embedded materials*/
        IF EXISTS (SELECT * FROM manufacture.JobStageChecks jsc
                   WHERE jsc.TmcID = @TTmcID AND jsc.TypeID = 1 AND jsc.JobStageID = @JobStageID AND ISNULL(jsc.isDeleted,0) = 0)
        BEGIN
            /*embedded materials*/
            DECLARE CR CURSOR STATIC LOCAL FOR
                                            SELECT TmcID, TypeID
                                            FROM
                                                (SELECT TmcID, SortOrder, 1 AS TypeID FROM manufacture.JobStageChecks m
                                                WHERE m.JobStageID = @JobStageID AND m.SortOrder >= @sortorder + 1 AND m.TypeID = 1 AND ISNULL(m.isDeleted,0) = 0
                                                UNION ALL
                                                SELECT m.OutputTmcID, 255, 2 FROM manufacture.JobStages m
                                                WHERE m.ID = @JobStageID) tab
                                            ORDER BY SortOrder
            OPEN CR
            FETCH NEXT FROM CR INTO @TmcID2, @TaraType

            /*ranges of parent material*/
            IF object_id('tempdb..#tmpID') IS NOT NULL
                TRUNCATE TABLE #tmpID
            ELSE
                CREATE TABLE #tmpID (ID int, StorageStructureID int)

            INSERT INTO #tmpID (ID, StorageStructureID)
            SELECT ID, StorageStructureID
            FROM #TmpCheckStorage tcs
            WHERE tcs.TmcID = @TmcParentID

            WHILE @@FETCH_STATUS=0
            BEGIN /*  SET @Time = GETDATE()*/
                IF object_id('tempdb..#tID') IS NOT NULL
                    TRUNCATE TABLE #tID
                ELSE
                    CREATE TABLE #tID(StorageStructureID int, TmcID int, Value varchar(255), ID int, StatusID int, isPacked bit, type tinyint)

                /*belonging to the ranges of parent material*/
                EXEC ('INSERT INTO #tID (StorageStructureID, TmcID, ID, Value, StatusID, isPacked, type)
                       SELECT n.StorageStructureID, '+ @TmcID2 +', m.ID, m.value, m.StatusID,
                           CASE WHEN m.ParentTMCID is null THEN 0 ELSE 1 END, ' + @TaraType + '
                       FROM StorageData.pTMC_'+ @TmcID2 +' m
                           LEFT JOIN StorageData.pTMC_'+ @TmcParentID +' n on m.ParentPTMCID = n.ID
                           LEFT JOIN #tmpID c on (n.ID = c.ID) AND (n.StorageStructureID = c.StorageStructureID)
                       WHERE c.StorageStructureID is not null
                      ')

                TRUNCATE TABLE #tmpID

                INSERT INTO #tmpID (ID, StorageStructureID)
                SELECT ID, StorageStructureID
                FROM #tID

                INSERT INTO #TmpResult (StorageStructureID, TmcID, ID, Value, StatusID, isPacked, [type])
                SELECT StorageStructureID, TmcID, ID, Value, StatusID, isPacked, type
                FROM #tID

              /*  SELECT Cast(@TmcID2 as varchar) + '. Select: ' + Cast(DATEDIFF(ms, @Time, GetDate()) as varchar)
                SET @Time = GETDATE()               */

                SET @TmcParentID=@TmcID2

                FETCH NEXT FROM CR INTO @TmcID2, @TaraType
            END
            CLOSE CR
            DEALLOCATE CR
        END
        FETCH NEXT FROM CRSI INTO @TTmcID
    END
    CLOSE CRSI
    DEALLOCATE CRSI
    /*--------------------------------------------*/
    /* END Prepare all embedded materials for move*/
    /*--------------------------------------------*/

    /*----------------------*/
    /* SELECT data for check*/
    /*----------------------*/
    IF @isCheck = 1
    BEGIN
        SELECT trMin.StorageStructureID, t.TmcID, tm.[Name] as TmcName, trMin.ID as minID, trMin.Value as minValue, trMax.ID as maxID, trMax.Value as maxValue, t.cnt
        FROM
            (SELECT TmcID, min(ID) minID, max(ID) maxID, count(*) as cnt
            FROM #TmpResult
            GROUP BY TmcID) t
            INNER JOIN #TmpResult trMin on (trMin.ID = t.MinID) AND (trMin.TmcID = t.TmcID)
            INNER JOIN #TmpResult trMax on (trMax.ID = t.MaxID) AND (trMax.TmcID = t.TmcID)
            LEFT JOIN Tmc tm on tm.ID = t.TmcID
    END
    ELSE
    IF @isCheck = 0
    BEGIN
        BEGIN TRAN
        BEGIN TRY
            /*-----------------------------------------*/
            /* MOVE all ranges                         */
            /*-----------------------------------------*/

            /* 1 Loging move operation*/
            INSERT INTO manufacture.PTmcRangeMoveLog(TmcID, FromValue, ToValue, StorageStructureID, EmployeeID,
                StatusID, MultiTMC, JobStageID, MoveType)
            SELECT @TmcID, @FromValue, @ToValue, @StorageStructureID, @EmployeeID, @StatusID, @MultiTMC, @JobStageID, @MoveType

            /* 2 Get OperationType ID */
            DECLARE @OpT TABLE(ID Int)

            INSERT INTO manufacture.PTmcOperations (ModifyDate, EmployeeID, OperationTypeID, JobStageID)
            OUTPUT INSERTED.ID INTO @OpT
            VALUES (GetDate(), @EmployeeID, @MoveType, CASE WHEN @JobStageID = -1 THEN NULL ELSE @JobStageID END)

            SELECT @OperationID = ID FROM @OpT

            /* 3 move */

            DECLARE Val CURSOR STATIC LOCAL FOR
                                              SELECT TmcID FROM #TmpResult t
                                              GROUP BY t.TmcID
            OPEN Val
            FETCH NEXT FROM Val INTO @TTmcID
            WHILE @@FETCH_STATUS=0
            BEGIN
                /*SAVE pTMC - Operation LINK*/
                INSERT INTO manufacture.PTmcOperationTmcs(OperationID, TmcID)
                SELECT @OperationID, @TTmcID
                --UPDATE Tmc SET LastAccessDate = GetDate() WHERE ID = @TTmcID AND LastAccessDate < GetDate() 
                SELECT @Query =
                     'UPDATE tab
                      SET StorageStructureID = ' + IsNull(CAST(@StorageStructureID as varchar(13)),'null') +',
                          StatusID = ' + CAST(@StatusID as varchar(13)) +',
                          OperationID = ' + CAST(@OperationID as varchar(13)) + '
                      FROM (SELECT t.*
                            FROM
                               [StorageData].pTMC_'+ CAST(@TTmcID as varchar(13))+ ' t
                               INNER JOIN #TmpResult tr on t.ID = tr.ID
                            WHERE tr.TmcID = ' + CAST(@TTmcID as varchar(13))+ '
                            ) as tab
                      '

                /*update pTMC*/
                EXEC (@Query)

                /*Insert into history*/
                SET @TableNameHistory = (SELECT manufacture.fn_GetPTmcTableNameHistory(@TTmcID))
                EXEC ('
                    INSERT INTO '+ @TableNameHistory + '([pTmcID], [StatusID], [OperationID], [ModifyDate], [ModifyEmployeeID], [OperationType],
                        [ParentTMCID], [ParentPTMCID], [EmployeeGroupsFactID], [PackedDate], StorageStructureID)
                    SELECT t.[ID], t.[StatusID], t.[OperationID], Getdate(), ' + @EmployeeID + ', 1,
                        [ParentTMCID], [ParentPTMCID], [EmployeeGroupsFactID], [PackedDate], StorageStructureID
                    FROM [StorageData].pTMC_'+ @TTmcID+' t
                    WHERE t.OperationID = ' + @OperationID + '
                    ORDER BY t.ID
                    ')

                /*Recalculate StorageStructureTmcsGroupPTmc*/
                EXEC manufacture.sp_PTmcGroups_Calculate @TTmcID

                FETCH NEXT FROM Val INTO @TTmcID
            END
            CLOSE Val
            DEALLOCATE Val
            /*-----------------------------------------*/
            /* END MOVE all ranges                     */
            /*-----------------------------------------*/

            /*-----------------------------------------*/
            /* SET NULL to Boxes                       */
            /*-----------------------------------------*/
            --SELECT @QueryT = @QueryT + '; Before SET NULL to Box: '+ CAST(@setPackedDateToNull as varchar(11))
            SET @Query = null
            IF @setPackedDateToNull = 1 BEGIN
                --Get Column Name
--IF object_id('tempdb..#Res') is not null DROP TABLE #Res
                CREATE TABLE #Res (ID int, ColumnName varchar(18))

                --SELECT @QueryT = @QueryT + '; @JobStageID: ' + CAST(IsNull(@JobStageID,0) as varchar(11)) + ', @TmcID: ' + CAST(IsNull(@TmcID,0) as varchar(11)) + ', @FromValue: ' + IsNull(@FromValue,'')

               --INSERT INTO manufacture.[Log](Query)
               --SELECT 'EXEC manufacture.sp_GetGroupColumnName ' + CAST(@JobStageID AS varchar) + ',  ' + CAST(@TmcID AS varchar) + ', ' + @FromValue

                INSERT INTO #Res(ID, ColumnName)
                EXEC manufacture.sp_GetGroupColumnName @JobStageID, @TmcID, @FromValue

                SELECT TOP 1 @TID = ID, @ColumnName = ColumnName
                FROM #Res

                --SELECT @QueryT = @QueryT + '; @TID: ' + CAST(IsNull(@TID,0) as varchar(11)) + ', @ColumnName: ' + IsNull(@ColumnName,'')

                --Get Boxes
--IF object_id('tempdb..#Ress') is not null DROP TABLE #Ress
                CREATE TABLE #Ress (G_ID int, ID int, [Value] varchar(255), [Name] varchar(255), SortOrder int, TypeID int,
                                   JobStageChecksID int, OutputNameFromTmcID int, OutputTmcID int, TmcID int)

                INSERT INTO #Ress (G_ID, ID, [Value], [Name] , SortOrder, TypeID ,
                                  JobStageChecksID, OutputNameFromTmcID , OutputTmcID, TmcID)
                EXEC manufacture.sp_MDSChainValue_Select @TID, @ColumnName, @JobStageID, 1

                DECLARE CRSI CURSOR STATIC LOCAL FOR
                                                  SELECT ID, TmcID
                                                  FROM #Ress r
                                                  WHERE r.TypeID = 1

                OPEN CRSI

                FETCH NEXT FROM CRSI INTO @TID, @TTmcID
                --SELECT @QueryT = @QueryT + '; @TID: ' + CAST(IsNull(@TID,0) as varchar(11))  + '; @TTmcID: ' + CAST(IsNull(@TTmcID,0) as varchar(11))
                WHILE @@FETCH_STATUS = 0
                BEGIN
                    SET @Query = IsNull(@Query,'') + '
                    UPDATE StorageData.pTMC_' + Convert(varchar(13), @TTmcID) +'
                    SET PackedDate = null
                    WHERE ID = ' + Convert(varchar(13), @TID)

                    FETCH NEXT FROM CRSI INTO @TID, @TTmcID
                    --SELECT @QueryT = @QueryT + '; @TID: ' + CAST(IsNull(@TID,0) as varchar(11))  + '; @TTmcID: ' + CAST(IsNull(@TTmcID,0) as varchar(11))
                END

                CLOSE CRSI
                DEALLOCATE CRSI

                --SELECT @QueryT = @QueryT + '; SET NULL:' + IsNull(@Query,'')
                EXEC (@Query)

                --IF object_id('tempdb..#Ress') is not null
                DROP TABLE #Ress
                --IF object_id('tempdb..#Res') is not null
                DROP TABLE #Res
            END
            /*-----------------------------------------*/
            /* END SET NULL to Boxes                   */
            /*-----------------------------------------*/
            COMMIT TRAN
        END TRY
        BEGIN CATCH
            SET @Err = @@ERROR
            IF @@TRANCOUNT > 0 ROLLBACK TRAN
            EXEC sp_RaiseError @ID = @Err
            SELECT null
        END CATCH
    END
    --INSERT INTO manufacture.Test(Value) SELECT @QueryT
    /*SELECT 'ALLL: ' + + Cast(DATEDIFF(ms, @TimeA, GetDate()) as varchar)                            */
END
GO