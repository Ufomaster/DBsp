SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   12.03.2013$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   15.05.2013$*/
/*$Version:    1.00$   $Decription: синхронизация CRM вставка апдейт делит Contacts $*/
CREATE PROCEDURE [sync].[sp_Sync_SugarCRM_ProcessContacts_Obsolete]
    @ID nvarchar(36), 
    @OperationType nvarchar(50),
    @PrimaryEntityCodeCRM nvarchar(36),
    @CustomerID int = NULL,
    @OldCustomerID int = NULL
AS
BEGIN
    EXECUTE AS USER = 'SpeklerUser'
    SET NOCOUNT ON    
    DECLARE @ContactID int
    IF @OperationType = 'insert' OR @OperationType = 'update'
    BEGIN
        --insert
        INSERT INTO dbo.CustomerContacts(CustomerID, [Name], 
            [Position], [CellPhone], [WorkPhone], [HomePhone], [Fax], [Email], 
            [CodeCRM], [Department], [SyncCRM])
        SELECT @CustomerID, RTRIM(LTRIM(ISNULL(cnt.LastName, '') + ' ' + ISNULL(cnt.FirstName, '') + ' ' + ISNULL(cnt.MiddleName, ''))),
            cnt.Position, cnt.Mobile, cnt.WorkPhone, cnt.Phone, cnt.Fax, cnt.Email,
            cnt.CodeCRM, cnt.Department, 1
        FROM sync.CRMContacts cnt
        LEFT JOIN dbo.CustomerContacts ccnt ON ccnt.CodeCRM = cnt.CodeCRM AND ccnt.CustomerID = @CustomerID
        WHERE cnt.CRMTransactionID = @ID AND cnt.CustomerCodeCRM = @PrimaryEntityCodeCRM
           AND ccnt.ID IS NULL
                    
        --update
        UPDATE ccnt
        SET ccnt.[Name] = RTRIM(LTRIM(ISNULL(cnt.LastName, '') + ' ' + ISNULL(cnt.FirstName, '') + ' ' + ISNULL(cnt.MiddleName, ''))),
            ccnt.[Position] = cnt.Position,
            ccnt.[CellPhone] = cnt.Mobile,
            ccnt.[WorkPhone] = cnt.WorkPhone,
            ccnt.[HomePhone] = cnt.Phone,
            ccnt.[Fax] = cnt.Fax,
            ccnt.[Email] = cnt.Email,
            ccnt.[Department] = cnt.Department,
            ccnt.Deleted = 0,
            ccnt.SyncCRM = 1
        FROM dbo.CustomerContacts ccnt
        INNER JOIN sync.CRMContacts cnt ON ccnt.CodeCRM = cnt.CodeCRM AND cnt.CRMTransactionID = @ID AND cnt.CustomerCodeCRM = @PrimaryEntityCodeCRM
        WHERE ccnt.CustomerID = @CustomerID

        --delete
        DECLARE #CurUD CURSOR FOR SELECT cc.ID -- выбираем удаленные контакты у контрагента.
                                  FROM CustomerContacts cc
                                  LEFT JOIN sync.CRMContacts crmc ON crmc.CustomerCodeCRM = @PrimaryEntityCodeCRM AND cc.CodeCRM = crmc.CodeCRM
                                     AND crmc.CRMTransactionID = @ID
                                  WHERE cc.CustomerID = @CustomerID AND crmc.CodeCRM IS NULL AND cc.CodeCRM IS NOT NULL --cc.CodeCRM IS NOT NULL- удаляем только среди синхронизированных
        OPEN #CurUD
        FETCH NEXT FROM #CurUD INTO @ContactID
        WHILE @@FETCH_STATUS = 0
        BEGIN
            IF EXISTS(SELECT TOP 1 * FROM dbo.ProductionOrders po WHERE po.CustomerContactID = @ContactID)
              OR
              EXISTS(SELECT TOP 1 * FROM dbo.ProductionOrders po WHERE po.SpeklContactID = @ContactID)
              OR
              EXISTS(SELECT TOP 1 * FROM dbo.Agreements ag WHERE ag.ContactID = @ContactID)
            BEGIN
               UPDATE a
               SET
                   a.Deleted = 1,
                   a.SyncCRM = 1
               FROM CustomerContacts a
               WHERE a.ID = @ContactID
            END
            ELSE
               DELETE FROM CustomerContacts
               WHERE ID = @ContactID

            FETCH NEXT FROM #CurUD INTO @ContactID
        END
        CLOSE #CurUD
        DEALLOCATE #CurUD
    END
    ELSE
    IF @OperationType = 'merge'
    BEGIN
       -- перемещаем все наши контакты удаляемого контрагента новому контрагенту
       UPDATE cc
       SET cc.CustomerID = @CustomerID, cc.SyncCRM = CASE WHEN cc.CodeCRM IS NULL THEN 0 ELSE 1 END
       FROM dbo.CustomerContacts cc
       WHERE cc.CustomerID = @OldCustomerID
   END
   ELSE
   IF @OperationType = 'delete'
   BEGIN
       DECLARE #CurCon CURSOR FOR SELECT cc.ID FROM CustomerContacts cc WHERE cc.CustomerID = @CustomerID
       OPEN #CurCon
       FETCH NEXT FROM #CurCon INTO @ContactID
       WHILE @@FETCH_STATUS = 0
       BEGIN
           IF EXISTS(SELECT TOP 1 * FROM dbo.ProductionOrders po WHERE po.CustomerContactID = @ContactID )
              OR
              EXISTS(SELECT TOP 1 * FROM dbo.ProductionOrders po WHERE po.SpeklContactID = @ContactID)
              OR
              EXISTS(SELECT TOP 1 * FROM dbo.Agreements ag WHERE ag.ContactID = @ContactID)
           BEGIN
               UPDATE a
               SET
                   a.Deleted = 1,
                   a.SyncCRM = 1
               FROM CustomerContacts a
               WHERE a.ID = @ContactID
           END
           ELSE
               DELETE FROM CustomerContacts
               WHERE ID = @ContactID

           FETCH NEXT FROM #CurCon INTO @ContactID
       END
       CLOSE #CurCon
       DEALLOCATE #CurCon
   END
   REVERT;
END
GO