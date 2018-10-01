SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    		$Create date:   26.02.2016$*/
/*$Modify:     Yuriy Oleynik$   		$Modify date:   10.03.2017$*/
/*$Version:    1.00$   $Decription: Информация о сменном задании$*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasksInfoBlock_Select]
    @InfoType int,
    @ProductionTasksID int,
    @NoWOff bit = 0, --не показывать списанные материалы
    @ShowAllDocs bit = 0,  --показать все документы за сменку
    @ShowShipped bit = 0, -- показывать отгруженные
    @ShowUtilized bit = 0 -- показывать утилизированные
AS
BEGIN
    --1	Приход	
    --2	Производство	
    --3	Перемещение	
    --4	Отгрузка	
    --5	Списание	
    --6	Брак
	DECLARE @CurrentSectorID int
    SELECT @CurrentSectorID = pt.StorageStructureSectorID
    FROM manufacture.ProductionTasks pt WHERE pt.ID = @ProductionTasksID

    IF @InfoType = 0 --левый грид с материалами ожидающими подтверждения - выборка по всем сменкам у которых таргет наше рабочее место и эти док-ты ещё не покрыты
    BEGIN
        /*перемещаемые материалы на это рабочее место из всех сменок и ещё не привязанные ConfirmStatus = 0. */
        SELECT
            d.ID
            , pc.Number
            , dd.TMCID
            , dd.Amount
            , t.[Name]
            , dd.StatusID
            , s.[Name] AS StatusName
            , s.InternalName 
            , d.ConfirmStatus
            , dd.isMajorTMC
            , sss.[Name] AS SectorName
            , d.CreateDate
            , dh.ModifyDate
            , e.FullName
        FROM manufacture.ProductionTasksDocs d 
             INNER JOIN manufacture.ProductionTasksDocDetails dd ON dd.ProductionTasksDocsID = d.ID
             LEFT JOIN ProductionCardCustomize pc ON pc.ID = dd.ProductionCardCustomizeID
             LEFT JOIN manufacture.ProductionTasksStatuses s ON s.ID = dd.StatusID
             LEFT JOIN manufacture.StorageStructureSectors sss ON sss.ID = d.StorageStructureSectorID
             LEFT JOIN Tmc t ON t.ID = dd.TMCID
             LEFT JOIN (SELECT dh.* 
                        FROM manufacture.ProductionTasksDocsHistory dh
             		        INNER JOIN (SELECT dh.DocID, MAX(dh.ID) as ID FROM manufacture.ProductionTasksDocsHistory dh WHERE dh.StorageStructureSectorToID = @CurrentSectorID GROUP BY dh.DocID) dhI on dhI.ID = dh.ID
                       ) dh on dh.DocID = d.ID
             LEFT JOIN vw_Employees e on e.id = dh.ModifyEmployeeID
             LEFT JOIN manufacture.ProductionTasksDocs linkD on linkD.ID = d.LinkedProductionTasksDocsID
        WHERE d.ProductionTasksOperTypeID = 3  
              AND ((d.ConfirmStatus = 0 AND @ShowAllDocs = 0) OR 
                   (d.ConfirmStatus is not null AND @ShowAllDocs = 1))
              AND ((d.StorageStructureSectorToID = @CurrentSectorID AND d.ConfirmStatus = 0) OR
                   (linkD.ProductionTasksID = @ProductionTasksID))                        
    END
    ELSE
    IF @InfoType = 1 --центральный грид - тут все данные по текущей обстановке, приходы, изготовления, списания и т.п.
    BEGIN  
        /* Group to SUM unconfirmed movement*/
        SELECT  
        	   ProductionCardCustomizeName,
	           Number,
               Name,
               StatusName,
               UnitName,
               ProductionTasksID, 
               TMCID, 
               ProductionTasksStatusID, 
               ProductionCardCustomizeID, 
               isMajorTMC,
               SUM(Amount) as Amount, 
               1 as ConfirmStatus
        FROM manufacture.vw_ProductionTasksAgregation_Select pta             
        WHERE pta.ProductionTasksID = @ProductionTasksID
	         AND ((pta.ProductionTasksStatusID <> 2 AND @NoWOff = 1) OR (@NoWOff = 0))
             AND ((pta.ProductionTasksStatusID <> 5 AND @ShowShipped = 0) OR (@ShowShipped = 1))
             AND ((pta.ProductionTasksStatusID <> 6 AND @ShowUtilized = 0) OR (@ShowUtilized = 1))
             AND pta.Amount <> 0
        GROUP BY ProductionCardCustomizeName, Number, Name, StatusName, UnitName, ProductionTasksID, TMCID, ProductionTasksStatusID, 
                 ProductionCardCustomizeID, isMajorTMC
        HAVING SUM(Amount) <> 0
    END
    ELSE
    IF @InfoType = 2 -- правый грид с исходящими материалами.
    BEGIN
        /*перемещаемые материалы на другое рм или то же. ConfirmStatus = 0. И текущая сменка.*/
        SELECT
            d.ID
            , pc.Number
            , dd.TMCID
            , dd.Amount
            , t.[Name]
            , dd.StatusID
            , s.[Name] AS StatusName
            , s.InternalName 
            , d.ConfirmStatus
            , dd.isMajorTMC
            , sss.[Name] AS SectorName
            , d.CreateDate
            , dh.ModifyDate
            , e.FullName           
        FROM manufacture.ProductionTasksDocs d 
             INNER JOIN manufacture.ProductionTasksDocDetails dd ON dd.ProductionTasksDocsID = d.ID
             LEFT JOIN ProductionCardCustomize pc ON pc.ID = dd.ProductionCardCustomizeID           
             LEFT JOIN manufacture.ProductionTasksStatuses s ON s.ID = dd.StatusID
             LEFT JOIN manufacture.StorageStructureSectors sss ON sss.ID = d.StorageStructureSectorToID                     
             LEFT JOIN Tmc t ON t.ID = dd.TMCID
             LEFT JOIN (SELECT dh.* 
                        FROM manufacture.ProductionTasksDocsHistory dh
             		        INNER JOIN (SELECT dh.DocID, MAX(dh.ID) as ID FROM manufacture.ProductionTasksDocsHistory dh WHERE dh.StorageStructureSectorToID = @CurrentSectorID GROUP BY dh.DocID) dhI on dhI.ID = dh.ID
                       ) dh on dh.DocID = d.ID
             LEFT JOIN vw_Employees e on e.id = dh.ModifyEmployeeID         
        WHERE d.ProductionTasksID = IsNull(@ProductionTasksID,0) AND d.StorageStructureSectorID = @CurrentSectorID AND d.ProductionTasksOperTypeID = 3
              AND ((d.ConfirmStatus = 0 AND @ShowAllDocs = 0) OR 
                   (d.ConfirmStatus IN (0,1,2) AND @ShowAllDocs = 1))
    END
END
GO