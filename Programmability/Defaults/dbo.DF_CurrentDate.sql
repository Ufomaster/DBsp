﻿SET QUOTED_IDENTIFIER OFF
GO
CREATE DEFAULT [dbo].[DF_CurrentDate] AS (GetDate()
)
GO