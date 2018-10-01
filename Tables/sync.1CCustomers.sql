CREATE TABLE [sync].[1CCustomers] (
  [ID] [int] IDENTITY,
  [ModifyDate] [datetime] NOT NULL,
  [Code1C] [varchar](36) NOT NULL,
  [FullName] [varchar](600) NULL,
  [EDRPOU] [varchar](30) NULL,
  [TIN] [varchar](30) NULL,
  [isDeleted] [bit] NULL,
  [isClient] [bit] NULL,
  [isSupplier] [bit] NULL,
  [isFolder] [bit] NULL,
  [ParentCode1C] [varchar](36) NULL,
  PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'sync.[1CCustomers].ModifyDate'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [TR_1CCustomers_AFT_I] ON [sync].[1CCustomers]
WITH EXECUTE AS CALLER
FOR INSERT, UPDATE
AS
BEGIN
    --RAISERROR('spekler error', 16, 1)
    --SpeklerUser must impersonate Sync1C user
    EXECUTE AS USER = 'SpeklerUser'
    SET NOCOUNT ON
    DECLARE @Err Int, @StatusErrorText varchar(8000), @CustomerID int, @ParentID int, @Catched bit
    DECLARE @ID int, @Code1C Varchar(36), @ParentCode1C Varchar(36), @FullName Varchar(255), @EDRPOU varchar(30), @TIN varchar(30),
      @isDeleted bit, @isClient bit, @isSupplier bit, @isFolder bit
    --00000000-0000-0000-0000-000000000000 код группы нашего рут уровня. нул короче.
    DECLARE #Cur CURSOR FOR SELECT ID, Code1C, CASE WHEN ParentCode1C = '00000000-0000-0000-0000-000000000000' THEN NULL ELSE ParentCode1C END,
                                FullName, RTRIM(LTRIM(EDRPOU)), RTRIM(LTRIM(TIN)), isDeleted, isClient, isSupplier, isFolder 
                            FROM INSERTED ORDER BY ID
    OPEN #Cur
    FETCH NEXT FROM #Cur INTO @ID, @Code1C, @ParentCode1C, @FullName, @EDRPOU, @TIN, @isDeleted, @isClient, @isSupplier, @isFolder
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT @ParentID = c.ID, @Catched = 0
        FROM Customers c WHERE c.Code1C = @ParentCode1C
        --ищем по @Code1C
        SELECT TOP 1 @CustomerID = c.ID FROM Customers c WHERE c.Code1C = @Code1C;
        IF @CustomerID IS NULL AND ISNULL(@EDRPOU, '') <> ''
           --ищем по @EDRPOU
           SELECT TOP 1 @CustomerID = c.ID FROM Customers c WHERE c.EDRPOU = @EDRPOU;
        IF @CustomerID IS NULL AND ISNULL(@TIN, '') <> ''
           --ищем по @TIN
           SELECT TOP 1 @CustomerID = c.ID FROM Customers c WHERE c.TaxCode = @TIN;
        IF @CustomerID IS NULL AND ISNULL(@TIN, '') = '' AND ISNULL(@EDRPOU, '') = ''
           --ищем по @FullName
           SELECT TOP 1 @CustomerID = c.ID FROM Customers c WHERE c.Name = @FullName;
        BEGIN TRY           
            IF @CustomerID IS NULL
            --вставка, так как не найден.        
                INSERT INTO Customers(Code1C, [Name], TaxCode, EDRPOU, CreateDate, Deleted, isClient, isSupplier, isFolder, ParentID)
                SELECT @Code1C, @FullName, @TIN, @EDRPOU, GetDate(), @isDeleted, @isClient, @isSupplier, @isFolder, @ParentID
            ELSE
                UPDATE a
                SET
                    a.Code1C = @Code1C,
                    a.[Name] = @FullName,
                    a.TaxCode = @TIN,
                    a.EDRPOU = @EDRPOU,
                    a.Deleted = @isDeleted,
                    a.isClient = @isClient,
                    a.isSupplier = @isSupplier,
                    a.isFolder = @isFolder,
                    a.ParentID = @ParentID
                FROM Customers a
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
        --логируем
        INSERT INTO sync.[1CCustomersLog](ModifyDate, Code1C, FullName, EDRPOU, TIN, isDeleted, isClient, isSupplier, isFolder, ParentCode1C, ErrorText, CustomerID) 
            SELECT GetDate(), @Code1C, @FullName, @EDRPOU, @TIN, @isDeleted, @isClient, @isSupplier, @isFolder, @ParentCode1C, @StatusErrorText, @CustomerID
        --удаляем запись, фактически пометка что обработана запись.
        DELETE FROM sync.[1CCustomers] WHERE ID = @ID

        --если была ошибка - райзим ошибку наверх
        IF @Catched = 1 AND (ISNULL(@StatusErrorText, '') <> '')
            RAISERROR(@StatusErrorText, 16, 1)
       FETCH NEXT FROM #Cur INTO @ID, @Code1C, @ParentCode1C, @FullName, @EDRPOU, @TIN, @isDeleted, @isClient, @isSupplier, @isFolder
    END
    CLOSE #Cur
    DEALLOCATE #Cur
END
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'sync', 'TABLE', N'1CCustomers', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата изменений', 'SCHEMA', N'sync', 'TABLE', N'1CCustomers', 'COLUMN', N'ModifyDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Гуид 1с', 'SCHEMA', N'sync', 'TABLE', N'1CCustomers', 'COLUMN', N'Code1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'sync', 'TABLE', N'1CCustomers', 'COLUMN', N'FullName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'ЕДРПОУ', 'SCHEMA', N'sync', 'TABLE', N'1CCustomers', 'COLUMN', N'EDRPOU'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'ИНН', 'SCHEMA', N'sync', 'TABLE', N'1CCustomers', 'COLUMN', N'TIN'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'флаг Удален', 'SCHEMA', N'sync', 'TABLE', N'1CCustomers', 'COLUMN', N'isDeleted'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'флаг клиент', 'SCHEMA', N'sync', 'TABLE', N'1CCustomers', 'COLUMN', N'isClient'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'флаг поставщик', 'SCHEMA', N'sync', 'TABLE', N'1CCustomers', 'COLUMN', N'isSupplier'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'флаг папки', 'SCHEMA', N'sync', 'TABLE', N'1CCustomers', 'COLUMN', N'isFolder'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Гуид родительской папки', 'SCHEMA', N'sync', 'TABLE', N'1CCustomers', 'COLUMN', N'ParentCode1C'
GO