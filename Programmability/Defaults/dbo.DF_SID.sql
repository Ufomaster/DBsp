﻿SET QUOTED_IDENTIFIER OFF
GO
CREATE DEFAULT [dbo].[DF_SID] AS (SUSER_SID()
)
GO