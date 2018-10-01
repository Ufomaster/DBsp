SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [manufacture].[vw_1CTechCards_States]
AS
  SELECT 1 AS ID, 'Подготовлен' AS Name
  UNION
  SELECT 2, 'Утвержден'
  UNION 
  SELECT 3, 'Отложен'
  UNION 
  SELECT 4, 'Отклонен'
  UNION 
  SELECT 5, 'Согласован'
GO