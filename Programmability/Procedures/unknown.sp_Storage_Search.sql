SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Zapadinskiy Anatoliy$    $Create date:   20.02.2012$
--$Modify:     Zapadinskiy Anatoliy$    $Modify date:   20.02.2012$
--$Version:    1.00$   $Description: Список парентов для выбранного штрих-кода$
create PROCEDURE [unknown].[sp_Storage_Search]
   @BarCode varchar(25),
   @TypeID tinyint
AS
BEGIN
    DECLARE @Type varchar(25)

    IF @TypeID = 0
    BEGIN
        SET @Type = CASE 
                      WHEN Substring(@BarCode,1,1) = 'G' THEN 'sRoom'
                      WHEN Substring(@BarCode,1,1) = 'D' THEN 'sRack'
                      WHEN Substring(@BarCode,1,1) = 'C' THEN 'sS'
                      WHEN Substring(@BarCode,1,1) = 'B' THEN 'sB'
                      WHEN Substring(@BarCode,1,1) = 'A' THEN 'sF'
                      WHEN Substring(@BarCode,1,1) in ('0','1','2','3','4','5','6','7','8','9') THEN 'sD'
                      ELSE ''
                    END
             
        IF @Type <> ''       
            EXEC ('            
              SELECT 
                sroom.Number as RoomNumber,
                srack.Number as RackNumber,
                ss.Number as ShelfNumber,
                sb.Number as BoxNumber,
                sf.Number as FolderNumber,
                sd.Number as DocNumber        
              FROM 
                   StorageRoom as sroom 
                   LEFT JOIN StorageRack as srack on srack.StorageRoomID = sroom.ID  AND sroom.Number <> ''' + @BarCode + '''
                   LEFT JOIN StorageShelf as ss on ss.StorageRackID = srack.ID AND srack.Number <> ''' + @BarCode + '''
                   LEFT JOIN StorageBox as sb on sb.StorageShelfID = ss.ID  AND ss.Number <> ''' + @BarCode + '''
                   LEFT JOIN StorageFolder as sf on sf.StorageBoxID = sb.ID AND sb.Number <> ''' + @BarCode + '''
                   LEFT JOIN StorageDoc as sd on sd.StorageFolderID = sf.ID AND sf.Number <> ''' + @BarCode + '''
              WHERE 
              ' + @Type + '.Number = ''' +@BarCode+ '''   
            ')  
    END
    ELSE
    BEGIN
		SELECT 
          sroom.Number as RoomNumber,
          srack.Number as RackNumber,
          ss.Number as ShelfNumber,
          sb.Number as BoxNumber,
          sf.Number as FolderNumber,
          sd.Number as DocNumber        
        FROM 
             StorageRoom as sroom 
             LEFT JOIN StorageRack as srack on srack.StorageRoomID = sroom.ID
             LEFT JOIN StorageShelf as ss on ss.StorageRackID = srack.ID
             LEFT JOIN StorageBox as sb on sb.StorageShelfID = ss.ID
             LEFT JOIN StorageFolder as sf on sf.StorageBoxID = sb.ID
             LEFT JOIN StorageDoc as sd on sd.StorageFolderID = sf.ID
        WHERE 
            sd.CustomerNumber = @BarCode       
    END
END
GO