SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   02.08.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   17.08.2012$*/
/*$Version:    1.00$   $Decription: поиск, связывание элементов хранилища$*/
create PROCEDURE [unknown].[sp_AStorageStructure_Register]
    @RegisterType Int,
    @ChildNumber Varchar(255),
    @ParentNumber Varchar(255),
    @StructureID Int,
    @NewStorageSchemeID Int
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @SearchStructureID Int, @Prefix Varchar(30), @Suffix Varchar(30), @CharCount Int
    DECLARE @SearchTypeID Int, @SearchSchemeID Int

    /*ищем по штрихкоду структуры, и если не находим - вставляем.*/
    IF @RegisterType = 0
    BEGIN
        EXEC sp_AStorageStructure_RegisterSearch @ChildNumber, @SearchStructureID OUTPUT
        SELECT @SearchStructureID
    END
    ELSE
     /*ищем по штрихкоду структуры, второй штрих код - связывающий парент. в @ChildNumber у нас то что связываем,
       в */
    IF @RegisterType = 1
    BEGIN
        /*более одного номера быть не должно. если попадется - значит ошибка в системе. пусть процедура вылетает.
        в параметрах в @StructureID должен быть передан результат - айди прошлого прохода процедуры с @RegisterType = 0 */
        SET @SearchStructureID = NULL

        SELECT @SearchStructureID = ass.ID
        FROM AStorageStructure ass
        WHERE ass.Number = @ParentNumber

        IF @SearchStructureID IS NULL -- значит парент не найден. далее делать нечего - нужно вернуть ошибку на клиент.
        BEGIN
            SELECT -1 -- будет код ошибки - Парент не найден.
        END
        ELSE
        BEGIN
            -- нужно проадейтить - связать нашу Child запись с прошлого прохода с найденной парент записью
            UPDATE AStorageStructure
            SET ParentID = @SearchStructureID
            WHERE ID = @StructureID

            SELECT @StructureID
        END
    END
    ELSE
    /*это операция уточнения каким именно элементом схемы является наш Child */
    IF @RegisterType = 2
    BEGIN
        IF @NewStorageSchemeID IS NOT NULL
        BEGIN
            UPDATE a
            SET a.AStorageSchemeID = @NewStorageSchemeID
            FROM AStorageStructure a
            WHERE a.ID = @StructureID
            SELECT @StructureID
        END
        ELSE
            SELECT @NewStorageSchemeID
    END
END
GO