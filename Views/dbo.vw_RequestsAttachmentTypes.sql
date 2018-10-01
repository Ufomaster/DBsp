SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


--$Create:     Oleynik Yuriy$	$Create date:   22.02.2011$
--$Modify:     Oleynik Yuriy$	$Modify date:   22.02.2011$
--$Version:    1.00$   $Description: Вьюшка с типами файлов аттачмента$
CREATE VIEW [dbo].[vw_RequestsAttachmentTypes]
AS
    SELECT 0 AS ID, CAST('.jpeg' AS VARCHAR(50)) AS [Name], -1 AS ImageIndex,
        CAST('Supported files|*.jpeg;*.jpg;*.png;*.bmp;*.rtf;*.doc;*.docx;*.pdf;*.xls;*.xlsx;' AS Varchar(1000)) AS Mask
    UNION ALL
    SELECT 1, '.jpg', -1, 'Supported files|*.jpeg;*.jpg;*.png;*.bmp;*.rtf;*.doc;*.docx;*.pdf;*.xls;*.xlsx;'
    UNION ALL
    SELECT 2, '.png', -1, 'Supported files|*.jpeg;*.jpg;*.png;*.bmp;*.rtf;*.doc;*.docx;*.pdf;*.xls;*.xlsx;'
    UNION ALL
    SELECT 3, '.bmp', -1, 'Supported files|*.jpeg;*.jpg;*.png;*.bmp;*.rtf;*.doc;*.docx;*.pdf;*.xls;*.xlsx;'
    UNION ALL
    SELECT 4, '.rtf', -1, 'Supported files|*.jpeg;*.jpg;*.png;*.bmp;*.rtf;*.doc;*.docx;*.pdf;*.xls;*.xlsx;'
    UNION ALL
    SELECT 5, '.doc', -1, 'Supported files|*.jpeg;*.jpg;*.png;*.bmp;*.rtf;*.doc;*.docx;*.pdf;*.xls;*.xlsx;'
    UNION ALL
    SELECT 6, '.docx', -1, 'Supported files|*.jpeg;*.jpg;*.png;*.bmp;*.rtf;*.doc;*.docx;*.pdf;*.xls;*.xlsx;'
    UNION ALL
    SELECT 7, '.pdf', -1, 'Supported files|*.jpeg;*.jpg;*.png;*.bmp;*.rtf;*.doc;*.docx;*.pdf;*.xls;*.xlsx;'
    UNION ALL
    SELECT 8, '.xls', -1, 'Supported files|*.jpeg;*.jpg;*.png;*.bmp;*.rtf;*.doc;*.docx;*.pdf;*.xls;*.xlsx;'
    UNION ALL
    SELECT 9, '.xlsx', -1, 'Supported files|*.jpeg;*.jpg;*.png;*.bmp;*.rtf;*.doc;*.docx;*.pdf;*.xls;*.xlsx;'
GO