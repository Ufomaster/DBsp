SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   19.11.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   09.04.2015$*/
/*$Version:    1.00$   $Description: Добавление детальной части в темп таблицу при создании протокола$*/
CREATE PROCEDURE [QualityControl].[sp_Protocols_InsertTmpDetails]
    @TypeID Int,
    @PCCID int = NULL,
    @TMCID int = NULL
AS
BEGIN
    --для таблицы #ProtocolsDetail нужно жестко соблюдать перечень и порядок полей. смотреть в QualityControl.sp_Protocols_GenerateDetails что на выходе.
    CREATE TABLE #props(ID int, ParentID int, ID_1 int, [Level] int, Caption Varchar(max), ValueToCheck Varchar(max), 
       FactVale Varchar(max), [Value] tinyint, SortOrder int, ResultKind tinyint, BlockID int, DetailBlockID int, ImportanceID tinyint)

    --соблюдать порядок полей!
    INSERT INTO #props(ID, ParentID, ID_1, [Level], Caption, ValueToCheck, FactVale, SortOrder, ResultKind, BlockID, [Value], ImportanceID, DetailBlockID)
    EXEC QualityControl.sp_Protocols_GenerateDetails @TypeID, @PCCID, @TMCID

 
    INSERT INTO #ProtocolsDetails(_ID, SortOrder, [Caption], ValueToCheck, FactValue, Checked, ModifyDate, ResultKind, BlockID, ImportanceID, DetailBlockID)
    SELECT NULL, ID, Caption, ValueToCheck, FactVale, [Value], GETDATE(), ResultKind, BlockID, ImportanceID, DetailBlockID
    FROM #props ORDER BY ID
    DROP TABLE #props
END
GO