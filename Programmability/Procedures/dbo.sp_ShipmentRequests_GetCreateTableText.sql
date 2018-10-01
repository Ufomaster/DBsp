SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   03.12.2015$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   10.02.2016$*/
/*$Version:    1.00$   $Description: Возвращает текст создания темповой таблицы $*/
CREATE PROCEDURE [dbo].[sp_ShipmentRequests_GetCreateTableText]
AS
BEGIN
    SELECT 'IF OBJECT_ID(''tempdb..#ShipmentRequestsDetails'') IS NOT NULL ' +
         '    TRUNCATE TABLE #ShipmentRequestsDetails ELSE ' +
         '    CREATE TABLE #ShipmentRequestsDetails(ID int IDENTITY(1, 1) NOT NULL, _ID int, ' +
         '    Comments varchar(255), [Name] varchar(255), Amount decimal(24, 4), ZLNumber varchar(15), ' +
         '    Height smallint, Length smallint, PackCount smallint, ' +
         '    PackTypeID tinyint, PCCID int, UnitID int, [Weight] decimal(19,2), ' + 
         '    Width smallint, TZ varchar(30), TMCID int)'
END
GO