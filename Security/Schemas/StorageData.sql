CREATE SCHEMA [StorageData] AUTHORIZATION [dbo]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Схема для хранения динамических таблиц склада', 'SCHEMA', N'StorageData'
GO