SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$	$Create date:   10.05.2011$
--$Modify:     Oleynik Yuriy$	$Modify date:   10.05.2011$
--$Version:    1.00$   $Description: апдейт инфо типа объекта$
CREATE PROCEDURE [dbo].[sp_TmcTree_InfoUpdate]
    @TreeID Int,
    @NodeState Bit,
    @UserID Int
AS
BEGIN
    SET NOCOUNT ON
    IF EXISTS(SELECT * FROM ObjectTypesInfo WHERE UserID = @UserID AND ObjectTypeID = @TreeID)
        UPDATE ObjectTypesInfo
        SET NodeState = @NodeState
        WHERE UserID = @UserID AND ObjectTypeID = @TreeID
    ELSE
       INSERT INTO ObjectTypesInfo(NodeState, UserID, ObjectTypeID)
       SELECT @NodeState, @UserID, @TreeID       
END
GO