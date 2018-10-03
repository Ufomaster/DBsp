CREATE ROLE [db_datareader] AUTHORIZATION [dbo]
GO

EXEC sp_addrolemember N'db_datareader', N'QlikView'
GO

EXEC sp_addrolemember N'db_datareader', N'SPEKL\ChepelN'
GO