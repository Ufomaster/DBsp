SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


--$Create:     Yuriy Oleynik$	$Create date:   09.02.2011$
--$Modify:     Yuriy Oleynik$	$Modify date:   09.02.2011$
--$Version:    1.00$   $Decription: Генерация ошибок$
CREATE PROC [dbo].[sp_RaiseError]
	@ID				bigint			= NULL,
	@Parameter1		nvarchar(2048)	= NULL,
	@Parameter2		nvarchar(2048)	= NULL
AS
BEGIN
    DECLARE @ErrorMessage nvarchar(4000), @ParameterCount int, @TemplateText nvarchar(2048)

	SELECT @ErrorMessage = CAST(ERROR_NUMBER() AS varchar(10)) + ': ' + ERROR_MESSAGE() 
		+ ISNULL(' Procedure ' + ERROR_PROCEDURE() + ',', '') + ' Line ' + CAST(ERROR_LINE() AS varchar(10))

	RAISERROR (@ErrorMessage, 16, 1)
END
GO