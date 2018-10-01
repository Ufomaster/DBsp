SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$    $Create date:   18.08.2015$
--$Modify:     Yuriy Oleynik$    $Modify date:   18.08.2015$
--$Version:    1.00$   $Decription: vw_StorageStructure
CREATE VIEW [manufacture].[vw_StorageStructure]
AS
  SELECT 
      ss.ID,
      ss.IP,
      ss.[Name],
      ss.NodeExpanded,
      ss.NodeImageIndex,
      ss.NodeLevel,
      ss.ParentID,
      ss.NodeOrder,
      ss.HiddenForSelect,      
      dbo.fn_GetSystemSetStringValue(6) + RIGHT('00000' + CAST(ss.ID AS VARCHAR), 5) AS WPCode
  FROM manufacture.StorageStructure ss
GO