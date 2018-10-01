CREATE TABLE [sync].[1CEmployees] (
  [ID] [int] IDENTITY,
  [Date] [datetime] NOT NULL,
  [VisibleCode] [varchar](30) NULL,
  [Code1C] [varchar](36) NOT NULL,
  [Name] [varchar](100) NULL,
  [OperationType] [tinyint] NOT NULL,
  [isActive] [bit] NULL,
  [ContractType] [varchar](50) NULL,
  [FCode1C] [varchar](36) NULL,
  [ModifyName] [varchar](100) NULL,
  [ModifyDate] [datetime] NULL,
  [Department1Code1C] [varchar](36) NULL,
  [Department1Name] [varchar](150) NULL,
  [Position1Code1C] [varchar](36) NULL,
  [Department2Code1C] [varchar](36) NULL,
  [Department2Name] [varchar](150) NULL,
  [Position2Code1C] [varchar](36) NULL,
  [RecDate2] [datetime] NULL,
  [DisDate2] [datetime] NULL,
  [Department3Code1C] [varchar](36) NULL,
  [Position3Code1C] [varchar](36) NULL,
  [RecDate3] [datetime] NULL,
  [DisDate3] [datetime] NULL,
  [WorkType] [varchar](51) NULL,
  CONSTRAINT [PK_Sync1CEmployees_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'sync.[1CEmployees].Date'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [TR_Sync1CEmployees_INS] ON [sync].[1CEmployees]
WITH EXECUTE AS CALLER
FOR INSERT
AS
--$Create:     Oleynik Yuiriy$    $Create date:   17.08.2015$
--$Modify:     Oleynik Yuiriy$    $Modify date:   17.08.2015$
--$Version:    1.00$   $Description: триггер основного процесса синхронизации$
BEGIN
    /*RAISERROR('spekler error', 16, 1)*/
    /*SpeklerUser must impersonate Sync1C user*/
    EXECUTE AS USER = 'SpeklerUser'
    SET NOCOUNT ON
	/*SET XACT_ABORT ON*/
    DECLARE
        @UserCode1C varchar(50), 
        @Code1C Varchar(36), 
        @Name Varchar(100), 
        @SyncID Int,
        @OperationType Int, 
        @Date datetime, 
        @ID int,
        @ContractType varchar(50),
        @isActive bit,
        @isDismissed bit,        
        @FCode1C varchar(36),
        @ModifyName varchar(100),
        @ModifyDate datetime,
        @Department3Code1C varchar(36),
        @Position3Code1C varchar(36),
        @RecDate3 datetime,
        @DisDate3 datetime,    
        @INN varchar(16),
        @1CEmployeesMirrorID int,
        @Catched bit,
        @StatusErrorText Varchar(MAX),
        @DepartmentID int,
        @PositionID int,
        @DepartmentPositionID int,
        @OldDepartmentPositionID int
        
    DECLARE @t TABLE(ID int)

/*    INSERT INTO dbo.Sync1CNomenclatureLog(ModifyDate, Code1C, ParentCode1C, [Name], ShortName, [Type], OperationType, UnitName, UnitCode1C, [Status], StatusError, UserCode1C)
    SELECT ModifyDate, Code1C, ParentCode1C, [Name], ShortName, [Type], OperationType, UnitName, UnitCode1C, 
         CASE WHEN ISNULL(@StatusErrorText, '') = '' THEN 0 ELSE 1 END, @StatusErrorText, UserCode1C
    FROM INSERTED*/

    DECLARE #Cur CURSOR FOR SELECT e.ID, e.Code1C, e.[Date],  RTRIM(LTRIM(e.[Name])), e.OperationType, e.FCode1C, 
                                   RTRIM(LTRIM(e.VisibleCode)), ISNULL(RTRIM(LTRIM(fe.INN)), '')
                            FROM INSERTED e
                            INNER JOIN sync.[1CFysEmployees] fe ON fe.Code1C = e.FCode1C
                            ORDER BY ID
    OPEN #Cur
    FETCH NEXT FROM #Cur INTO @SyncID, @Code1C, @Date, @Name, @OperationType, @FCode1C, @UserCode1C, @INN
    WHILE @@FETCH_STATUS = 0
    BEGIN
        /*обнулить переменные .*/
-------------------------------------------заполнение таблицы 1CEmployeesMirror
            SELECT @ID = NULL
            /*ищем по коду 1с запись */
            SELECT TOP 1 @ID = e.ID FROM sync.[1CEmployeesMirror] e WHERE e.Code1C = @Code1C AND e.VisibleCode = @UserCode1C;
            /* если не нашли, ищем по ИНН */
            IF @ID IS NULL
                SELECT TOP 1 @ID = e.ID
                FROM sync.[1CEmployeesMirror] e
                INNER JOIN sync.[1CFysEmployees] fe ON fe.Code1C = e.FCode1C
                WHERE fe.INN = @INN AND @INN <> '' AND e.VisibleCode = @UserCode1C
            ELSE
            /* если не нашли и по ИНН, ищем по FIO */
            IF @ID IS NULL
                SELECT TOP 1 @ID = e.ID
                FROM sync.[1CEmployeesMirror] e
                INNER JOIN sync.[1CFysEmployees] fe ON fe.Code1C = e.FCode1C
                WHERE fe.[Name] = @Name AND e.VisibleCode = @UserCode1C
                
            /* если не нашли ничего - INSERT */
            IF @ID IS NULL
                INSERT INTO sync.[1CEmployeesMirror]([Date], VisibleCode, Code1C, [Name], OperationType, isActive, ContractType, FCode1C, ModifyName, ModifyDate, Department1Code1C, Department1Name,
                    Position1Code1C, Department2Code1C, Department2Name, Position2Code1C, RecDate2, DisDate2, Department3Code1C, Position3Code1C, RecDate3, DisDate3, WorkType)
                SELECT [Date], RTRIM(LTRIM(VisibleCode)), Code1C, RTRIM(LTRIM([Name])), OperationType, isActive, ContractType, FCode1C, ModifyName, ModifyDate, Department1Code1C, Department1Name,
                    Position1Code1C, Department2Code1C, Department2Name, Position2Code1C, RecDate2, DisDate2, Department3Code1C, Position3Code1C, RecDate3, DisDate3, WorkType
                FROM INSERTED
                WHERE ID = @SyncID
            ELSE
                /* если нашли - UPDATE */
                UPDATE a
                SET a.[Date] = e.[Date], 
                    a.VisibleCode = e.VisibleCode, 
                    a.Code1C = e.Code1C, 
                    a.[Name] = e.[Name], 
                    a.OperationType = e.OperationType, 
                    a.isActive = e.isActive, 
                    a.ContractType = e.ContractType, 
                    a.FCode1C = e.FCode1C, 
                    a.ModifyName = e.ModifyName, 
                    a.ModifyDate = e.ModifyDate, 
                    a.Department1Code1C = e.Department1Code1C, 
                    a.Department1Name = e.Department1Name,
                    a.Position1Code1C = e.Position1Code1C, 
                    a.Department2Code1C = e.Department2Code1C, 
                    a.Department2Name = e.Department2Name, 
                    a.Position2Code1C = e.Position2Code1C, 
                    a.RecDate2 = e.RecDate2, 
                    a.DisDate2 = e.DisDate2, 
                    a.Department3Code1C = e.Department3Code1C, 
                    a.Position3Code1C = e.Position3Code1C, 
                    a.RecDate3 = e.RecDate3, 
                    a.DisDate3 = e.DisDate3,
                    a.WorkType = e.WorkType
                FROM sync.[1CEmployeesMirror] a
                INNER JOIN sync.[1CEmployees] e ON e.ID = @SyncID
                WHERE a.ID = @ID
            
-------------------------------------------анализ таблицы 1CEmployeesMirror для заполнения Employees

        SELECT @Catched = 0, @ID = NULL, @StatusErrorText = NULL, @OldDepartmentPositionID = NULL, @DepartmentPositionID = NULL
        DELETE FROM @t
        BEGIN TRY
            /*ищем по ИНН коду*/
            IF @INN <> ''
                SELECT TOP 1 @ID = e.ID 
                FROM dbo.Employees e 
                WHERE e.INN = @INN
            
            /* не нашли - ищем по коду физлица 1с*/
            IF @ID IS NULL
                SELECT TOP 1 @ID = e.ID 
                FROM dbo.Employees e 
                WHERE e.Code1C = @FCode1C
            ELSE            
            /* не нашли - это или новый или глюкавый, ищем по имени среди тех у кого нет ИНН или кода физлица */
            IF @ID IS NULL
                SELECT TOP 1 @ID = e.ID
                FROM dbo.Employees e
                WHERE e.FullName = @Name AND e.Code1C IS NULL --AND ISNULL(e.INN, '') = ''
                
    
/*INSERT INTO [sync].[1cTemp] ([ID], [Name],[IsDismissed],[txt])
SELECT @ID, @Name, Null, 'Emplo search @ID ='  + 
    CAST(ISNULL(@ID, -1) AS varchar(10)) + ' -----' + @Name + '   ' + @FCode1C + '     ' + @INN*/
            
/*------анализируем чем увенчался поиск-------*/
            -- в @ID уже будет ID из Employees а не 1CEmployeesMirror.
            /*проверить, если удаление, прячем без проверок так как маловероятно что сотрудник нигде не использовался, а таблиц для проверок очень и очень много.*/
            IF @OperationType = 2
            BEGIN
                UPDATE DepartmentPositions
                SET isHidden = 0
                WHERE ID = (SELECT DepartmentPositionID FROM Employees WHERE ID = @ID)

                UPDATE dbo.Employees
                SET IsHidden = 1, DepartmentPositionID = NULL, IsDismissed = 1 /*увольняем его сразу*/
                WHERE ID = @ID
                --в случае @ID = null ничего не будет с этим сотрудником проделано.
            END
            ELSE /* инсерт или модифай, тут уже пофиг - вставляем или апдейтим то что нашли.*/
            BEGIN
                /*если не нашелся - вставка*/
                IF @ID IS NULL
                BEGIN
                    INSERT INTO dbo.Employees(FullName, IsHidden, UserCode1C, Code1C, ContractType, INN, IsDismissed)
                    OUTPUT INSERTED.ID INTO @t
                    SELECT @Name, 0, @UserCode1C, @FCode1C, @ContractType, @INN, 1
                    SELECT @ID = ID FROM @t
                    DELETE FROM @t
                    --тут просто вставили. дале нужно по анализу дат проапдейтить работает ли он и где.
                END
                /*Инчае, 1- апейдим. 2- могло произойти перемещение*/
                ELSE
                BEGIN
                    /*запомнили старую должность. нужно чтобы переместить оборудование*/
                    SELECT @OldDepartmentPositionID = e.DepartmentPositionID 
                    FROM Employees e WHERE e.ID = @ID
                    /*вдруг поменялось что*/
                    UPDATE dbo.Employees
                    SET FullName = @Name, UserCode1C = @UserCode1C, 
                        Code1C = @FCode1C, ContractType = @ContractType, INN = @INN, IsDismissed = CASE WHEN DepartmentPositionID IS NULL THEN 1 ELSE 0 END
                        /*снимаем с должности, если его уволили или не назначен по каким-то причинам.*/
/*                        DepartmentPositionID = CASE WHEN (@isDismissed = 1) OR (@DepartmentCode1C = '00000000-0000-0000-0000-000000000000')
                                                                            OR (@PositionCode1C   = '00000000-0000-0000-0000-000000000000') THEN NULL
                                               ELSE DepartmentPositionID
                                               END*/
                    WHERE ID = @ID;
                END
            END

/*----------Назначение на должность.*/
/*----------Используем анализ дат */
            SELECT 
                @1CEmployeesMirrorID = MAX(CASE WHEN (m.DisDate3 IS NULL OR m.RecDate3 > m.DisDate3) AND (m.RecDate3 IS NOT NULL) THEN m.ID ELSE NULL END),
                @isDismissed =         MAX(CASE WHEN (m.DisDate3 IS NULL OR m.RecDate3 > m.DisDate3) AND (m.RecDate3 IS NOT NULL) THEN 1    ELSE 0 END)
            FROM sync.[1CEmployeesMirror] m
            INNER JOIN sync.[1CFysEmployees] fe ON m.[Name] = fe.[Name] AND (fe.INN = @INN OR m.[Name] = @Name)
            GROUP BY m.[Name]
            HAVING MAX(CASE WHEN (m.DisDate3 IS NULL OR m.RecDate3 > m.DisDate3) AND (m.RecDate3 IS NOT NULL) THEN 1 ELSE 0 END) = 1
    
            IF @1CEmployeesMirrorID IS NOT NULL
                SELECT               
                    @Department3Code1C = e.Department3Code1C,
                    @Position3Code1C = e.Position3Code1C
                FROM sync.[1CEmployeesMirror] e
                INNER JOIN sync.[1CFysEmployees] fe ON e.FCode1C = fe.Code1C AND (fe.INN = @INN OR e.FCode1C = @FCode1C)
                WHERE e.ID = @1CEmployeesMirrorID

            SELECT @isDismissed = CASE WHEN ISNULL(@isDismissed, 0) = 1 AND 
                                            ISNULL(@Department3Code1C, '00000000-0000-0000-0000-000000000000') <> '00000000-0000-0000-0000-000000000000' AND 
                                            ISNULL(@Position3Code1C, '00000000-0000-0000-0000-000000000000') <> '00000000-0000-0000-0000-000000000000' THEN 0
                                  ELSE 1 END                                 

            /*берем только свободную вакансию, включая ту на которую уже может быть назначен сам сотрудник*/

            SELECT TOP 1 @DepartmentPositionID = dp.ID
            FROM vw_DepartmentPositions dp
            WHERE dp.DepartmentCode1C = @Department3Code1C AND dp.PositionCode1C = @Position3Code1C
              AND dp.ID NOT IN (SELECT DepartmentPositionID FROM Employees WHERE DepartmentPositionID IS NOT NULL AND ID <> @ID)

            SELECT @DepartmentID = ID FROM Departments WHERE Code1C = @Department3Code1C
            SELECT @PositionID = ID FROM Positions WHERE Code1C = @Position3Code1C

            /*вакансии нет. ВСЕГДА вставка, если не удаление*/
            IF (@OperationType <> 2) AND (@DepartmentPositionID IS NULL) AND (@isDismissed = 0)
            BEGIN
                INSERT INTO DepartmentPositions(DepartmentID, PositionID, isHidden)
                OUTPUT INSERTED.ID INTO @t
                VALUES(@DepartmentID, @PositionID, 0)
                SELECT @DepartmentPositionID = ID FROM @t                    
            END
            ELSE
            BEGIN
                UPDATE DepartmentPositions
                SET isHidden = 0
                WHERE ID = @DepartmentPositionID 
            END

            /*IF @OperationType = 2 -- для удаления ничего не делаем, все сделали ранее. вакансии не удаляем.*/
            IF (@OperationType = 1) OR (@OperationType = 0) /* при модифае,инсертe */
            BEGIN
                UPDATE e
                SET 
                   e.DepartmentPositionID = CASE WHEN @isDismissed = 1 THEN NULL ELSE @DepartmentPositionID END, 
                   e.IsDismissed = @isDismissed,
                   e.IsHidden = 0
                FROM dbo.Employees e
                WHERE e.ID = @ID              
            END
            

            /* перемещаем оборудование, меняем ссылки на вакансии*/
            IF (@OldDepartmentPositionID IS NOT NULL) AND (@DepartmentPositionID IS NOT NULL) AND (@OldDepartmentPositionID <> @DepartmentPositionID)
            BEGIN
                UPDATE e
                SET e.DepartmentPositionID = @DepartmentPositionID
                FROM Equipment e
                WHERE e.DepartmentPositionID = @OldDepartmentPositionID

                UPDATE e
                SET e.DepartmentPositionID = @DepartmentPositionID
                FROM ProductionCardAdaptingEmployees e
                WHERE e.DepartmentPositionID = @OldDepartmentPositionID

                UPDATE e
                SET e.DepartmentPositionID = @DepartmentPositionID
                FROM NotifyEventsEmployees e
                WHERE e.DepartmentPositionID = @OldDepartmentPositionID

                UPDATE e
                SET e.DepartmentPositionID = @DepartmentPositionID
                FROM ProductionCardProcessMapNEEmployees e
                WHERE e.DepartmentPositionID = @OldDepartmentPositionID
            END
        END TRY
        BEGIN CATCH
            SET @Catched = 1
            SELECT @StatusErrorText = CAST(ERROR_NUMBER() AS Varchar(10)) + ': ' + ERROR_MESSAGE() + 
                                      ' Line ' + CAST(ERROR_LINE() AS Varchar(10))
                                  + ', XACT_STATE ' + CAST(XACT_STATE() AS Varchar(10))
                                  + ', ERROR_SEVERITY ' + CAST(ERROR_SEVERITY() AS Varchar(10))
                                  + ', TRANCOUNT ' + CAST(@@TRANCOUNT as Varchar(10))
            IF (@@TRANCOUNT > 0) AND (ISNULL(@StatusErrorText, '') <> '')
                ROLLBACK TRANSACTION;
        END CATCH

        /*логируем*/
        INSERT INTO sync.[1CEmployeesLog](ID, [Date], Code1C, [Name], OperationType, isActive,
             ContractType, [Status], StatusError, VisibleCode, 
             FCode1C, ModifyName, ModifyDate, Department1Code1C, Department1Name,
             Position1Code1C, Department2Code1C, Department2Name, Position2Code1C, 
             RecDate2, DisDate2, Department3Code1C, Position3Code1C, RecDate3, 
             DisDate3, WorkType)
         SELECT @SyncID, [Date], Code1C, [Name], OperationType, isActive,
             ContractType, CASE WHEN ISNULL(@StatusErrorText, '') = '' THEN 0 ELSE 1 END, @StatusErrorText, VisibleCode, FCode1C, ModifyName, ModifyDate, Department1Code1C, Department1Name,
            Position1Code1C, Department2Code1C, Department2Name, Position2Code1C, RecDate2, DisDate2, Department3Code1C, Position3Code1C, RecDate3, DisDate3, WorkType
         FROM INSERTED 
         WHERE ID = @SyncID

        /*удаляем запись, фактически пометка что обработана запись.*/
        DELETE FROM sync.[1CEmployees] WHERE ID = @SyncID

        /*если была ошибка - райзим ошибку наверх*/
        IF @Catched = 1 AND (ISNULL(@StatusErrorText, '') <> '')
            RAISERROR(@StatusErrorText, 16, 1)

       FETCH NEXT FROM #Cur INTO @SyncID, @Code1C, @Date, @Name, @OperationType,/*@ContractType, @isActive, */  @FCode1C,  @UserCode1C,/*
      @ModifyName, @ModifyDate, @Department1Code1C, @Department1Name, @Position1Code1C, @Department2Code1C, @Department2Name, @Position2Code1C,
      @RecDate2, @DisDate2, @Department3Code1C, @Position3Code1C, @RecDate3, @DisDate3,*/ @INN
    END
    CLOSE #Cur
    DEALLOCATE #Cur
END
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'sync', 'TABLE', N'1CEmployees', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания', 'SCHEMA', N'sync', 'TABLE', N'1CEmployees', 'COLUMN', N'Date'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Видимый пользователю код 1с', 'SCHEMA', N'sync', 'TABLE', N'1CEmployees', 'COLUMN', N'VisibleCode'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Уникальный идентификатор 1с', 'SCHEMA', N'sync', 'TABLE', N'1CEmployees', 'COLUMN', N'Code1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Полное наименование', 'SCHEMA', N'sync', 'TABLE', N'1CEmployees', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип операции (0-Insert, 1-Update, 2-Delete)', 'SCHEMA', N'sync', 'TABLE', N'1CEmployees', 'COLUMN', N'OperationType'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'1 – активен, 0 – не активен', 'SCHEMA', N'sync', 'TABLE', N'1CEmployees', 'COLUMN', N'isActive'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'«ТрудовойДоговор», «Подряда»,  «Авторский», «ДоговорУправленческий
', 'SCHEMA', N'sync', 'TABLE', N'1CEmployees', 'COLUMN', N'ContractType'
GO