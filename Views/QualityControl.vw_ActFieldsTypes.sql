SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [QualityControl].[vw_ActFieldsTypes]
AS
   SELECT 0 AS ID, 'произвольный текст' AS [Name]
/*   UNION
   SELECT 1, 'справочник решений'
   UNION
   SELECT 2, 'справочник причин'
   UNION
   SELECT 3, 'дата подписи'*/
GO