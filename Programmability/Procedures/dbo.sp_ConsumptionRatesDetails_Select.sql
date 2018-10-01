SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   25.07.2016$*/
/*$Modify:     Oleynik Yuriy$    $Create date:   06.01.2017$*/
/*$Version:    1.00$   $Description: Просмотр привязок к формуле$*/
CREATE PROCEDURE [dbo].[sp_ConsumptionRatesDetails_Select]
    @ConsumptionRateID Int
AS
BEGIN	
    SELECT -a.ID AS ID, /*ignoring 'ДОВІДНИК ПО МОЖЛИВОСТЯМ ВИРОБНИЦТВА'*/IsNull(CASE WHEN otPPP.ID = 291 THEN null ELSE otPPP.Name END + '->','') + IsNull(otPP.Name + '->','') + otp.Name + ': ' + ot.Name AS Name, IsNull(a.Negation,0) as Negation
    FROM ConsumptionRatesDetails a
         LEFT JOIN ObjectTypes ot ON ot.ID = a.ObjectTypeID
         LEFT JOIN ObjectTypes otP ON otp.ID = ot.ParentID
         LEFT JOIN ObjectTypes otPP ON otPP.ID = otp.ParentID
         LEFT JOIN ObjectTypes otPPP ON otPPP.ID = otPP.ParentID
    WHERE a.ConsumptionRateID = @ConsumptionRateID
    UNION ALL
    SELECT 0, 'ОСНОВНАЯ ПРИВЯЗКА:', null
    FROM ConsumptionRates z
    INNER JOIN ObjectTypesMaterials om ON om.ID = z.ObjectTypesMaterialID
    WHERE z.ID = @ConsumptionRateID
    UNION ALL
    SELECT 1, '    ' + /*ignoring 'ДОВІДНИК ПО МОЖЛИВОСТЯМ ВИРОБНИЦТВА'*/IsNull(CASE WHEN otPPP.ID = 291 THEN null ELSE otPPP.Name END + '->','') + IsNull(otPP.Name + '->','') + otp.Name + ': ' + ot.Name AS Name, 0
    FROM ConsumptionRates a
         INNER JOIN ObjectTypesMaterials om ON om.ID = a.ObjectTypesMaterialID
         LEFT JOIN ObjectTypes ot ON ot.ID = om.ObjectTypeID
         LEFT JOIN ObjectTypes otP ON otp.ID = ot.ParentID
         LEFT JOIN ObjectTypes otPP ON otPP.ID = otp.ParentID
         LEFT JOIN ObjectTypes otPPP ON otPPP.ID = otPP.ParentID
    WHERE a.ID = @ConsumptionRateID
    ORDER BY ID, Name
END
GO