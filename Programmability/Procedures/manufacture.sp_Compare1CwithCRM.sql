SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   21.12.2016$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   15.09.2017*/
/*$Version:    1.00$   $Description: Сравнение контрагентов 1С и СРМ$*/
CREATE PROCEDURE [manufacture].[sp_Compare1CwithCRM]
--WITH EXECUTE AS 'SpeklerUser'
--'Spekl\ZapadinskiyA'  
AS 
BEGIN
	SET NOCOUNT ON;
	
    IF object_id('tempdb..#Accounts') is not null DROP TABLE #Accounts
    IF object_id('tempdb..#CRMAccounts') is not null DROP TABLE #CRMAccounts
    IF object_id('tempdb..#AccountsEx') is not null DROP TABLE #AccountsEx    
        
    SELECT row_number() OVER(ORDER BY r._Description) as ID
	   , CAST(r._Description as nvarchar(2000)) COLLATE Cyrillic_General_CI_AS as [Name]
	   , CAST(r._Fld1792 as nvarchar(2000)) COLLATE Cyrillic_General_CI_AS as FullName
	   , CAST(r._Fld1811 as tinyint) as NonResident
       , CAST(r._Fld1798 as nvarchar(2000)) COLLATE Cyrillic_General_CI_AS as INN
       , CAST(r._Fld1809 as nvarchar(2000)) COLLATE Cyrillic_General_CI_AS as EGRPOU
    INTO #Accounts
    FROM [1cv8work].dbo._Reference112 r
    ORDER BY r._Description;

    SELECT row_number() OVER(ORDER BY a.[name]) as ID
           , CAST(a.[name] as nvarchar(2000)) COLLATE Cyrillic_General_CI_AS as [Name]
           , CAST(a.[px_full_name] as nvarchar(2000)) COLLATE Cyrillic_General_CI_AS as [FullName]       
           , CAST(a.sic_code as nvarchar(2000)) COLLATE Cyrillic_General_CI_AS as [INN]
           , CAST(a.px_egrpou_code as nvarchar(2000)) COLLATE Cyrillic_General_CI_AS as [EGRPOU]
           , CAST(a.px_client_category as nvarchar(2000)) COLLATE Cyrillic_General_CI_AS as [category]
           , CAST(a.px_client_status as nvarchar(2000)) COLLATE Cyrillic_General_CI_AS as [Status]
           , CAST(a.px_type as nvarchar(2000)) COLLATE Cyrillic_General_CI_AS as [Type]
           , a.ID as PX
           , IsNull(u.last_name,'') + ' ' + IsNull(u.first_name,'') as UserFullName
    INTO #CRMAccounts       
    FROM [CRM].SugarCRM.dbo.accounts a
         LEFT JOIN [CRM].SugarCRM.dbo.users as u on u.ID = a.assigned_user_id   
    WHERE a.deleted = 0
    
    SELECT a.ID,
           a.Name,
           a1C.FullName,
           a.TypeOf1C,
    /*       a1C.ID,*/
    /*       a1C.EGRPOU,*/
           CASE WHEN a1C.ID is null THEN 'Нет в 1С'
                WHEN IsNull(a.EDRPOU,'') <> '' AND IsNull(a1C.EGRPOU,'') = ''  AND a1C.ID is not null THEN IsNull(a.EDRPOU,'')
                WHEN IsNull(a.EDRPOU,'') = '' AND IsNull(a1C.EGRPOU,'') <> ''  AND a1C.ID is not null THEN IsNull(a1C.EGRPOU,'')
                WHEN IsNull(a.EDRPOU,'') = IsNull(a1C.EGRPOU,'') THEN IsNull(a1C.EGRPOU,'')
                WHEN IsNull(a.EDRPOU,'') <> IsNull(a1C.EGRPOU,'') AND a1C.ID is not null THEN 'Не совпадает'             
                END as EGRPOU,
           CASE WHEN a1C.ID is null THEN 'Нет в 1С'
                WHEN IsNull(a.INN,'') <> '' AND IsNull(a1C.INN,'') = ''  AND a1C.ID is not null THEN IsNull(a.INN,'')
                WHEN IsNull(a.INN,'') = '' AND IsNull(a1C.INN,'') <> ''  AND a1C.ID is not null THEN IsNull(a1C.INN,'')
                WHEN IsNull(a.INN,'') = IsNull(a1C.INN,'') THEN IsNull(a1C.INN,'')
                WHEN IsNull(a.INN,'') <> IsNull(a1C.INN,'') AND a1C.ID is not null THEN 'Не совпадает'             
                END as INN
    INTO #AccountsEx            
    FROM [CRM].SugarCRM.dbo.tmp_Accounts a
         LEFT JOIN #Accounts a1C on a1C.Name = a.Name

    SELECT a.*
    	  , crma.[UserFullName]
          , crma.[Name] as CrmName       
          , crma.FullName as CrmFullName       
          , crma.[INN] as CrmINN       
          , crma.[EGRPOU] as CrmEGRPOU       
          , CASE WHEN crma.ID is null THEN 'Добавить в СРМ'
                 WHEN /*(LTRIM(RTRIM(crma.[Name])) <> LTRIM(RTRIM(a.Name)) AND crma.ID is not null)*/
                      /*OR */
                      (LTRIM(RTRIM(crma.FullName)) <> LTRIM(RTRIM(a.FullName)) AND crma.ID is not null)
                      OR (IsNull(crma.[INN],'') <> IsNull(a.INN,'') AND crma.ID is not null)
                      OR (IsNull(crma.[EGRPOU],'') <> IsNull(a.EGRPOU,'') AND crma.ID is not null)                                    
                      THEN 'Внести правки в СРМ'
                 ELSE 'Данные совпадают'     
            END as 'Что делать'    
          /*, CASE WHEN LTRIM(RTRIM(crma.[Name])) <> LTRIM(RTRIM(a.Name)) AND crma.ID is not null THEN 'Name' ELSE '' END as Name */
          , CASE WHEN LTRIM(RTRIM(LOWER(crma.FullName))) <> LTRIM(RTRIM(LOWER(a.FullName))) AND crma.ID is not null THEN 'FullName' ELSE '' END as FullName
          , CASE WHEN IsNull(crma.[INN],'') <> IsNull(a.INN,'') AND crma.ID is not null THEN 'INN' ELSE '' END as INN
          , CASE WHEN IsNull(crma.[EGRPOU],'') <> IsNull(a.EGRPOU,'') AND crma.ID is not null THEN 'EGRPOU' ELSE '' END as EGRPOU      
    FROM #AccountsEx a
         LEFT JOIN #CRMAccounts crma on (LTRIM(RTRIM(crma.Name)) = LTRIM(RTRIM(a.Name))) OR (LTRIM(RTRIM(crma.FullName)) = LTRIM(RTRIM(a.FullName))) 
                                OR (IsNull(crma.INN,'') = IsNull(a.INN,'') AND (IsNull(crma.INN,'') <>'' OR IsNull(a.INN,'') <> '')) 
                                OR (IsNull(crma.EGRPOU,'') = IsNull(a.EGRPOU,'') AND (IsNull(crma.EGRPOU,'') <>'' OR IsNull(a.EGRPOU,'') <> ''))
    ORDER BY a.NAME   
END
GO