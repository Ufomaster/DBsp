SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleksii Poliatykin$    $Create date:   28.07.2017$*/
/*$Modify:     Oleksii Poliatykin$    $Create date:   28.07.2017$*/
/*$Version:    1.00$   $Decription: Сохраниение подчиненных таблиц акта*/

create PROCEDURE [QualityControl].[sp_Acts_All_SaveProperties]
@id  int
AS
BEGIN
    BEGIN TRAN
        EXEC QualityControl.sp_ActsDetails_SaveProperties @ID
        EXEC QualityControl.sp_ActsReasons_SaveProperties @ID
        EXEC QualityControl.sp_ActsTasks_SaveProperties @ID
        EXEC QualityControl.sp_ActsCCIDs_SaveProperties @ID
        EXEC QualityControl.sp_ActsFiles_SaveProperties @ID
        EXEC QualityControl.sp_ActsZLs_SaveProperties @ID
    COMMIT TRAN
END
GO