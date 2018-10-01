CREATE TABLE [sync].[1CCustomersContacts] (
  [ID] [int] IDENTITY,
  [CustomerCode1C] [varchar](36) NULL,
  [Code1C] [varchar](36) NULL,
  [FullName] [varchar](255) NULL,
  [Position] [varchar](500) NULL,
  [IsDeleted] [bit] NULL,
  CONSTRAINT [PK_1CCustomersContacts_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create TRIGGER [TR_1CCustomersContacts_AFT_I] ON [sync].[1CCustomersContacts]

FOR INSERT
AS
BEGIN
    --RAISERROR('spekler error', 16, 1)
    --SpeklerUser must impersonate Sync1C user
    EXECUTE AS USER = 'SpeklerUser'
    SET NOCOUNT ON
    DECLARE @Err Int, @StatusErrorText varchar(8000), @CustomerID int, @ContactID int, @Catched bit
    DECLARE @ID int, @Code1C Varchar(36), @CustomerCode1C Varchar(36), @FullName Varchar(255), @Position varchar(500), @isDeleted bit

    DECLARE #Cur CURSOR FOR SELECT ID, CustomerCode1C, Code1C, RTRIM(LTRIM(FullName)), Position, IsDeleted
                            FROM INSERTED ORDER BY ID
    OPEN #Cur
    FETCH NEXT FROM #Cur INTO @ID, @CustomerCode1C, @Code1C, @FullName, @Position, @IsDeleted
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @ContactID = NULL
        SET @Catched = 0
        SELECT @CustomerID = c.ID
        FROM Customers c
        WHERE c.Code1C = @CustomerCode1C

        IF @CustomerID IS NULL 
            SELECT @StatusErrorText = ' @CustomerID не найден @CustomerCode1C=' + @CustomerCode1C
        ELSE		 
            IF @FullName = ''
            SELECT @StatusErrorText = ' @FullName пуст. @CustomerCode1C=' + @CustomerCode1C
        ELSE
        BEGIN
          --ищем по @Code1C
          SELECT TOP 1 @ContactID = cc.ID FROM CustomerContacts cc WHERE cc.Code1C = @Code1C;
          IF @ContactID IS NULL
               SELECT TOP 1 @ContactID = cc.ID FROM CustomerContacts cc WHERE cc.Name = @FullName;
          BEGIN TRY
             IF @ContactID IS NULL
                  --вставка, так как не найден.
                  INSERT INTO CustomerContacts(Code1C, [Name], Position, Deleted, CustomerID)
                  SELECT @Code1C, @FullName, @Position, @IsDeleted, @CustomerID
              ELSE
                  UPDATE a
                  SET
                      a.[Name] = @FullName,
                      a.Position = @Position,
                      a.Deleted = @IsDeleted
                  FROM CustomerContacts a
                  WHERE a.ID = @CustomerID
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
        END            
            
        --логируем
        INSERT INTO sync.[1CCustomersContactsLog](ModifyDate, Code1C, FullName, Position, isDeleted, ErrorText, CustomerID, CustomerCode1C) 
            SELECT GetDate(), @Code1C, @FullName, @Position, @isDeleted, @StatusErrorText, @CustomerID, @CustomerCode1C
        --удаляем запись, фактически пометка что обработана запись.
        DELETE FROM sync.[1CCustomersContacts] WHERE ID = @ID

        --если была ошибка - райзим ошибку наверх
        IF @Catched = 1 AND (ISNULL(@StatusErrorText, '') <> '')
            RAISERROR(@StatusErrorText, 16, 1)
       FETCH NEXT FROM #Cur INTO @ID, @CustomerCode1C, @Code1C, @FullName, @Position, @IsDeleted
    END
    CLOSE #Cur
    DEALLOCATE #Cur
END
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'sync', 'TABLE', N'1CCustomersContacts', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код контрагента 1с', 'SCHEMA', N'sync', 'TABLE', N'1CCustomersContacts', 'COLUMN', N'CustomerCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код 1с', 'SCHEMA', N'sync', 'TABLE', N'1CCustomersContacts', 'COLUMN', N'Code1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'ФИО', 'SCHEMA', N'sync', 'TABLE', N'1CCustomersContacts', 'COLUMN', N'FullName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Должность', 'SCHEMA', N'sync', 'TABLE', N'1CCustomersContacts', 'COLUMN', N'Position'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Фалг удалённости', 'SCHEMA', N'sync', 'TABLE', N'1CCustomersContacts', 'COLUMN', N'IsDeleted'
GO