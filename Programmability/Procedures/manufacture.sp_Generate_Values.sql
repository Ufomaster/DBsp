SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create PROCEDURE [manufacture].[sp_Generate_Values]
AS
BEGIN
BEGIN
    DECLARE @i int, @j int, @UserID int, @JobID int, @GroupID bigint, @GroupName varchar(255), @Value varchar(255)
    
    CREATE TABLE #T1 (ID Bigint)
     
    SET @UserID = 5 --Западинский А.В.

    --Генерим работы   
/*    SET @i = 101
    WHILE @i <= 3000
    BEGIN
        INSERT INTO mds.Jobs ([NAME],[UserID])
        Values ('Job'+Convert(varchar,@i), @UserID)
        

        SET @I = @I +1
    END    */
    
    --Генерим материалы и группы
    DECLARE CurJob CURSOR LOCAL STATIC FOR 
    SELECT ID FROM manufacture.Jobs
    
    OPEN CurJob
    FETCH NEXT FROM CurJob INTO @JobID
    
    SET @i = 0
    WHILE @@FETCH_STATUS = 0
    BEGIN
        BEGIN TRAN
        
        SET @j = 0
        WHILE @j < 50000
        BEGIN
            SET @GroupName = 'Group' + Convert(varchar,@J)

			INSERT INTO PersonolizedMaterialGroups ([Name], [JobID])
	        OUTPUT INSERTED.ID INTO #T1
    	    VALUES(@GroupName, @JobID)            
            
            SELECT @GroupID = ID FROM #T1	
            
            --EXEC mds.sp_PersonolizedMaterialGroups_Insert @GroupName, @JobID, @GroupID OUTPUT
            
            SET @Value = CONVERT(varchar(max),right(REPLICATE('0',19 - LEN(cast(@J as varchar(19))+CONVERT(varchar(19), @GroupID))) + cast(@J as varchar(19))+CONVERT(varchar(19), @GroupID), 20))
            
            INSERT INTO manufacture.PersonolizedMaterials ([Value], [PersonolizedMaterialGroupID], [StatusID], [ProductionCardCustomizeMaterialID])
            VALUES (@Value + '1', @GroupID, 1, 1711),
                   (@Value + '2', @GroupID, 1, 1712),
                   (@Value + '3', @GroupID, 1, 1713)
            
            SET @J = @J + 1                    

            TRUNCATE TABLE #T1            
        END
        
        COMMIT TRAN
            
        FETCH NEXT FROM CurJob INTO @JobID
        SET @I = @I + 1
    END    
    
    CLOSE CurJob
    DEALLOCATE CurJob       
    
END
END
GO