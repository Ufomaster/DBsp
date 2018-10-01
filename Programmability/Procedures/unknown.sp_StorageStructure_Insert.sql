SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   20.02.2012$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   21.02.2012$*/
/*$Version:    1.00$   $Description: Добавление единицы структуры$*/
create PROCEDURE [unknown].[sp_StorageStructure_Insert]
    @RoomCount Int,
    @RackCount Int,
    @ShelfCount Int,
    @BoxCount Int,
    @FolderCount Int,
    @DocCount Int
AS
BEGIN
    SET NOCOUNT ON
    
    DECLARE @i Int, @MaxNum Int

    /*Room*/
    SET @I = @RoomCount
    SELECT @MaxNum = CAST(SUBSTRING(MAX(Number), 2, 25) AS Int)
    FROM StorageRoom
    
    SELECT @MaxNum = ISNULL(@MaxNum, 0)
        
    WHILE @I > 0
    BEGIN
        INSERT INTO StorageRoom(Number)
        SELECT 'G' + RIGHT('000' + CAST(@MaxNum + @I AS Varchar), 3)
        SET @I = @I - 1        
    END
    IF @RoomCount > 0
       INSERT INTO StorageStructureLog([Date], [Text])
       SELECT 
        GetDate(), 
        'Добавлены комнаты с G' + RIGHT('000' + CAST(@MaxNum + 1 AS Varchar), 3) + ' по G' + RIGHT('000' + CAST(@MaxNum + @RoomCount AS Varchar), 3)
    
    /*Rack*/
    SET @I = @RackCount
    SELECT @MaxNum = CAST(SUBSTRING(MAX(Number), 2, 25) AS Int)
    FROM StorageRack
    
    SELECT @MaxNum = ISNULL(@MaxNum, 0)
    
    WHILE @I > 0
    BEGIN
        INSERT INTO StorageRack(Number)
        SELECT 'D' + RIGHT('00000' + CAST(@MaxNum + @I AS Varchar), 5)
        SET @I = @I - 1        
    END
    
    IF @RackCount > 0
       INSERT INTO StorageStructureLog([Date], [Text])
       SELECT 
        GetDate(), 
        'Добавлены стеллажи с D' + RIGHT('00000' + CAST(@MaxNum + 1 AS Varchar), 5) + ' по D' + RIGHT('00000' + CAST(@MaxNum + @RackCount AS Varchar), 5)
    
    /*Shelf*/
    SET @I = @ShelfCount
    SELECT @MaxNum = CAST(SUBSTRING(MAX(Number), 2, 25) AS Int)
    FROM StorageShelf    
    SELECT @MaxNum = ISNULL(@MaxNum, 0)    
    WHILE @I > 0
    BEGIN
        INSERT INTO StorageShelf(Number)
        SELECT 'C' + RIGHT('0000000' + CAST(@MaxNum + @I AS Varchar), 7)
        SET @I = @I - 1        
    END
    
    IF @ShelfCount > 0
       INSERT INTO StorageStructureLog([Date], [Text])
       SELECT  
        GetDate(), 
        'Добавлены полки с C' + RIGHT('0000000' + CAST(@MaxNum + 1 AS Varchar), 7) + ' по C' + RIGHT('0000000' + CAST(@MaxNum + @ShelfCount AS Varchar), 7)
    
    /*Box*/
    SET @I = @BoxCount
    SELECT @MaxNum = CAST(SUBSTRING(MAX(Number), 2, 25) AS Int)
    FROM StorageBox
    SELECT @MaxNum = ISNULL(@MaxNum, 0)
    WHILE @I > 0
    BEGIN
        INSERT INTO StorageBox(Number)
        SELECT 'B' + RIGHT('0000000' + CAST(@MaxNum + @I AS Varchar), 7)
        SET @I = @I - 1        
    END
    
    IF @BoxCount > 0
       INSERT INTO StorageStructureLog([Date], [Text])
       SELECT 
        GetDate(), 
        'Добавлены коробки с B' + RIGHT('0000000' + CAST(@MaxNum + 1 AS Varchar), 7) + ' по B' + RIGHT('0000000' + CAST(@MaxNum + @BoxCount AS Varchar), 7)

    /*Folder*/
    SET @I = @FolderCount
    SELECT @MaxNum = CAST(SUBSTRING(MAX(Number), 2, 25) AS Int)
    FROM StorageFolder
    SELECT @MaxNum = ISNULL(@MaxNum, 0)
    WHILE @I > 0
    BEGIN
        INSERT INTO StorageFolder(Number)
        SELECT 'A' + RIGHT('0000000' + CAST(@MaxNum + @I AS Varchar), 7)
        SET @I = @I - 1        
    END
    
    IF @FolderCount > 0
       INSERT INTO StorageStructureLog([Date], [Text])
       SELECT 
        GetDate(), 
        'Добавлены папки с A' + RIGHT('0000000' + CAST(@MaxNum + 1 AS Varchar), 7) + ' по A' + RIGHT('0000000' + CAST(@MaxNum + @FolderCount AS Varchar), 7)
        
    /*Documents*/
    SET @I = @DocCount
    SELECT @MaxNum =CAST(SUBSTRING(MAX(Number), 2, 25) AS Int)
    FROM StorageDoc
    SELECT @MaxNum = ISNULL(@MaxNum, 0)
    WHILE @I > 0
    BEGIN
        INSERT INTO StorageDoc(Number)
        SELECT RIGHT('000000000' + CAST(@MaxNum + @i AS Varchar), 9)
        SET @I = @I - 1
    END

    IF @DocCount > 0
       INSERT INTO StorageStructureLog([Date], [Text])
       SELECT 
        GetDate(),
        'Добавлены документы с ' + RIGHT('000000000' + CAST(@MaxNum + 1 AS Varchar), 9) + ' по ' + RIGHT('000000000' + CAST(@MaxNum + @DocCount AS Varchar), 9)
END
GO