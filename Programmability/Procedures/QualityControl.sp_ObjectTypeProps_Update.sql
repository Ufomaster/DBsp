SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   13.10.2014$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   30.03.2015$*/
/*$Version:    1.00$   $Description: Редактирование характеристики группы$*/
CREATE PROCEDURE [QualityControl].[sp_ObjectTypeProps_Update]
    @ID int, 
    @Name varchar(1000),
    @ResultKind tinyint,
    @ValueToCheck varchar(1000),
    @AssignedToQC bit,
    @AssignedToTestAct bit,
    @ImportanceID int
AS
BEGIN
	SET NOCOUNT ON
    UPDATE QualityControl.ObjectTypeProps
    SET 
        Name = @Name, 
        ResultKind = @ResultKind, 
        ValueToCheck = @ValueToCheck, 
        AssignedToQC = @AssignedToQC, 
        AssignedToTestAct = @AssignedToTestAct,
        ImportanceID = @ImportanceID
    WHERE ID = @ID
END
GO