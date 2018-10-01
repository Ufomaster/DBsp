CREATE TABLE [sync].[1CNomenclature] (
  [ID] [int] IDENTITY,
  [ModifyDate] [datetime] NOT NULL,
  [UserCode1C] [varchar](30) NULL,
  [Code1C] [varchar](36) NOT NULL,
  [ParentCode1C] [varchar](36) NULL,
  [Name] [varchar](255) NULL,
  [ShortName] [varchar](255) NULL,
  [Type] [int] NOT NULL,
  [OperationType] [int] NOT NULL,
  [UnitName] [varchar](20) NULL,
  [UnitCode1C] [varchar](36) NULL,
  [ProdCardNumber] [varchar](10) NULL,
  CONSTRAINT [PK_Sync1CNomenclature_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'sync.[1CNomenclature].ModifyDate'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [TR_Sync1CNomenclature_INS] ON [sync].[1CNomenclature]

FOR INSERT
AS
BEGIN
    --RAISERROR('spekler error', 16, 1)
    --SpeklerUser must impersonate Sync1C user
    EXECUTE AS USER = 'SpeklerUser'
    SET NOCOUNT ON
	--SET XACT_ABORT ON
    DECLARE @Err Int, @UnitID Int, @EmployeeID Int, @ObjectTypeID Int, @StatusErrorText Varchar(MAX), @TmcID Int, 
        @Code1C Varchar(36), @ParentCode1C Varchar(36), @Name Varchar(255), @ShortName Varchar(255), @SyncID Int,
        @OperationType Int, @Type Int, @UnitCode1C Varchar(36), @UnitName Varchar(255), @UserCode1C Varchar(30),
        @ModifyDate datetime, @Catched bit, @Level int, @NewLevel int, @ProdCardNumber varchar(10)
    DECLARE @T TABLE(ID Int, ErrorText Varchar(MAX))
    DECLARE @Tmc TABLE(ID Int)
    DECLARE @Out TABLE(ID Int)
    DECLARE @XMLSchema Xml, @NodeImageIndex Int, @ParentID Int, @ErrorText Varchar(MAX), @ID Int, @Order Int
    DECLARE @NewParentID Int, @OldParentID Int, @NodeOrder Int;
    --00000000-0000-0000-0000-000000000000 код группы нашего рут уровня. нул короче.
    SET @EmployeeID = 26

/*    INSERT INTO dbo.Sync1CNomenclatureLog(ModifyDate, Code1C, ParentCode1C, [Name], ShortName, [Type], OperationType, UnitName, UnitCode1C, [Status], StatusError, UserCode1C)
    SELECT ModifyDate, Code1C, ParentCode1C, [Name], ShortName, [Type], OperationType, UnitName, UnitCode1C, 
         CASE WHEN ISNULL(@StatusErrorText, '') = '' THEN 0 ELSE 1 END, @StatusErrorText, UserCode1C
    FROM INSERTED*/

    DECLARE #Cur CURSOR FOR SELECT ID FROM INSERTED ORDER BY ID
    OPEN #Cur
    FETCH NEXT FROM #Cur INTO @SyncID
    WHILE @@FETCH_STATUS = 0
    BEGIN
        DELETE FROM @T
        DELETE FROM @Tmc
        DELETE FROM @Out
        --обнулить переменные .
        SELECT @ObjectTypeID = NULL, @TmcID = NULL, @XMLSchema = NULL, @NodeImageIndex = NULL, 
            @ParentID = NULL, @ID = NULL, @Order = NULL, @NewParentID = NULL, 
            @OldParentID = NULL, @NodeOrder = NULL, @ModifyDate = NULL,
            @Catched = 0

        SELECT
            @Code1C = Code1C, 
            @ModifyDate = ModifyDate,
            @ParentCode1C = CASE WHEN ParentCode1C = '00000000-0000-0000-0000-000000000000' THEN NULL ELSE ParentCode1C END, 
            @Name = CASE WHEN [Name] IS NULL THEN ShortName ELSE [Name] END, 
            @OperationType = OperationType, 
            @ShortName = ShortName, 
            @Type = [Type],
            @UnitName = UnitName,
            @UnitCode1C = RTRIM(LTRIM(UnitCode1C)),
            @UserCode1C = RTRIM(LTRIM(UserCode1C)),
            @ProdCardNumber = ProdCardNumber
        FROM INSERTED
        WHERE ID = @SyncID

        --если тип = группа
        IF @Type = 1
        BEGIN
            BEGIN TRY
-- SET @Err = 11/0
                SELECT @NodeImageIndex = 0,
                    @XMLSchema = '<PropertyList>'+
                                  '<Props><ID>1</ID><FieldName>fld_1</FieldName><Name>Краткое наименование</Name><TypeID>1</TypeID><PageName>Основная</PageName>1</Props>'+
                                 '</PropertyList>';
                --ищем по коду 1с запись или по именованию, видимому коду 1с, но среди ОТ с атрибутом 13.
                SELECT TOP 1 @ID = ID FROM ObjectTypes WHERE Code1C = @Code1C;
                IF @ID IS NULL
                    SELECT TOP 1 @ID = ot.ID
                    FROM ObjectTypes ot
                    INNER JOIN ObjectTypesAttributes ota ON ota.ObjectTypeID = ot.ID AND ota.AttributeID = 13
                    WHERE ot.Code1C IS NULL AND (ot.UserCode1C = @UserCode1C OR ot.[Name] = @Name);

                --в таблицу Синх не может быть из 1с добавлена запись с парентом, которого нет в 1с. поэтому смело ищем и если не находим - кидаем в корень(если не тип опер.3).
                SELECT TOP 1 @ParentID = ID FROM ObjectTypes WHERE Code1C = @ParentCode1C;

                IF @ParentID IS NULL
                    SET @ParentID = -1;

                --проверить, если удаление, удаляем, иначе игнорируем тип и пробуем искать.
                IF @OperationType = 2
                BEGIN
                    --через TmcTree_Delete нельзя. поэтому ручками.
                    SELECT @ParentID = ParentID, @Order = NodeOrder FROM ObjectTypes WHERE ID = @ID
                    -- поискать связанные тмц, если нету связи - можно удалить.
                    IF NOT EXISTS(SELECT ID FROM Tmc WHERE ObjectTypeID = @ID) AND NOT EXISTS(SELECT ID FROM ObjectTypes WHERE ParentID = @ID)
                    BEGIN
                        DELETE FROM ObjectTypes WHERE ID = @ID

                        UPDATE ObjectTypes
                        SET NodeOrder = NodeOrder - 1
                        WHERE ParentID = @ParentID AND NodeOrder > @Order
                    END
                    ELSE
                    BEGIN --не можем удалить, прячем с глаз - запплатка.
                        UPDATE ObjectTypes
                        SET IsHidden = 1
                        WHERE (ID = @ID) OR ID IN (SELECT ID FROM dbo.fn_ObjectTypesNode_Select(@ID))
                        --переопределяем операцию как OutOfSync
                        SET @OperationType = 3
                    END

                    INSERT INTO @Out(ID)
                    SELECT @ID
                END
                ELSE
                IF @OperationType = 3 --устарело, пока оставим.
                BEGIN
                    UPDATE ObjectTypes
                    SET IsHidden = 1
                    WHERE (ID = @ID) OR ID IN (SELECT ID FROM dbo.fn_ObjectTypesNode_Select(@ID))
                END
                ELSE
                BEGIN
                    --если не нашелся по коду 1С - вставка,
                    IF @ID IS NULL
                    BEGIN
                        INSERT INTO @Out(ID)
                        EXEC sp_TmcTree_Insert @ParentID, 0, @Name, 1, @XMLSchema, @NodeImageIndex, 1, NULL, @Code1C, @UserCode1C
                        
                        SELECT @ID = ID FROM @Out;
                        
                        --вставка атрибуты
                        INSERT INTO ObjectTypesAttributes(ObjectTypeID, AttributeID)
                        SELECT @ID, 13 --Номенклатура 1С
                        UNION
                        SELECT @ID, 1 --rashodnik
                        UNION 
                        SELECT @ID, AttributeID FROM ObjectTypesAttributes 
                        WHERE ObjectTypeID = @ParentID AND AttributeID NOT IN(13, 1)
                    END
                    --Инчае, 1- апейдим. 2- могло произойти перемещение
                    ELSE
                    BEGIN
                        INSERT INTO @Out(ID)
                        SELECT @ID

                        --вдруг поменялось что
                        UPDATE ObjectTypes
                        SET [Name] = @Name, IsHidden = 0, UserCode1C = @UserCode1C, Code1C = CASE WHEN Code1C IS NULL THEN @Code1C ELSE Code1C END
                        WHERE ID = @ID;

                        --проверим, было ли перемещение.
                        --новый родитель
                        SELECT @NewParentID = ID FROM ObjectTypes WHERE Code1C = @ParentCode1C;
                        --старый родитель, найдем текущий уровень.
                        SELECT @OldParentID = ParentID, @NodeOrder = NodeOrder, @Level = [Level] FROM ObjectTypes WHERE ID = @ID;
                        --если переместилось
                        IF ISNULL(@OldParentID, 0) <> ISNULL(@NewParentID, 0)
                        BEGIN
                            --сдвигаем старый ордер
                            UPDATE a
                            SET a.NodeOrder = a.NodeOrder - 1
                            FROM ObjectTypes a
                            WHERE a.ParentID = @OldParentID AND a.NodeOrder > @NodeOrder;

                            --ложим запись в конец списка
                            UPDATE a
                            SET a.NodeOrder = b.NodeOrder,
                                a.[Level] = CASE WHEN b.[Level] = 0 AND @NewParentID IS NOT NULL THEN (SELECT [Level] + 1 FROM ObjectTypes WHERE ID = @NewParentID) ELSE b.[Level] END,
                                a.ParentID = @NewParentID,
                                a.IsHidden = 0
                            FROM ObjectTypes a
                            INNER JOIN (SELECT ISNULL(MAX(NodeOrder),0) + 1 AS NodeOrder, ISNULL(MAX([Level]), 0) AS [Level], @ID AS ID
                                        FROM ObjectTypes
                                        WHERE (@NewParentID IS NOT NULL AND ParentID = @NewParentID) OR (@NewParentID IS NULL AND ParentID IS NULL)) b ON b.ID = a.ID
                            WHERE a.ID = @ID;
                        END
                        -- "новый" уровень
                        SELECT @NewLevel = [Level] + 1 FROM ObjectTypes WHERE ID = @NewParentID

                        --все дочерние ноды покажем, вычислим им новый левел, ели было перемещение
                        --всем уровням вложенных элементов, нужно прибавить "сдвиг уровней" старого и нового положения
                        UPDATE ObjectTypes
                        SET IsHidden = 0,
                            [Level] = [Level] + (ISNULL(@NewLevel, 0) - ISNULL(@Level, 0))
                        WHERE ID IN (SELECT ID FROM dbo.fn_ObjectTypesNode_Select(@ID))
                    END
                END

                INSERT INTO @T(ID, ErrorText)
                SELECT ID, '' FROM @Out
                
/*                IF NOT EXISTS(SELECT ID FROM ObjectTypes WHERE Code1C = @Code1C)
                BEGIN
                    SET @StatusErrorText = 'Запись с кодом ' + @Code1C + ' (' + @UserCode1C + ') после обработки триггером отсутствует в ObjectTypes '
                END*/
            END TRY
            BEGIN CATCH
                SET @Catched = 1
                SELECT @StatusErrorText = CAST(ERROR_NUMBER() AS Varchar(10)) + ': ' + ERROR_MESSAGE() + 
                                          ISNULL(' Procedure ' + ERROR_PROCEDURE() + ',', '') + 
                                          ' Line ' + CAST(ERROR_LINE() AS Varchar(10))
                                      + ', XACT_STATE ' + CAST(XACT_STATE() AS Varchar(10))
                                      + ', ERROR_SEVERITY ' + CAST(ERROR_SEVERITY() AS Varchar(10))
                                      + ', TRANCOUNT ' + CAST(@@TRANCOUNT as Varchar(10))
                IF (@@TRANCOUNT > 0) AND (ISNULL(@StatusErrorText, '') <> '')
                    ROLLBACK TRANSACTION;
            END CATCH
            --логируем
            INSERT INTO sync.[1CNomenclatureLog](ID, ModifyDate, Code1C, ParentCode1C, [Name], ShortName, [Type], OperationType, UnitName, UnitCode1C, [Status], StatusError, UserCode1C)
            SELECT @SyncID, @ModifyDate, @Code1C, @ParentCode1C, @Name, @ShortName, @Type, @OperationType, @UnitName, @UnitCode1C, 
                 CASE WHEN ISNULL(@StatusErrorText, '') = '' THEN 0 ELSE 1 END, @StatusErrorText, @UserCode1C
            --удаляем запись, фактически пометка что обработана запись.
            DELETE FROM sync.[1CNomenclature] WHERE ID = @SyncID

            --если была ошибка - райзим ошибку наверх
            IF @Catched = 1 AND (ISNULL(@StatusErrorText, '') <> '')
                RAISERROR(@StatusErrorText, 16, 1)
            SELECT @ObjectTypeID = ID FROM @t
        END
        ELSE
        --Если тип - номенклатура - постим ТМЦ
        IF @Type = 0
        BEGIN
            BEGIN TRY                
                --1) Check Units
                SELECT @UnitID = ID FROM Units WHERE Code1C = @UnitCode1C
                --если не нашли
                IF @UnitID IS NULL AND (@UnitCode1C IS NOT NULL)
                BEGIN
                    SELECT @UnitID = ID FROM Units WHERE [Name] = @UnitName /*AND Code1C IS NULL*/ -- пусть с одинаковыми кодами - переписывает
                    IF @UnitID IS NULL -- юнита небыло вообще
                        INSERT INTO Units(NAME, Code1C)
                        SELECT @UnitName, @UnitCode1C
                    ELSE
                        UPDATE Units  --юнит есть, но кода 1с у него нету.
                        SET [Name] = @UnitName, Code1C = @UnitCode1C
                        WHERE [Name] = @UnitName AND Code1C IS NULL
                    SELECT @UnitID = ID FROM Units WHERE Code1C = @UnitCode1C
                END
                --2) TMC
                --ищем родителя ТМЦ
                SELECT TOP 1 @ObjectTypeID = ot.ID FROM ObjectTypes ot WHERE ot.Code1C = @ParentCode1C;         
                --Ищем ТМЦ по коду 1с, если не найден - ищем в номенклатуре по наимениванию - только по тмц с атрибутом 13
                SELECT @TmcID = ID--, @OldParentID = ObjectTypeID
                FROM Tmc
                WHERE Code1C = @Code1C                
                IF @TmcID IS NULL
                    SELECT @TmcID = t.ID
                    FROM Tmc t
                    INNER JOIN TMCAttributes ta ON ta.AttributeID = 13 AND ta.TMCID = t.ID
                    WHERE t.Code1C IS NULL AND (t.UserCode1C = @UserCode1C OR t.[Name] = @Name);

                IF ((@OperationType = 0) OR (@OperationType = 1)) AND (@ObjectTypeID IS NOT NULL) AND (@TmcID IS NULL)
                BEGIN
                    --Insert TMC
                    INSERT INTO dbo.Tmc(XMLData, ObjectTypeID, RegistrationDate, [Name], DeadCount, PartNumber, Code1C, UserCode1C, UnitID, ProdCardNumber)
                    OUTPUT INSERTED.ID INTO @Tmc
                    SELECT
                      CASE WHEN @ShortName IS NOT NULL THEN
                      '<TMC>' +
                      '<Props><ID>1</ID><FieldName>fld_1</FieldName><Value>' +  RTRIM(LTRIM(REPLACE(@ShortName, '&', '&amp;'))) + '</Value></Props>' +
                      '</TMC>'
                      ELSE NULL
                      END,
                      @ObjectTypeID, GetDate(),  RTRIM(LTRIM(@Name)), 0, NULL, @Code1C, @UserCode1C, @UnitID, @ProdCardNumber

                    --вставка атрибуты
                    INSERT INTO TMCAttributes(TMCID, AttributeID)
                    SELECT ID, 13
                    FROM @Tmc
                    UNION ALL
                    SELECT ID, 1
                    FROM @Tmc

                    --вставка линки
                    INSERT INTO TmcObjectLinks (ObjectID, TmcID)
                    SELECT @ObjectTypeID, ID
                    FROM @Tmc
                END
                ELSE
                IF (@OperationType = 1) OR ((@TmcID IS NOT NULL) AND (@OperationType = 0)) --UPDATE
                BEGIN                            
                    IF @ObjectTypeID IS NULL -- объект не найден по коду 1с - скрываем ТМЦ.
                    BEGIN
                        UPDATE Tmc
                        SET IsHidden = 1, Code1C = CASE WHEN Code1C IS NULL THEN @Code1C ELSE Code1C END
                        WHERE ID = @TmcID
                    END
                    ELSE
                    BEGIN -- апдейтим данные ТМЦ и связи.
                        -- если произошла смена группы
                        IF NOT EXISTS(SELECT ID FROM TMC WHERE ID = @TmcID AND ObjectTypeID = @ObjectTypeID)
                        BEGIN
                            DELETE FROM TmcObjectLinks --1 сзвяь будет, если даже руками что-то добавили - чистим все.
                            WHERE TmcID = @TmcID

                            --вставка линки - 1 связь
                            INSERT INTO TmcObjectLinks (ObjectID, TmcID)
                            SELECT @ObjectTypeID, @TmcID
                        END                    

                        UPDATE Tmc
                        SET
                            [Name] = RTRIM(LTRIM(@Name)),
                            XMLData =
                                CASE WHEN @ShortName IS NOT NULL THEN
                                '<TMC>' +
                                '<Props><ID>1</ID><FieldName>fld_1</FieldName><Value>' +  RTRIM(LTRIM(REPLACE(@ShortName, '&', '&amp;'))) + '</Value></Props>' +
--                               '<Props><ID>1</ID><FieldName>fld_1</FieldName><Value>' + @ShortName + '</Value></Props>' +
                                '</TMC>'
                                ELSE NULL
                                END,
                            IsHidden = 0,
                            ObjectTypeID = @ObjectTypeID,
                            UserCode1C = @UserCode1C,
                            Code1C = CASE WHEN Code1C IS NULL THEN @Code1C ELSE Code1C END,
                            UNitID = @UnitID,
                            ProdCardNumber = @ProdCardNumber
                        WHERE ID = @TmcID
                    END
                END
                ELSE
                IF (@OperationType = 2) OR (@OperationType = 3) ---DELETE OR - HIDE
                BEGIN
/*                    IF NOT EXISTS(SELECT ID FROM InvoiceDetail WHERE TmcID = @TmcID) AND
                       NOT EXISTS(SELECT ID FROM ObjectTypesMaterials WHERE TmcID = @TmcID) AND
                       NOT EXISTS(SELECT ID FROM ProductionCardCustomizeDetails WHERE TmcID = @TmcID) AND
                       NOT EXISTS(SELECT ID FROM ProductionCardCustomizeMaterials WHERE TmcID = @TmcID) AND
                       --NOT EXISTS(SELECT ID FROM ReceiveDeliveryRequestsDetails WHERE TmcID = @TmcID) AND
                       NOT EXISTS(SELECT ID FROM Equipment WHERE TmcID = @TmcID) AND
                       NOT EXISTS(SELECT ID FROM SolutionsDeclared WHERE TmcID = @TmcID) AND
                       NOT EXISTS(SELECT ID FROM SolutionTmc WHERE TmcID = @TmcID)
                    BEGIN
                        DELETE FROM Tmc WHERE ID = @TmcID
                    END
                    ELSE*/
                        UPDATE Tmc
                        SET IsHidden = 1, Code1C = CASE WHEN Code1C IS NULL THEN @Code1C ELSE Code1C END
                        WHERE ID = @TmcID
                END

/*                IF NOT EXISTS(SELECT ID FROM Tmc WHERE Code1C = @Code1C)
                BEGIN
                    SET @StatusErrorText = 'Запись с кодом ' + @Code1C + ' (' + @UserCode1C + ') после обработки триггером отсутствует в Tmc '
                END*/
                
/*            IF @UserCode1C = 'CB16164'
                SET @Err = 11/0*/
                
            END TRY
            BEGIN CATCH
                SET @Catched = 1
                SELECT @StatusErrorText = CAST(ERROR_NUMBER() AS Varchar(10)) + ': ' + ERROR_MESSAGE() + 
                                          ISNULL(' Procedure ' + ERROR_PROCEDURE() + ',', '') + 
                                          ' Line ' + CAST(ERROR_LINE() AS Varchar(10))
                                      + ', XACT_STATE ' + CAST(XACT_STATE() AS Varchar(10))
                                      + ', ERROR_SEVERITY ' + CAST(ERROR_SEVERITY() AS Varchar(10))
                                      + ', TRANCOUNT ' + CAST(@@TRANCOUNT as Varchar(10))
                IF (@@TRANCOUNT > 0) AND (ISNULL(@StatusErrorText, '') <> '')
                    ROLLBACK TRANSACTION;
            END CATCH
            --логируем
            INSERT INTO sync.[1CNomenclatureLog](ID, ModifyDate, Code1C, ParentCode1C, [Name], ShortName, 
                [Type], OperationType, UnitName, UnitCode1C, [Status], StatusError, UserCode1C, ProdCardNumber)
            SELECT @SyncID, @ModifyDate, @Code1C, @ParentCode1C, @Name, @ShortName, 
                @Type, @OperationType, @UnitName, @UnitCode1C, 
                 CASE WHEN ISNULL(@StatusErrorText, '') = '' THEN 0 ELSE 1 END, 
                 @StatusErrorText, @UserCode1C, @ProdCardNumber
            --удаляем запись, фактически пометка что обработана запись.
            DELETE FROM sync.[1CNomenclature] WHERE ID = @SyncID
            --если была ошибка - райзим ошибку наверх
            IF @Catched = 1 AND (ISNULL(@StatusErrorText, '') <> '')
                RAISERROR(@StatusErrorText, 16, 1)
       END

       FETCH NEXT FROM #Cur INTO @SyncID
    END
    CLOSE #Cur
    DEALLOCATE #Cur
END
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'sync', 'TABLE', N'1CNomenclature', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата', 'SCHEMA', N'sync', 'TABLE', N'1CNomenclature', 'COLUMN', N'ModifyDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Видимый пользователю код 1с', 'SCHEMA', N'sync', 'TABLE', N'1CNomenclature', 'COLUMN', N'UserCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Уникальный идентификатор 1с', 'SCHEMA', N'sync', 'TABLE', N'1CNomenclature', 'COLUMN', N'Code1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор родительской группы, которой подчинена запись', 'SCHEMA', N'sync', 'TABLE', N'1CNomenclature', 'COLUMN', N'ParentCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Полное наименование', 'SCHEMA', N'sync', 'TABLE', N'1CNomenclature', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Краткое наименование', 'SCHEMA', N'sync', 'TABLE', N'1CNomenclature', 'COLUMN', N'ShortName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип записи (0-группа, 1-номенклатура)', 'SCHEMA', N'sync', 'TABLE', N'1CNomenclature', 'COLUMN', N'Type'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип операции (0-Insert, 1-Update, 2-Delete, 3-OutOfSync)', 'SCHEMA', N'sync', 'TABLE', N'1CNomenclature', 'COLUMN', N'OperationType'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'наименование единицы измерения', 'SCHEMA', N'sync', 'TABLE', N'1CNomenclature', 'COLUMN', N'UnitName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Уникальный идентификатор 1с единицы измерения', 'SCHEMA', N'sync', 'TABLE', N'1CNomenclature', 'COLUMN', N'UnitCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'№ заказного листа', 'SCHEMA', N'sync', 'TABLE', N'1CNomenclature', 'COLUMN', N'ProdCardNumber'
GO