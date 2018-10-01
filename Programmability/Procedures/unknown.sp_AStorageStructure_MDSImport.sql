SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   15.08.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   03.09.2012$*/
/*$Version:    1.00$   $Decription: импорт из МДС$*/
create PROCEDURE [unknown].[sp_AStorageStructure_MDSImport]
    @DocNumber Varchar(255), 
    @MetaData Varchar(255),
    @Box1Number Varchar(255), 
    @Box2Number Varchar(255), 
    @OrderID Int,
    @UserID Int -- пока не нужен
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @SearchDocStructureID Int, @SearchBox1StructureID Int, @SearchBox2StructureID Int,
      @Err Varchar(2000)
    
    /* поиск и добавление в AStorageStructure по номеру */
    EXEC sp_AStorageStructure_RegisterSearch @DocNumber, @SearchDocStructureID OUTPUT
    EXEC sp_AStorageStructure_RegisterSearch @Box1Number, @SearchBox1StructureID OUTPUT
    
    IF @Box2Number IS NOT NULL
        EXEC sp_AStorageStructure_RegisterSearch @Box2Number, @SearchBox2StructureID OUTPUT

    /* Перепроверим наличие. Отсутствует - нам такое не подходит - вылетаем с ошибкой */
    
    IF (@Box2Number IS NOT NULL) AND NOT EXISTS(SELECT * FROM AStorageStructure WHERE [Number] = @Box2Number AND ID = @SearchBox2StructureID)
    BEGIN
        SET @Err = @Box2Number + ' не найден'
        EXEC sp_AStorageStructure_MDSImportLogError @Box2Number, @Err, 1
        RETURN
    END
        
    IF NOT EXISTS(SELECT * FROM AStorageStructure WHERE [Number] = @Box1Number AND ID = @SearchBox1StructureID)
    BEGIN
        SET @Err = @Box1Number + ' не найден'
        EXEC sp_AStorageStructure_MDSImportLogError @Box1Number, @Err, 1
        RETURN
    END
        
    IF NOT EXISTS(SELECT * FROM AStorageStructure WHERE [Number] = @DocNumber AND ID = @SearchDocStructureID)
    BEGIN
        SET @Err = @DocNumber + ' не найден'
        EXEC sp_AStorageStructure_MDSImportLogError @DocNumber, @Err, 1
        RETURN
    END
    
    /* и наконец связывание. Если все гуд, апдейтим связи парентов */
    UPDATE a --документ.
    SET a.ParentID = @SearchBox1StructureID,
        a.OrderID = @OrderID,
        a.MetaData = @MetaData
    FROM AStorageStructure a
    WHERE a.ID = @SearchDocStructureID
    
    IF @Box2Number IS NOT NULL
    BEGIN
        UPDATE a --бокс 1.
        SET a.ParentID = @SearchBox2StructureID
        FROM AStorageStructure a
        WHERE a.ID = @SearchBox1StructureID
    END
END
GO