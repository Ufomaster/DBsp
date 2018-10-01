CREATE TABLE [sync].[1CDepartments] (
  [ID] [int] IDENTITY,
  [Date] [datetime] NOT NULL,
  [VisibleCode] [varchar](30) NULL,
  [Code1C] [varchar](36) NOT NULL,
  [ParentCode1C] [varchar](36) NULL,
  [Name] [varchar](100) NULL,
  [OperationType] [tinyint] NOT NULL,
  [ModifyName] [varchar](100) NULL,
  [ModifyDate] [datetime] NULL,
  CONSTRAINT [PK_Sync1CDepartments_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'sync.[1CDepartments].Date'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create TRIGGER [TR_Sync1CDepartments_INS] ON [sync].[1CDepartments]

FOR INSERT
AS
BEGIN
    /*RAISERROR('spekler error', 16, 1)*/
    /*SpeklerUser must impersonate Sync1C user*/
    EXECUTE AS USER = 'SpeklerUser'
    SET NOCOUNT ON
	/*SET XACT_ABORT ON*/
    DECLARE
        @UserCode1C varchar(30), 
        @Code1C Varchar(36), 
        @ParentCode1C Varchar(36),
        @Name Varchar(100), 
        @SyncID Int,
        @OperationType Int, 
        @Date datetime, 
        @NodeImageIndex int,
        @ID int,
        @ParentID int,
        @Level int,        
        @Catched bit,
        @StatusErrorText Varchar(MAX),
        @ModifyName varchar(100),
        @ModifyDate datetime

/*00000000-0000-0000-0000-000000000000 root*/

/*    INSERT INTO dbo.Sync1CNomenclatureLog(ModifyDate, Code1C, ParentCode1C, [Name], ShortName, [Type], OperationType, UnitName, UnitCode1C, [Status], StatusError, UserCode1C)
    SELECT ModifyDate, Code1C, ParentCode1C, [Name], ShortName, [Type], OperationType, UnitName, UnitCode1C, 
         CASE WHEN ISNULL(@StatusErrorText, '') = '' THEN 0 ELSE 1 END, @StatusErrorText, UserCode1C
    FROM INSERTED*/

    DECLARE #Cur CURSOR FOR SELECT ID, Code1C, [Date], ParentCode1C, [Name], OperationType, RTRIM(LTRIM(VisibleCode)), ModifyName, ModifyDate 
                            FROM INSERTED ORDER BY ID
    OPEN #Cur
    FETCH NEXT FROM #Cur INTO @SyncID, @Code1C, @Date, @ParentCode1C, @Name, @OperationType, @UserCode1C, @ModifyName, @ModifyDate
    WHILE @@FETCH_STATUS = 0
    BEGIN
        /*обнулить переменные .*/
        SELECT @Catched = 0, @NodeImageIndex = 33, @ParentID = NULL, @ID = NULL, @Level = NULL
        BEGIN TRY
/* SET @Err = 11/0*/
        /*ищем по коду 1с запись или по именованию, видимому коду 1с,*/
            SELECT TOP 1 @ID = ID FROM dbo.Departments WHERE Code1C = @Code1C;
            IF @ID IS NULL
                SELECT TOP 1 @ID = d.ID
                FROM dbo.Departments d
                WHERE d.Code1C IS NULL AND (d.UserCode1C = @UserCode1C OR UPPER(RTRIM(LTRIM(d.[Name]))) = UPPER(RTRIM(LTRIM(@Name))));

            /*в таблицу Синх не может быть из 1с добавлена запись с парентом, которого нет в 1с. поэтому смело ищем и если не находим - кидаем в корень(если не тип опер.3).*/
            SELECT TOP 1 @ParentID = ID, @Level = [Level] FROM dbo.Departments WHERE Code1C = @ParentCode1C;

            IF @ParentID IS NULL
                SELECT @Level = -1

            /*проверить, если удаление, удаляем, иначе игнорируем тип и пробуем искать.*/
            IF @OperationType = 2
            BEGIN
                /*ручками пытаемся удалить.*/
                /* поискать в связанных таблицах, если нету связи - можно удалить.*/
                IF NOT EXISTS(SELECT ID FROM dbo.SolutionsPlanned a WHERE a.DepartmentID = @ID) AND 
                   NOT EXISTS(SELECT ID FROM dbo.Departments c WHERE c.ParentID = @ID) AND
                   NOT EXISTS(SELECT ID FROM dbo.SolutionsDeclaredGroups a WHERE a.DepartmentID = @ID) AND                   
                   NOT EXISTS(SELECT dp.ID FROM dbo.DepartmentPositions dp
                              INNER JOIN dbo.Employees e ON e.DepartmentPositionID = dp.ID 
                              WHERE dp.DepartmentID = @ID)
                BEGIN
                    DELETE FROM dbo.DepartmentPositions WHERE DepartmentID = @ID
                    DELETE FROM dbo.Departments WHERE ID = @ID
                END
                ELSE
                BEGIN /*не можем удалить, прячем с глаз*/
                    UPDATE dbo.Departments
                    SET IsHidden = 1
                    WHERE (ID = @ID) OR ID IN (SELECT ID FROM dbo.fn_DepartmentsNode_Select(@ID))
                END
            END
            ELSE /* инсерт или модифай, тут уже пофиг - ищем и вставляем или апдейтим.*/
            BEGIN
                /*если не нашелся по коду 1С - вставка,*/
                IF @ID IS NULL
                BEGIN
                    INSERT INTO dbo.Departments([Name], NodeImageIndex, NodeState, ParentID, [Level], IsHidden, UserCode1C, Code1C)
                    SELECT @Name, @NodeImageIndex, 0, @ParentID, @Level + 1, 0, @UserCode1C, @Code1C
                END
                /*Инчае, 1- апейдим. 2- могло произойти перемещение*/
                ELSE
                BEGIN
                    /*вдруг поменялось что*/
                    UPDATE dbo.Departments
                    SET [Name] = @Name, IsHidden = 0, UserCode1C = @UserCode1C, 
                        Code1C = CASE WHEN Code1C IS NULL THEN @Code1C ELSE Code1C END, 
                        ParentID = @ParentID,
                        [Level] = @Level + 1
                    WHERE ID = @ID;

                    /*все дочерние ноды показываем если пришел апдейт или инсерт. Если было удаление ранее, дочек, то  тут лажа, так как они должны остаться удаленными*/
                    /*UPDATE dbo.Departments*/
                    /*SET IsHidden = 0*/
                    /*WHERE ID IN (SELECT ID FROM dbo.fn_DepartmentsNode_Select(@ID))*/
                END
            END

            END TRY
            BEGIN CATCH
                SET @Catched = 1
                SELECT @StatusErrorText = CAST(ERROR_NUMBER() AS Varchar(10)) + ': ' + ERROR_MESSAGE() + 
                                          ISNULL(' Procedure ' + ERROR_PROCEDURE() + ',', '') + 
                                          ' Line ' + CAST(ERROR_LINE() AS Varchar(10))
                                      + ', XACT_STATE ' + CAST(XACT_STATE() AS Varchar(10))
                                      + ', ERROR_SEVERITY ' + CAST(ERROR_SEVERITY() AS Varchar(10))
                                      + ', TRANCOUNT ' + CAST(@@TRANCOUNT as Varchar(10))
                IF (@@TRANCOUNT > 0) AND (ISNULL(@StatusErrorText, '') <> '')
                    ROLLBACK TRANSACTION;
            END CATCH
            /*логируем*/
            INSERT INTO sync.[1CDepartmentsLog](ID, [Date], Code1C, ParentCode1C, [Name], OperationType, [Status], StatusError, VisibleCode, ModifyName, ModifyDate)
            SELECT @SyncID, @Date, @Code1C, @ParentCode1C, @Name, @OperationType,  
                 CASE WHEN ISNULL(@StatusErrorText, '') = '' THEN 0 ELSE 1 END, @StatusErrorText, @UserCode1C, @ModifyName, @ModifyDate
            /*удаляем запись, фактически пометка что обработана запись.*/
            DELETE FROM sync.[1CDepartments] WHERE ID = @SyncID

            /*если была ошибка - райзим ошибку наверх*/
            IF @Catched = 1 AND (ISNULL(@StatusErrorText, '') <> '')
                RAISERROR(@StatusErrorText, 16, 1)

       FETCH NEXT FROM #Cur INTO @SyncID, @Code1C, @Date, @ParentCode1C, @Name, @OperationType, @UserCode1C, @ModifyName, @ModifyDate
    END
    CLOSE #Cur
    DEALLOCATE #Cur
END
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'sync', 'TABLE', N'1CDepartments', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата', 'SCHEMA', N'sync', 'TABLE', N'1CDepartments', 'COLUMN', N'Date'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Видимый пользователю код 1с', 'SCHEMA', N'sync', 'TABLE', N'1CDepartments', 'COLUMN', N'VisibleCode'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Уникальный идентификатор 1с', 'SCHEMA', N'sync', 'TABLE', N'1CDepartments', 'COLUMN', N'Code1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор родительской группы, которой подчинена запись', 'SCHEMA', N'sync', 'TABLE', N'1CDepartments', 'COLUMN', N'ParentCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Полное наименование', 'SCHEMA', N'sync', 'TABLE', N'1CDepartments', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип операции (0-Insert, 1-Update, 2-Delete)', 'SCHEMA', N'sync', 'TABLE', N'1CDepartments', 'COLUMN', N'OperationType'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Кто последний модифицировал', 'SCHEMA', N'sync', 'TABLE', N'1CDepartments', 'COLUMN', N'ModifyName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата посл. изменений в 1с', 'SCHEMA', N'sync', 'TABLE', N'1CDepartments', 'COLUMN', N'ModifyDate'
GO