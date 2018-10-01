SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   21.04.2017$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   12.06.2017$*/
/*$Version:    1.00$   $Decription: Выборка данных для функции "добавить" $*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_FuncNewPrepare]
    @ArrayOfPCCID varchar(max),
    @Amount decimal(38,10) = 0,
    @SectorID int,
    @isStandartMode bit, --определеят режим работы для стандартных материалов или нестандартных.
    @isBreakThrought bit = 0, --определяет происходит ли приход ГП в разрез процесса. @isStandartMode не обрабатывается. Это грубо говоря 3-й режим работы формы после @isStandartMode
    @NewStatsID tinyint = 0 --будущий статус входящей ГП
AS
BEGIN
    DELETE FROM #NewMaterials
    DECLARE @OutProdClass tinyint
    
    IF @isBreakThrought = 0
    BEGIN
        IF @isStandartMode = 0
            INSERT INTO #NewMaterials(ID, Name, UnitName, Amount, Number)
            SELECT t.ID , t.[Name], u.Name AS UnitName, (d.Norma/pc.CardCountInvoice)*@Amount AS RecommendAmount, pc.Number
            FROM Tmc t
            LEFT JOIN Units u ON u.ID = t.UnitID
            INNER JOIN ProductionCardCustomizeMaterials d ON d.TmcID = t.ID
            INNER JOIN ProductionCardCustomize PC ON PC.ID = d.ProductionCardCustomizeID
            INNER JOIN ObjectTypes ot ON ot.ID = t.ObjectTypeID AND ISNULL(ot.isStandart, 0) = 0
            WHERE d.ProductionCardCustomizeID IN (SELECT b.ID FROM dbo.fn_StringToSTable(@ArrayOfPCCID) a INNER JOIN ProductionCardCustomize b ON b.Number = a.ID)
                AND t.ID IN (SELECT ID FROM dbo.fn_TMCLinkedToSectors_Select(@SectorID, d.TmcID, NULL))
                AND ISNULL(t.IsHidden, 0) = 0 AND t.Code1C IS NOT NULL
            ORDER BY t.Name
        ELSE
            INSERT INTO #NewMaterials(ID, Name, UnitName, Amount, Number)
            SELECT t.ID , t.[Name], u.Name AS UnitName, 0, NULL
            FROM Tmc t
            LEFT JOIN Units u ON u.ID = t.UnitID
            INNER JOIN ObjectTypes ot ON ot.ID = t.ObjectTypeID AND ISNULL(ot.isStandart, 0) = 1
            WHERE t.ID IN (SELECT ID FROM dbo.fn_TMCLinkedToSectors_Select(@SectorID, t.ID, NULL))
                AND ISNULL(t.IsHidden, 0) = 0 AND t.Code1C IS NOT NULL
            ORDER BY t.Name
    END
    ELSE
    BEGIN  
        -- В зависимости от найстройки Аут продакт класс выбираем или полуфабрикат сурогат или ТМЦ из ЗЛ результат работ.
        SELECT @OutProdClass = st.OutProdClass 
        FROM manufacture.ProductionTasksStatuses st
        WHERE st.ID = @NewStatsID

        /*    SELECT 0 AS ID, 'Входящая ГП с передающего участка' AS Name
            SELECT 1, 'Создание пакета из ТЛ'
            SELECT 2, 'Автопоиск ГП из ЗЛ'
            SELECT 3, 'Создание тиражных листов'
            SELECT 4, 'Вырубка карт'*/
        IF (@OutProdClass = 1)
        BEGIN
            --Ищем ПОлуфабрикат по ЗЛ из разбивки ТМЦПцц. Если он не создан - 
            INSERT INTO #NewMaterials(ID, Name, UnitName, Amount, Number)
            SELECT t.ID, t.[Name], u.Name AS UnitName, 0, @ArrayOfPCCID
            FROM Tmc t
            INNER JOIN TmcPCC tp ON tp.TmcID = t.ID 
                AND tp.ProductionCardCustomizeID IN (SELECT ID FROM ProductionCardCustomize WHERE Number LIKE @ArrayOfPCCID)
            LEFT JOIN Units u ON u.ID = t.UnitID
            INNER JOIN TMCAttributes ta ON ta.TMCID = t.ID AND ta.AttributeID = 20
            WHERE ISNULL(t.IsHidden, 0) = 0
            ORDER BY t.Name
            --могло не создасться - нужно создать полуфабрикат по ТЛ - пока не создаем - создаем вручную на интерфейсе. Потом можно доделать.
        END
        ELSE
        IF (@OutProdClass = 3)
        BEGIN
            --Ищем ТЛ по ЗЛ
            INSERT INTO #NewMaterials(ID, Name, UnitName, Amount, Number)
            SELECT t.ID, t.[Name], u.Name AS UnitName, 0, @ArrayOfPCCID
            FROM TmcPCC tp
            INNER JOIN Tmc t ON tp.TmcID = t.ID
                AND tp.ProductionCardCustomizeID IN (SELECT ID FROM ProductionCardCustomize WHERE Number LIKE @ArrayOfPCCID)
            INNER JOIN ProductionCardCustomizeMaterials m ON m.ProductionCardCustomizeID IN (SELECT ID FROM ProductionCardCustomize WHERE Number LIKE @ArrayOfPCCID)
              AND m.TmcID = tp.TmcID
            LEFT JOIN Units u ON u.ID = t.UnitID
            WHERE ISNULL(t.IsHidden, 0) = 0
            ORDER BY t.Name
        END
        ELSE
        IF @OutProdClass = 0 -- если входящаая ГП то мы не знаем никак что это Полуфабрикат или ТМЦ из ЗЛ. ПОэтмоу выбираем обе записи. Рулим на интерфейсе
        BEGIN
            --Ищем ПОлуфабрикат по ЗЛ из разбивки ТМЦПцц. Если он не создан - 
            INSERT INTO #NewMaterials(ID, Name, UnitName, Amount, Number)
            SELECT t.ID, t.[Name], u.Name AS UnitName, 0, @ArrayOfPCCID
            FROM Tmc t
            INNER JOIN TmcPCC tp ON tp.TmcID = t.ID 
                AND tp.ProductionCardCustomizeID IN (SELECT ID FROM ProductionCardCustomize WHERE Number LIKE @ArrayOfPCCID)
            LEFT JOIN Units u ON u.ID = t.UnitID
            INNER JOIN TMCAttributes ta ON ta.TMCID = t.ID AND ta.AttributeID = 20
            WHERE ISNULL(t.IsHidden, 0) = 0
            ORDER BY t.Name
            
            INSERT INTO #NewMaterials(ID, Name, UnitName, Amount, Number)
            SELECT p.TmcID, t.[Name], u.Name AS UnitName, 0, p.Number
            FROM ProductionCardCustomize p
            INNER JOIN Tmc t ON t.ID = p.TmcID AND t.Code1C IS NOT NULL
            LEFT JOIN Units u ON u.ID = t.UnitID
            WHERE p.Number LIKE @ArrayOfPCCID
        END
        ELSE
            INSERT INTO #NewMaterials(ID, Name, UnitName, Amount, Number)
            SELECT p.TmcID, t.[Name], u.Name AS UnitName, 0, p.Number
            FROM ProductionCardCustomize p
            INNER JOIN Tmc t ON t.ID = p.TmcID AND t.Code1C IS NOT NULL
            LEFT JOIN Units u ON u.ID = t.UnitID
            WHERE p.Number LIKE @ArrayOfPCCID
    END
END
GO