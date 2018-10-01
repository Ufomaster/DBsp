SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Poliatykin Oleksii$    $Create date:   22.06.2018$
--$Modify:     Poliatykin Oleksii$    $Modify date:   17.07.2018$
--$Version:    1.00$   $Decription: Выборка активных работ для ДОДа$

create PROCEDURE [dod].[sp_JobsSettings_SelectActive]
  AS
BEGIN
  select
            js.*
         ,  ISNULL( CAST(js.id as Varchar(20)) + '. ','') + ISNULL('№ '+ pcc.Number,'') + ISNULL('   '+ pcc.Name ,'') as FName
  from dod.JobsSettings js
       left JOIN dbo.ProductionCardCustomize pcc on js.PCCID = pcc.ID
  where js.Status = 1 
END
GO