SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   22.11.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   27.02.2015$*/
/*$Version:    1.00$   $Description: удаление протоколов$*/
CREATE PROCEDURE [QualityControl].[sp_Protocols_Delete]
    @ID Int
AS
BEGIN      
        IF EXISTS(SELECT a.ID FROM QualityControl.Protocols a
                  INNER JOIN QualityControl.TypesStatuses s ON s.ID = a.StatusID AND s.IsFirst = 1
                   WHERE a.ID = @ID) 
        BEGIN
            --удаляем черновики
            DELETE a 
            FROM QualityControl.Protocols a
            INNER JOIN QualityControl.TypesStatuses s ON s.ID = a.StatusID AND s.IsFirst = 1
            WHERE a.ID = @ID
        END
        ELSE
            RAISERROR ('Удаление протокола в статусе отличном от "Черновик" запрещено', 16, 1)         
            
    --если не удалилось, то поставится флаг удалённости.
/*    UPDATE QualityControl.Protocols
    SET isDeleted = 1
    WHERE ID = @ID*/
END
GO