SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   27.11.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   21.01.2016$*/
/*$Version:    1.00$   $Description: подписание протокола$*/
CREATE PROCEDURE [QualityControl].[sp_Protocols_Sign]
    @ID Int,
    @ProtocolsSignersID Int = NULL,
    @EmployeeID int
AS
BEGIN
	SET NOCOUNT ON
    DECLARE @Err Int
                
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        DECLARE @AutoStatusID int, @StatusID int, @StatusMapID int, @ActID int,
        @AutoCreateAct bit, @NotifyEventID int, @SetQCSpecSignedDate bit, @SetAuthSignedDate bit
        
        DECLARE @ActDetails TABLE (XMLData xml, ParagraphCaption varchar(255), EmployeeID int, SortOrder int)

        DECLARE @Res varchar(max), @ActTemplatesID int, @ActTemplates2ID int
        DECLARE @t TABLE(ID int)
        
        UPDATE q
        SET q.SignDate = GETDATE()
        FROM QualityControl.ProtocolsSigners q
        WHERE q.ID = @ProtocolsSignersID
        
        SELECT @StatusID = StatusID
        FROM QualityControl.Protocols 
        WHERE ID = @ID
            
        /*Если все подписано, пытаемся сделать автоперевод в статус.*/
        IF NOT EXISTS(SELECT ID FROM QualityControl.ProtocolsSigners a 
                      WHERE EmailOnly = 0 AND SignDate IS NULL AND a.ProtocolID = @ID)
        BEGIN
            SELECT TOP 1
                @AutoCreateAct = m.AutoCreateAct, 
                @NotifyEventID = m.NotifyEventID,
                @SetQCSpecSignedDate = m.SetQCSpecSignedDate,
                @SetAuthSignedDate = m.SetAuthSignedDate,
                @StatusMapID = m.ID
            FROM QualityControl.TypesProcessMap m
            WHERE m.GoStatusID = @StatusID

            --AutoCreate ACT
            IF @AutoCreateAct = 1
            BEGIN
                --для критических НС ImportanceID = 1
                SELECT 
                    @Res = ISNULL(@Res, '') +
                    '<tr><td>' + d.[Caption] + '</td>' +  
                    '<td>' + d.ValueToCheck + '</td>' + 
                    '<td>' + d.FactValue + '</td></tr>'
                FROM (SELECT 
                          ISNULL([Caption], '-') AS [Caption],
                          ISNULL(ValueToCheck, '-') AS ValueToCheck,
                          ISNULL(FactValue, '-') AS FactValue
                      FROM QualityControl.ProtocolsDetails
                      WHERE ProtocolID = @ID AND Checked = 0 AND ImportanceID = 1) AS d
                
                SELECT @Res = '<table border=1><tr><th>Наименование</th><th>Нормативное значение</th><th>Фактическое значение</th></tr>' + @Res + '</table>'
                
                IF ISNULL(@Res, '') <> '' 
                BEGIN
                    SELECT @ActTemplatesID = t.ActTemplatesID
                    FROM QualityControl.Protocols p 
                    INNER JOIN QualityControl.Types t ON t.ID = p.TypesID
                    WHERE p.ID = @ID
                  
                    INSERT INTO QualityControl.Acts(CreateDate, StatusID, ActTemplatesID, AuthorEmployeeID, Number, ProtocolID, Properties)
                    OUTPUT INSERTED.ID INTO @t
                    SELECT 
                        GetDate(),
                        (SELECT TOP 1 a.ID FROM QualityControl.ActStatuses a WHERE a.IsFirst = 1),
                        @ActTemplatesID,
                        (SELECT c.EmployeeID FROM #CurrentUser c),
                        ISNULL(Max(b.Number), 0) + 1,
                        @ID,
                        @Res
                    FROM QualityControl.Acts b
                    
                    SELECT @ActID = ID FROM @T 

                    INSERT INTO @ActDetails(XMLData, ParagraphCaption, EmployeeID, SortOrder)
                    EXEC QualityControl.sp_Acts_GenerateDetails @ActTemplatesID

                    INSERT INTO QualityControl.ActsDetails(ActsID, XMLData, ParagraphCaption, EmployeeID, SortOrder)
                    SELECT
                        @ActID,
                        XMLData, 
                        ParagraphCaption, 
                        EmployeeID, 
                        SortOrder
                    FROM @ActDetails
                END
                
                SET @Res = NULL
                DELETE FROM @ActDetails
                DELETE FROM @t
                
                --для НЕкритических НС ImportanceID = 2
                SELECT 
                    @Res = ISNULL(@Res, '') +
                    '<tr><td>' + d.[Caption] + '</td>' +  
                    '<td>' + d.ValueToCheck + '</td>' + 
                    '<td>' + d.FactValue + '</td></tr>'
                FROM (SELECT 
                          ISNULL([Caption], '-') AS [Caption],
                          ISNULL(ValueToCheck, '-') AS ValueToCheck,
                          ISNULL(FactValue, '-') AS FactValue
                      FROM QualityControl.ProtocolsDetails
                      WHERE ProtocolID = @ID AND Checked = 0 AND ImportanceID = 2) AS d
                
                SELECT @Res = '<table border=1><tr><th>Наименование</th><th>Нормативное значение</th><th>Фактическое значение</th></tr>' + @Res + '</table>'
                
                IF ISNULL(@Res, '') <> '' 
                BEGIN
                    SELECT @ActTemplates2ID = t.ActTemplates2ID
                    FROM QualityControl.Protocols p 
                    INNER JOIN QualityControl.Types t ON t.ID = p.TypesID
                    WHERE p.ID = @ID
                  
                    INSERT INTO QualityControl.Acts(CreateDate, StatusID, ActTemplatesID, AuthorEmployeeID, Number, ProtocolID, Properties)
                    OUTPUT INSERTED.ID INTO @t
                    SELECT
                        GetDate(),
                        (SELECT TOP 1 a.ID FROM QualityControl.ActStatuses a WHERE a.IsFirst = 1),
                        @ActTemplates2ID,
                        (SELECT c.EmployeeID FROM #CurrentUser c),
                        ISNULL(Max(b.Number), 0) + 1,
                        @ID,
                        @Res
                    FROM QualityControl.Acts b
                    SELECT @ActID = ID FROM @T

                    INSERT INTO @ActDetails(XMLData, ParagraphCaption, EmployeeID, SortOrder)
                    EXEC QualityControl.sp_Acts_GenerateDetails @ActTemplates2ID

                    INSERT INTO QualityControl.ActsDetails(ActsID, XMLData, ParagraphCaption, EmployeeID, SortOrder)
                    SELECT
                        @ActID,
                        XMLData, 
                        ParagraphCaption, 
                        EmployeeID, 
                        SortOrder
                    FROM @ActDetails
                END

                SELECT 
                    @AutoCreateAct AS AutoCreateAct, 
                    @ActID AS ActID,
                    @NotifyEventID AS NotifyEventID, 
                    --CAST(CASE WHEN @AutoStatusID IS NOT NULL THEN 1 ELSE 0 END AS bit) AS TurnedIntoNextStatus,
                    @StatusMapID AS StatusMapID
            END
            ELSE
                SELECT 
                    CAST(0 AS bit) AS AutoCreateAct, 
                    NULL AS ActID,
                    NULL AS NotifyEventID, 
                    --CAST(CASE WHEN @AutoStatusID IS NOT NULL THEN 1 ELSE 0 END AS bit) AS TurnedIntoNextStatus,
                    NULL AS StatusMapID
        END
        ELSE
          SELECT 
              CAST(0 AS bit) AS AutoCreateAct, 
              NULL AS ActID,
              NULL AS NotifyEventID, 
              --CAST(CASE WHEN @AutoStatusID IS NOT NULL THEN 1 ELSE 0 END AS bit) AS TurnedIntoNextStatus,
              NULL AS StatusMapID
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO