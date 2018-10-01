SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$	$Create date:   23.02.2011$
--$Modify:     Oleynik Yuriy$	$Modify date:   30.10.2012$
--$Version:    1.00$   $Description: Добавление типа объекта$
CREATE PROCEDURE [dbo].[sp_TmcTree_Insert]
    @ActiveTreeID Int,
    @isCopy Int,
    @Name Nvarchar(100),
    @Type Int,
    @XMLSchema Xml, 
    @NodeImageIndex Int,
    @Status Int,
    @ViewScheme Nvarchar(MAX),
    @Code1C Varchar(36) = NULL,
    @UserCode1C Varchar(30) =  NULL
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	DECLARE @Err Int
    DECLARE @t TABLE(ID Int)
    DECLARE @NewID Int

	BEGIN TRAN
	BEGIN TRY    
        DECLARE @Order Int, @ParentID Int, @Level Int
        CREATE TABLE #t(ID Int)            
        SET @ParentID = NULL
        SET @Order = NULL
        SELECT @Level = [Level] FROM ObjectTypes ot WHERE ot.ID = @ActiveTreeID

        --Анализ
        IF @isCopy = 0 AND @ActiveTreeID <> -1 -- если не копирование
        BEGIN
            IF EXISTS(SELECT * FROM ObjectTypes ot WHERE ot.ParentID = @ActiveTreeID) -- если есть внутри записи, вставка в конец
            BEGIN
                SELECT @ParentID = ot.ParentID, @Order = ISNULL(MAX(ot.NodeOrder), 0)
                FROM dbo.ObjectTypes ot
                WHERE ot.ParentID = @ActiveTreeID
                GROUP BY ot.ParentID
            END
            ELSE
            BEGIN --если нет записей внутри
                SELECT @ParentID = @ActiveTreeID, @Order = 0
            END
        END
        ELSE
        BEGIN
            SELECT @ParentID = ISNULL(ot.ParentID, 0)
            FROM dbo.ObjectTypes ot 
            WHERE ot.ID = @ActiveTreeID
        END

        --Вставка
        IF @ParentID IS NULL AND @Order IS NULL
            --если запись кидается вообще в пустой список или же это Корень.
            --Корень определяем как Записи Есть и @ActiveTreeID = -1
            IF EXISTS(SELECT * FROM ObjectTypes) AND @ActiveTreeID = -1
            BEGIN
                INSERT INTO ObjectTypes(ID, [Name], NodeImageIndex, NodeOrder, ParentID, [Status], [Type], XMLSchema, [Level], ViewScheme, Code1C, UserCode1C)
                OUTPUT INSERTED.ID INTO #t
                SELECT 
                    ISNULL(MAX(ID), 0) + 1, @Name, @NodeImageIndex, 
                    (SELECT ISNULL(MAX(NodeOrder), 0) + 1 FROM ObjectTypes WHERE ParentID IS NULL),
                     NULL, @Status, @Type, @XMLSchema, 0, @ViewScheme, @Code1C, @UserCode1C
                FROM ObjectTypes
            END
            ELSE
            BEGIN
                INSERT INTO ObjectTypes(ID, NAME, NodeImageIndex, NodeOrder, ParentID, [Status], [Type], XMLSchema, [Level], ViewScheme, Code1C, UserCode1C)
                OUTPUT INSERTED.ID INTO #t
                SELECT ISNULL(MAX(ID), 0) + 1, @Name, @NodeImageIndex, 0, CASE WHEN @ParentID = 0 THEN NULL ELSE @ParentID END, 
                    @Status, @Type, @XMLSchema, ISNULL(@Level + 1, 0), @ViewScheme, @Code1C, @UserCode1C
                FROM ObjectTypes
            END
        ELSE BEGIN
            IF @isCopy = 0
                --Считаем что мы кинули запись внутрь той в которую ткнули мышей
                --В конец        
                SELECT @Order = ISNULL(MAX(NodeOrder), 0)
                FROM ObjectTypes
                WHERE ISNULL(ParentID, 0) = ISNULL(@ActiveTreeID, 0)
            ELSE
            BEGIN
                --Считаем что копируется запись в тот же список что и копируемая
                --В конец
                SELECT @Order = ISNULL(MAX(NodeOrder), 0)
                FROM ObjectTypes
                WHERE ISNULL(ParentID, 0) = @ParentID
                --уменьшим левл на один, так как вставка будет давать + 1
                SELECT @Level = ISNULL(@Level, 1) - 1
            END
                
            --вставим новую запись
           
            INSERT INTO ObjectTypes(ID, NAME, NodeImageIndex, NodeOrder, ParentID, [Status], [Type], XMLSchema, [Level], ViewScheme, Code1C, UserCode1C)
            OUTPUT INSERTED.ID INTO #t
            SELECT ISNULL(MAX(ID), 0) + 1, @Name, @NodeImageIndex, @Order + 1, CASE WHEN @ParentID = 0 THEN NULL ELSE @ParentID END, 
                @Status, @Type, @XMLSchema, ISNULL(@Level + 1, 0), @ViewScheme, @Code1C, @UserCode1C
            FROM ObjectTypes
        END

        SELECT @NewID = ID FROM #t

        --Копирование данных если "Копирование"
        IF @isCopy = 1
        BEGIN
            UPDATE a
            SET
                a.NAME = 'Копия ' + b.[Name] + '(' + CAST(@NewID AS Varchar) + ')',
                a.NodeImageIndex = b.NodeImageIndex,
                a.[Status] = 0,
                a.[Type] = b.[Type],
                a.XMLSchema = b.XMLSchema,
                a.ViewScheme = b.ViewScheme,
                a.FontColor = b.FontColor
            FROM ObjectTypes AS a
            INNER JOIN ObjectTypes b ON b.ID = @ActiveTreeID
            WHERE a.ID = @NewID       
        END

        DROP TABLE #t
        
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SET @Err = @@ERROR;
		IF @@TRANCOUNT > 0 ROLLBACK TRAN;
		EXEC sp_RaiseError @ID = @Err;
		SET @NewID = -1;
	END CATCH;

    SELECT @NewID AS ID
END
GO