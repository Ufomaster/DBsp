SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   09.12.2015$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   01.02.2016$*/
/*$Version:    1.00$   $Description: Копирование заявок на перевозки$*/
CREATE PROCEDURE [dbo].[sp_ShipmentRequests_Copy]
    @ID int,
    @EmployeeID int
AS
BEGIN
    DECLARE @NewID int
    DECLARE @T TABLE(ID int)
    INSERT INTO dbo.ShipmentRequests(
        CreateDate, StatusID, EmployeeID, ReadyDate,  TimeFrom, TimeTo,
        SenderCustomerID, CustomerID, ContactID, ContactsAdditional, DeparturePoint,  
        ArrivalPoint, [Description], Payer, 
        Comments, OperationKind, ContractData, OrderData, Customer3ID,
        SenderContacts, Conditions, Declaration, TransportTypeID, CustomerTransport,
        DeliveryDate, SenderContactID)
    OUTPUT INSERTED.ID INTO @t    
    SELECT GetDate(), 0, @EmployeeID, GetDate() + 1,  TimeFrom, TimeTo, 
        SenderCustomerID, CustomerID, ContactID, ContactsAdditional, DeparturePoint,  
        ArrivalPoint, [Description], Payer, 
        Comments, OperationKind, ContractData, OrderData, Customer3ID,
        SenderContacts, Conditions, Declaration, TransportTypeID, CustomerTransport,
        dbo.fn_DateCropTime(GetDate() + 1), SenderContactID
    FROM ShipmentRequests sr
    WHERE ID = @ID
    
    SELECT @NewID = ID FROM @T
    
    INSERT INTO dbo.ShipmentRequestsDetails(PCCID, [Name], Amount, UnitID, PackTypeID, 
      Length, Width, Height, PackCount, [Weight], Comments, ShipmentRequestID, TZ, TMCID) 
    SELECT PCCID, [Name], Amount, UnitID, PackTypeID, 
          Length, Width, Height, PackCount, [Weight], Comments, @NewID, TZ, TMCID
    FROM ShipmentRequestsDetails WHERE ShipmentRequestID = @ID

    SELECT @NewID
END
GO