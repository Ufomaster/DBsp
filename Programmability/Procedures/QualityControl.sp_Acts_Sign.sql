SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   07.04.2015$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   17.06.2015$*/
/*$Version:    1.00$   $Description: подписание детальной части акта и перевод акта далее$*/
CREATE PROCEDURE [QualityControl].[sp_Acts_Sign]
    @ID Int
AS
BEGIN
    DECLARE @ActID int, @EmployeeID int
    
    SET NOCOUNT ON;
    
    SELECT @ActID = ad.ActsID
    FROM QualityControl.ActsDetails ad
    WHERE ad.ID = @ID
    
    SELECT @EmployeeID = EmployeeID 
    FROM #CurrentUser

    UPDATE a
    SET a.SignDate = GetDate()
    FROM QualityControl.ActsDetails a
    WHERE a.ID = @ID
    
    --автопереход в стаутс возврата к ПВР
    IF NOT EXISTS (SELECT a.ID FROM QualityControl.ActsDetails a
                   WHERE a.ActsID = (SELECT a.ActsID 
                                     FROM QualityControl.ActsDetails a
                                     WHERE a.ID = @ID)
                       AND a.SignDate IS NULL
                  )
    BEGIN
        UPDATE QualityControl.Acts
        SET StatusID = (SELECT ID FROM QualityControl.ActStatuses WHERE isAfterSign = 1)
        WHERE ID = (SELECT a.ActsID 
                    FROM QualityControl.ActsDetails a
                    WHERE a.ID = @ID)
        SELECT 1 --возвращаем результат - что автопереход был осуществлен.
    END
    ELSE
        SELECT 0 -- результат - перехода небыло.
    EXEC QualityControl.sp_Acts_History_Insert @EmployeeID, @ActID, 1
END
GO