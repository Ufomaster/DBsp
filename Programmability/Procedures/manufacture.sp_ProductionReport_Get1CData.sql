SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$	$Create date:   12.12.2017$*/
/*$Modify:     Yuriy Oleynik$	$Modify date:   29.03.2018$*/
/*$Version:    1.00$   $Decription: Получение информации о выработке из 1с. сдельные наряды и табель$*/
CREATE PROCEDURE [manufacture].[sp_ProductionReport_Get1CData]
    @StartDate datetime = null, 
    @EndDate datetime = null
AS
BEGIN
    SELECT @StartDate = ISNULL(@StartDate, '06.01.2017'), @EndDate = ISNULL(@EndDate, GetDate())
    
    DECLARE @Hours varchar(20), @HoursType varchar(20), @DayNumber tinyint, @TypeNumber tinyint, @Q varchar(max)
    IF object_id('tempdb..#UsersTimesDetail') IS NOT NULL DROP TABLE #UsersTimesDetail

    CREATE TABLE #UsersTimesDetail (ID int IDENTITY(1,1) NOT NULL,   UsersTimesID binary(16) NOT NULL,
      UserID binary(16) NOT NULL, Hours tinyint NULL, HoursType binary(16) NULL, DayNumber tinyint NOT NULL,
      TypeNumber tinyint NOT NULL);
 
    DECLARE CRS CURSOR STATIC LOCAL FOR
        SELECT Hours, HoursType, DayNumber, TypeNumber
        FROM manufacture.vw_1CTimeFields
    OPEN CRS
    FETCH NEXT FROM CRS INTO @Hours, @HoursType, @DayNumber, @TypeNumber
    WHILE @@FETCH_STATUS=0
    BEGIN
        SELECT @Q =
         'INSERT INTO #UsersTimesDetail(UsersTimesID, UserID, Hours, HoursType, DayNumber, TypeNumber)
          SELECT a._Document21690_IDRRef,
             a._Fld21727RRef,
                     ' + @Hours + ',
                     ' + @HoursType + ',
                     ' + CAST(@DayNumber AS varchar) + ',
                     ' + CAST(@TypeNumber AS varchar) + '
              FROM COne83.Spekl_w_83.dbo._Document21690_VT21725  a
              INNER JOIN COne83.Spekl_w_83.dbo._Document21690 ut on ut._IDRRef = a._Document21690_IDRRef
                  AND DATEADD(yy, -2000, ut._Date_Time) BETWEEN ''' + CAST(@StartDate AS varchar) + ''' AND ''' + CAST(@EndDate  as varchar) + '''
                  AND ut._Marked = 0
              '          
        EXEC(@Q)
        FETCH NEXT FROM CRS INTO @Hours, @HoursType, @DayNumber, @TypeNumber
    END

    SELECT
        ISNULL(t.Date, SD1C.DateT__) as [DateT]
        , ISNULL(t.INN, SD1C.INN__) AS INN 
        , SUM(t.TimeInSec1C) as TimeT
        , '1C' as TypeT
        , SD1C.PCCNumber__
        , SD1C.SumTime__
        , SD1C.SumAmount__
        , SD1C.TOCode1C COLLATE Cyrillic_General_CI_AS AS TOCode1C
        , SD1C.TechnologicalOperationID
    FROM 
        (SELECT utd.Hours*3600 as TimeInSec1C
               , DATEADD(dd, utd.DayNumber - 1 , DATEADD(yy, -2000, ut._Fld21716)) as [Date]
               , FizLitho._Fld3009 COLLATE Cyrillic_General_CI_AS AS INN
        FROM #UsersTimesDetail utd
             INNER JOIN COne83.Spekl_w_83.dbo._Document21690 ut on ut._IDRRef = utd.UsersTimesID
             LEFT JOIN COne83.Spekl_w_83.dbo._Reference192 as sotrudnik on sotrudnik._IDRRef = utd.UserID
             LEFT JOIN COne83.Spekl_w_83.dbo._Reference237 as FizLitho on FizLitho._IDRRef = sotrudnik._Fld2479RRef              
             LEFT JOIN COne83.Spekl_w_83.dbo._Reference99 as TimeType on TimeType._IDRRef = utd.HoursType
        WHERE utd.Hours > 0 AND ut._Marked = 0
             AND TimeType._Fld1747 in (01,31,32,06) /* Работа, Інша робота (за відрядною оплатою праці), Інша робота (заміщення),  Години роботи у вихідні й святкові дні*/
        ) AS t
    FULL JOIN     
        (SELECT  --Сдельные наряды - уже оформленные в 1с.
            CASE 
                WHEN DATEPART(yy, WorkData._Fld23535) < 3000 THEN CAST(CONVERT(Varchar(8), WorkData._Fld23535, 112) AS Datetime)
                ELSE CAST(CONVERT(Varchar(8), DATEADD(yy, -2000, WorkData._Fld23535), 112) AS Datetime)
            END AS [DateT__],
            FizE._Fld3009 COLLATE Cyrillic_General_CI_AS AS INN__,
            ZL._fld22173 COLLATE Cyrillic_General_CI_AS AS PCCNumber__,
            SUM(WorkData._Fld23536) AS SumTime__,
            SUM(WorkData._Fld21712) AS SumAmount__,
            dbo.fn_Binary1CGuidToString(WorkData._Fld21710RRef) AS TOCode1C, --TechOp._Description AS TechOpName__,
            t1c.ID AS TechnologicalOperationID
        FROM COne83.Spekl_w_83.dbo._Document21689 d
        LEFT JOIN COne83.Spekl_w_83.dbo._Document21689_VT21702 detE ON detE._Document21689_IDRRef = d._IDRRef
        LEFT JOIN COne83.Spekl_w_83.dbo._Reference237 as FizE ON FizE._IDRRef = detE._Fld21704RRef
        LEFT JOIN COne83.Spekl_w_83.dbo._Reference192 as Employee on Employee._Fld2479RRef = FizE._IDRRef
        INNER JOIN COne83.Spekl_w_83.dbo._Document21689_VT21707 AS WorkData ON WorkData._Document21689_IDRRef = d._IDRRef AND WorkData._Fld21709RRef = Employee._IDRRef
            AND (ISNULL(WorkData._Fld23536,0) > 0 OR ISNULL(WorkData._Fld21712, 0) > 0 ) AND WorkData._Fld23535 IS NOT NULL
        LEFT JOIN COne83.Spekl_w_83.dbo._Document301 ZL ON ZL._IDRRef = WorkData._Fld23537RRef AND CAST(ZL._Posted AS int) = 1
        LEFT JOIN COne83.Spekl_w_83.dbo._Reference223 AS TechOp ON WorkData._Fld21710RRef = TechOp._IDRRef AND CAST(TechOp._Marked AS int) = 0
        LEFT JOIN manufacture.TechnologicalOperations t1c ON t1c.Code1C = dbo.fn_Binary1CGuidToString(WorkData._Fld21710RRef)
        WHERE CAST(d._Posted AS int) = 1 AND CAST(d._Marked AS int) = 0 AND 
            DATEADD(yy, -2000, d._Date_Time) > '06.01.2017'
            AND
            CASE
                WHEN DATEPART(yy, WorkData._Fld23535) < 3000 THEN CAST(CONVERT(Varchar(8), WorkData._Fld23535, 112) AS Datetime)
                ELSE CAST(CONVERT(Varchar(8), DATEADD(yy, -2000, WorkData._Fld23535), 112) AS Datetime)
            END BETWEEN @StartDate AND @EndDate
        GROUP BY CASE
                WHEN DATEPART(yy, WorkData._Fld23535) < 3000 THEN CAST(CONVERT(Varchar(8), WorkData._Fld23535, 112) AS Datetime)
                ELSE CAST(CONVERT(Varchar(8), DATEADD(yy, -2000, WorkData._Fld23535), 112) AS Datetime)
            END, FizE._Fld3009, Employee._Description, ZL._fld22173, TechOp._Description, WorkData._Fld21710RRef, t1c.ID)
        AS SD1C ON SD1C.DateT__ = t.Date AND RTRIM(LTRIM(SD1C.INN__)) = RTRIM(LTRIM(t.INN))
    GROUP BY t.Date, SD1C.DateT__, t.INN, SD1C.INN__, SD1C.PCCNumber__, SD1C.SumTime__, SD1C.SumAmount__, SD1C.TOCode1C, SD1C.TechnologicalOperationID
    DROP TABLE #UsersTimesDetail
END
GO