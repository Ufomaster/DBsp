SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Poliatykin Oleksii$	$Create date:   08.09.2017$*/
/*$Modify:     Poliatykin Oleksii$	$Create date:   11.09.2017$*/
/*$Version:    1.00$   $Description: Выборка истории редактирования актов$*/
CREATE PROCEDURE [QualityControl].[sp_Acts_History_Select]
@ActsID int
AS
BEGIN
    SELECT
        a.ActsID,
        a.OperationType,
        S.Name  as Status,
        a.ModifyDate,
        a.Number,
        a.CreateDate,
        a.TestCount,
        a.Description,
        a.PartCount,
        a.CancelComment,
        a.AllSeeAll,
        a.AmountMoney,
        a.FilePath,
        a.ResultComment,
        a.CustomerID,
        eModifier.FullName AS  ModifyEmployeeName,
        eAuthOwner.FullName AS AuthorName,
        ma.Number AS MasterNumber,
        fc.Code as FaultsClassCode,
        fc.[Name] as FaultsClassName,
        fg.[Name] as FaultsGroupsName,
        ISNULL( CAST(frc.Code as Varchar(20)) + ' - ','') + ISNULL(frc.[Name],'')  as FaultsReasonsClassName,
        amr.Name as MainReason
    FROM QualityControl.ActsHistory a
    LEFT JOIN QualityControl.Acts Ma ON Ma.ID = a.MasterActID
    LEFT JOIN vw_Employees eModifier ON eModifier.ID = a.ModifyEmployeeID
    LEFT JOIN vw_Employees eAuthOwner ON eAuthOwner.ID = a.AuthorEmployeeID
    LEFT JOIN QualityControl.ActStatuses s ON s.ID = a.StatusID   
    LEFT JOIN QualityControl.FaultsReasonsClass frc ON frc.ID = a.FaultsReasonsClassID
    LEFT JOIN QualityControl.FaultsGroups fg on fg.ID = frc.FaultsGroupsID
    LEFT JOIN QualityControl.FaultsClass fc on fc.ID = fg.FaultsClassID
    LEFT JOIN QualityControl.ActsMainReason amr on amr.ID = a.MainReasonID
    WHERE a.ActsID = @ActsID
    ORDER BY a.ModifyDate
END
GO