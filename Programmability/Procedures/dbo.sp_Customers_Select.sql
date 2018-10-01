SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$    $Create date:   07.02.2018$
--$Modify:     Yuriy Oleynik$    $Modify date:   05.03.2018$
--$Version:    1.00$   $Decription:$
CREATE PROCEDURE [dbo].[sp_Customers_Select]
AS
BEGIN
    SELECT c.*, CASE WHEN c.CODE1C IS NULL THEN 0 ELSE 1 END AS Sync1C 
    FROM Customers c 
    WHERE ISNULL(c.Deleted, 0) = 0  --OR c.ParentID NOT IN (SELECT ID FROM Customers WHERE ATTIsDeleted = 1) 
    ORDER BY c.Name
END
GO