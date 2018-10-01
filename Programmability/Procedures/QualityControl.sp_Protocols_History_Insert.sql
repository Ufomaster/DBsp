SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   22.01.2015$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   30.03.2015$*/
/*$Version:    1.00$   $Description: Добавление истории редактирования протоколов$*/
CREATE PROCEDURE [QualityControl].[sp_Protocols_History_Insert]
    @EmployeeID Int,
    @ProtocolID Int,
    @OperationType Int  /*0-insert, 1-update, 2-delete*/
AS
BEGIN
	SET NOCOUNT ON
    CREATE TABLE #tblID(ID int)

    DECLARE @ProtocolHistoryID int

    INSERT INTO QualityControl.ProtocolsHistory(OperationType, ModifyEmployeeID, ModifyDate, ProtocolsID, 
    EmployeeID, EmployeeSignDate, EmployeeSpecialistID, EmployeeSpecialistSignDate,
    TypesID, StatusID, PCCID, Number, TmcID, [Result], CustomerID, OrderNumber,
    OrderDate, IncomingCount, WarehouseEmployeeID, StorageStructureID, isDeleted, UnitID, 
    TechCardNumber, TechNeedsCount, ActOfTestCreateDate, ActOfTestCloseDate
  )
    OUTPUT INSERTED.ID INTO #tblID
    SELECT @OperationType, @EmployeeID, GetDate(), @ProtocolID,
        EmployeeID, EmployeeSignDate, EmployeeSpecialistID, EmployeeSpecialistSignDate,
    TypesID, StatusID, PCCID, Number, TmcID, [Result], CustomerID, OrderNumber,
    OrderDate, IncomingCount, WarehouseEmployeeID, StorageStructureID, isDeleted, UnitID, 
    TechCardNumber, TechNeedsCount, ActOfTestCreateDate, ActOfTestCloseDate
    FROM QualityControl.Protocols
    WHERE ID = @ProtocolID

    SELECT @ProtocolHistoryID = ID FROM #tblID

    INSERT INTO [QualityControl].[ProtocolsDetailsHistory](
    [ProtocolHistoryID], [Caption], [ValueToCheck], [FactValue],
    [Checked], [ModifyDate], [SortOrder], [ResultKind],
    [BlockID], [DetailBlockName], ImportanceID)

    SELECT @ProtocolHistoryID, d.[Caption], d.[ValueToCheck], d.[FactValue],
    d.[Checked], d.[ModifyDate], d.[SortOrder], d.[ResultKind],
    d.BlockID, t.[Name], d.ImportanceID
    FROM [QualityControl].ProtocolsDetails d
    LEFT JOIN QualityControl.TypesBlocks t ON t.ID = d.DetailBlockID
    WHERE d.ProtocolID = @ProtocolID

    DROP TABLE #tblID
END
GO