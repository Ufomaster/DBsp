CREATE TABLE [sync].[1CPositions] (
  [ID] [int] IDENTITY,
  [Date] [datetime] NOT NULL,
  [VisibleCode] [varchar](30) NULL,
  [Code1C] [varchar](36) NOT NULL,
  [Name] [varchar](100) NULL,
  [OperationType] [tinyint] NOT NULL,
  [ModifyName] [varchar](100) NULL,
  [ModifyDate] [datetime] NULL,
  CONSTRAINT [PK_Sync1CPositions_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'sync.[1CPositions].Date'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create TRIGGER [TR_Sync1CPositions_INS] ON [sync].[1CPositions]

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
        @Name Varchar(100), 
        @SyncID Int,
        @OperationType Int, 
        @Date datetime, 
        @ID int,     
        @Catched bit,
        @StatusErrorText Varchar(MAX),
        @ModifyName varchar(100),
        @ModifyDate datetime
        

    DECLARE #Cur CURSOR FOR SELECT ID, Code1C, [Date], [Name], OperationType, RTRIM(LTRIM(VisibleCode)), ModifyName, ModifyDate FROM INSERTED ORDER BY ID
    OPEN #Cur
    FETCH NEXT FROM #Cur INTO @SyncID, @Code1C, @Date, @Name, @OperationType, @UserCode1C, @ModifyName, @ModifyDate 
    WHILE @@FETCH_STATUS = 0
    BEGIN
        /*обнулить переменные .*/
        SELECT @Catched = 0 , @ID = NULL
        BEGIN TRY
/* SET @Err = 11/0*/
        /*ищем по коду 1с запись или по именованию, видимому коду 1с,*/
            SELECT TOP 1 @ID = ID FROM dbo.Positions WHERE Code1C = @Code1C;
            IF @ID IS NULL
                SELECT TOP 1 @ID = d.ID
                FROM dbo.Positions d
                WHERE d.Code1C IS NULL AND (d.UserCode1C = @UserCode1C OR UPPER(RTRIM(LTRIM(d.[Name]))) = UPPER(RTRIM(LTRIM(@Name))));

            /*проверить, если удаление, удаляем, иначе игнорируем тип и пробуем искать.*/
            IF @OperationType = 2
            BEGIN
                /*ручками пытаемся удалить.*/
                /* поискать в связанных таблицах, если нету связи - можно удалить.*/
                IF NOT EXISTS(SELECT dp.ID FROM dbo.DepartmentPositions dp
                              INNER JOIN dbo.Employees e ON e.DepartmentPositionID = dp.ID 
                              WHERE dp.PositionID = @ID)
                BEGIN
                    DELETE FROM dbo.DepartmentPositions WHERE PositionID = @ID
                    DELETE FROM dbo.Positions WHERE ID = @ID
                END
                ELSE
                BEGIN /*не можем удалить, прячем с глаз*/
                    UPDATE dbo.Positions
                    SET IsHidden = 1
                    WHERE ID = @ID
                END
            END
            ELSE /* инсерт или модифай, тут уже пофиг - ищем и вставляем или апдейтим.*/
            BEGIN
                /*если не нашелся по коду 1С - вставка,*/
                IF @ID IS NULL
                BEGIN
                    INSERT INTO dbo.Positions([Name], IsHidden, UserCode1C, Code1C)
                    SELECT @Name, 0, @UserCode1C, @Code1C
                END
                /*Инчае, 1- апейдим. 2- могло произойти перемещение*/
                ELSE
                BEGIN
                    /*вдруг поменялось что*/
                    UPDATE dbo.Positions
                    SET [Name] = @Name, IsHidden = 0, UserCode1C = @UserCode1C, 
                        Code1C = CASE WHEN Code1C IS NULL THEN @Code1C ELSE Code1C END
                    WHERE ID = @ID;
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
            INSERT INTO sync.[1CPositionsLog](ID, [Date], Code1C, [Name], OperationType, [Status], StatusError, VisibleCode, ModifyName, ModifyDate)
            SELECT @SyncID, @Date, @Code1C, @Name, @OperationType,  
                 CASE WHEN ISNULL(@StatusErrorText, '') = '' THEN 0 ELSE 1 END, @StatusErrorText, @UserCode1C, @ModifyName, @ModifyDate
            /*удаляем запись, фактически пометка что обработана запись.*/
            DELETE FROM sync.[1CPositions] WHERE ID = @SyncID

            /*если была ошибка - райзим ошибку наверх*/
            IF @Catched = 1 AND (ISNULL(@StatusErrorText, '') <> '')
                RAISERROR(@StatusErrorText, 16, 1)

       FETCH NEXT FROM #Cur INTO @SyncID, @Code1C, @Date, @Name, @OperationType, @UserCode1C, @ModifyName, @ModifyDate 
    END
    CLOSE #Cur
    DEALLOCATE #Cur
END
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'sync', 'TABLE', N'1CPositions', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата', 'SCHEMA', N'sync', 'TABLE', N'1CPositions', 'COLUMN', N'Date'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Видимый пользователю код 1с', 'SCHEMA', N'sync', 'TABLE', N'1CPositions', 'COLUMN', N'VisibleCode'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Уникальный идентификатор 1с', 'SCHEMA', N'sync', 'TABLE', N'1CPositions', 'COLUMN', N'Code1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Полное наименование', 'SCHEMA', N'sync', 'TABLE', N'1CPositions', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип операции (0-Insert, 1-Update, 2-Delete)', 'SCHEMA', N'sync', 'TABLE', N'1CPositions', 'COLUMN', N'OperationType'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Кто модицифировал запись', 'SCHEMA', N'sync', 'TABLE', N'1CPositions', 'COLUMN', N'ModifyName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата изменений записи в 1с', 'SCHEMA', N'sync', 'TABLE', N'1CPositions', 'COLUMN', N'ModifyDate'
GO