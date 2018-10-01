SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   14.03.2014$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   08.12.2014$*/
/*$Version:    1.00$   $Decription: $*/
CREATE PROCEDURE [manufacture].[sp_OperatorPackCheck]
    @JobStageID int,
    @HandyClose bit,
    @CurColName varchar(255),
    @CurDynamicID int,
    @CurValue varchar(255),
    @CurMaxCount int,
    @CurCheckLink bit,
    @CurTmcID int,
    @NextTMCID int,
    @NextColName varchar(255),
    @NextTypeID int,
    @StorageStructureID int
AS
BEGIN 
    SET NOCOUNT ON    
    DECLARE @Query varchar(8000), @QueryP varchar(8000), @Dynamic_ID varchar(255)
    IF @CurDynamicID = 0
        SELECT @Dynamic_ID = '(SELECT ID FROM StorageData.pTMC_' + CAST(@CurTmcID AS varchar) + ' WHERE Value = ''' + @CurValue + ''')'
    ELSE
        SELECT @Dynamic_ID = CAST(@CurDynamicID AS Varchar)
     
    /*
    Как работает. Передаем в параметры Текущий айтем и следующий.
    Если следующий айтем - сборка, то ищем упакованное содержимое по груп тейбл с джойном по Птмц
    Если следующий айтем - тара, то  ищем упакованное содержимое по ПТЦ по полю Парент ТМЦИД.
    
    Далее, Сколько всего нужно упаковать.
    Если Чек Дб - то ищем все по групповой  таблице. ручной упаковки быть не может.
    Если не чекДБ - то смотрим ограничение МАКС. 
              Если Макс не задан, то всегда возвращаем состояние "НЕ ЗАПОЛНЕНА" через SELECT 1 в случае автоматической упаковки ручной тары
              и SELECT 0 в случае насильной запаковки ручной тары
              
              Если макс задан, то всегда возвращаем SELECT @MaxCount в случае автоматический упаковки ручной тары
              и SELECT 0 в случае насильной запаковки ручной тары
    */
    
    --Часть 1. Генерация запроса для подсчета реально упакованной продукции    
    IF @NextTypeID = 2
        SELECT @QueryP = 
        ' SELECT COUNT(a.ID) FROM [StorageData].G_' + CAST(@JobStageID AS varchar) + ' a ' +
        ' INNER JOIN [StorageData].pTMC_' + CAST(@NextTMCID AS varchar) + ' t ON t.ID = a.' + @NextColName + ' AND t.StatusID IN (3,4) ' +
        ' WHERE a.' + @CurColName + ' = ' + @Dynamic_ID
    ELSE
    IF @NextTypeID = 1
        SELECT @QueryP = 
        ' SELECT COUNT(ID) FROM [StorageData].pTMC_' + CAST(@NextTMCID AS varchar) + ' WHERE ParentPTMCID = ' + @Dynamic_ID + 
        ' AND ParentTMCID = ' + CAST(@CurTmcID AS varchar) + ' AND PackedDate IS NOT NULL AND StorageStructureID = ' + CAST(@StorageStructureID AS Varchar)

    --@Query Поиск Общего заявленного кол-ва продукта входящего в Тару. 
    IF @CurCheckLink = 1 --связи есть, ручная упаковка неактивна, макс не работает - ищем по груп тейбл.    
        SELECT @Query = 'SELECT COUNT(a.ID) FROM ' + CHAR(13) + CHAR(10) +
                        '    (SELECT COUNT(ID) AS ID FROM [StorageData].G_' + CAST(@JobStageID AS varchar) + 
                        ' WHERE ' + @CurColName + ' = ' + @Dynamic_ID + 
                        ' GROUP BY ' + @NextColName + ') AS a'
    ELSE
    IF @CurCheckLink = 0 --связи нет, могут упаковать вручную, проверяется макс.
        IF @HandyClose = 1
        BEGIN
            SELECT 0 AS FreeCount
            RETURN;
        END
        ELSE
        IF @HandyClose = 0
            IF @CurMaxCount > 0 --Если задан МАКС - берем его в расчеты
                SELECT @Query = 'SELECT ' + CAST(@CurMaxCount AS Varchar)
            ELSE --иначе возвращаем сразу что можем паковать бесконечно
            BEGIN
                SELECT 1 AS FreeCount
                RETURN;
            END
 
    --попали сюда, значит проводим расчет по сгенереным кверям        
    EXEC ('SELECT CAST((' + @Query + ') - (' + @QueryP + ') as int) AS FreeCount')
--    SELECT @Query, @QueryP
END
GO