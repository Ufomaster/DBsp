SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   02.02.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   16.01.2013$*/
/*$Version:    1.00$   $Decription: Выбор данных для рассылки по событию$*/
CREATE PROCEDURE [dbo].[sp_NotifyEvent_SelectRecipients]
    @EventID Int,
    @EmployeesList Varchar(8000) = ''
AS
BEGIN
    SET NOCOUNT ON
    IF ISNULL(@EmployeesList, '') = '' 
        SELECT
            nee.ID,
            nee.NotifyEventID,
            e.ID AS EmployeeID,        
            e.FullName,        
            ne.Body,
            ne.[Name],    
            a.Authentification,
            a.[Name] AS AccountName,
            a.[Password],
            a.POP3Port,
            a.POP3Server,
            a.ReplyAddress,
            a.SenderAddress,
            a.SenderName,
            a.SMTPPort,
            a.SMTPServer,
            a.UserName,
            e.EMail,
            ne.IsHTML
        FROM NotifyEventsEmployees nee 
        INNER JOIN NotifyEvents ne ON ne.ID = nee.NotifyEventID
        INNER JOIN Accounts a ON a.ID = ne.AccountID AND a.IsActive = 1
        INNER JOIN vw_Employees e ON e.DepartmentPositionID = nee.DepartmentPositionID
        WHERE ne.ID = @EventID AND nee.isActive = 1 AND ISNULL(e.EMail, '') <> ''
    ELSE
        SELECT
            ROW_NUMBER() OVER (ORDER BY lst.ID) AS ID,
            @EventID AS NotifyEventID,
            e.ID AS EmployeeID,        
            e.FullName,        
            ne.Body,
            ne.[Name],    
            a.Authentification,
            a.[Name] AS AccountName,
            a.[Password],
            a.POP3Port,
            a.POP3Server,
            a.ReplyAddress,
            a.SenderAddress,
            a.SenderName,
            a.SMTPPort,
            a.SMTPServer,
            a.UserName,
            e.EMail,
            ne.IsHTML
        FROM dbo.fn_StringToITable(@EmployeesList) AS lst
        INNER JOIN vw_Employees e ON lst.ID = e.ID
        INNER JOIN NotifyEvents ne ON ne.ID = @EventID
        INNER JOIN Accounts a ON a.ID = ne.AccountID AND a.IsActive = 1
        WHERE ISNULL(e.EMail, '') <> ''
END
GO