SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Zapadinskiy Anatoliy$    $Create date:   20.02.2012$
--$Modify:     Zapadinskiy Anatoliy$    $Modify date:   20.02.2012$
--$Version:    1.00$   $Description: Список Childov для выбранного штрих-кода$
create PROCEDURE [unknown].[sp_Storage_SearchChild]
   @BarCode varchar(25)
AS
BEGIN
    DECLARE @Type varchar(25)

    SET @Type = CASE 
                  WHEN Substring(@BarCode,1,1) = 'G' THEN 'sRoom'
                  WHEN Substring(@BarCode,1,1) = 'D' THEN 'sRack'
                  WHEN Substring(@BarCode,1,1) = 'C' THEN 'sS'
                  WHEN Substring(@BarCode,1,1) = 'B' THEN 'sB'
                  WHEN Substring(@BarCode,1,1) = 'A' THEN 'sF'
                  WHEN Substring(@BarCode,1,1) in ('0','1','2','3','4','5','6','7','8','9') THEN 'sD'
                  ELSE ''
                END
                
IF @Type = 'sRoom'
      SELECT 
        'Стеллаж' as Type,
        srack.Number as Number   
      FROM 
           StorageRoom as sroom 
           INNER JOIN StorageRack as srack on srack.StorageRoomID = sroom.ID           
      WHERE 
        sroom.Number = @BarCode

IF @Type = 'sRack'
      SELECT 
        'Полка' as Type,
        ss.Number as Number   
      FROM        
           StorageRack as srack
           INNER JOIN StorageShelf as ss on ss.StorageRackID = srack.ID
      WHERE 
        srack.Number = @BarCode

IF @Type = 'sS'
      SELECT 
        'Коробка' as Type,
        sb.Number as Number   
      FROM 
          StorageShelf as ss 
          INNER JOIN StorageBox as sb on sb.StorageShelfID = ss.ID           
      WHERE 
        ss.Number = @BarCode

IF @Type = 'sB'
      SELECT 
        'Папка' as Type,
        sf.Number as Number   
      FROM 
          StorageBox as sb 
          INNER JOIN StorageFolder as sf on sf.StorageBoxID = sb.ID
      WHERE 
        sb.Number = @BarCode
      
IF @Type = 'sF'
      SELECT 
        'Документ' as Type,
        sd.Number as Number   
      FROM 
          StorageFolder as sf
          INNER JOIN StorageDoc as sd on sd.StorageFolderID = sf.ID           
      WHERE 
        sf.Number = @BarCode
        
IF @Type = 'sD'
      SELECT 
        null as Type,
        null as Number   

END
GO