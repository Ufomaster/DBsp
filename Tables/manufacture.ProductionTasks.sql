CREATE TABLE [manufacture].[ProductionTasks] (
  [ID] [int] IDENTITY,
  [CreateDate] [datetime] NULL,
  [ShiftID] [int] NULL,
  [ChiefEmployeeID] [int] NULL,
  [StorageStructureSectorID] [tinyint] NULL,
  [StartDate] [datetime] NULL,
  [EndDate] [datetime] NULL,
  [CreateType] [tinyint] NULL,
  CONSTRAINT [PK_ProductionTasks_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create TRIGGER [TR_ProductionTasks_delete]
           on [manufacture].[ProductionTasks]
           FOR DELETE
           as
           BEGIN
           	    DECLARE @EmployeeID int = null
                IF OBJECT_ID('tempdb..#CurrentUser') IS NOT NULL SELECT @EmployeeID = a.EmployeeID FROM #CurrentUser a           
                INSERT INTO [manufacture].[ProductionTasksHistory] ([ID], [CreateDate], [ShiftID], [ChiefEmployeeID], [StorageStructureSectorID], [StartDate], [EndDate], [CreateType], [HistoryOperationID], [HistoryModifyEmployeeID])
                SELECT [ID], [CreateDate], [ShiftID], [ChiefEmployeeID], [StorageStructureSectorID], [StartDate], [EndDate], [CreateType], 2, @EmployeeID
                FROM deleted
           END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create TRIGGER [TR_ProductionTasks_insert]
           on [manufacture].[ProductionTasks]
           FOR insert
           as
           BEGIN
           	    DECLARE @EmployeeID int = null
                IF OBJECT_ID('tempdb..#CurrentUser') IS NOT NULL SELECT @EmployeeID = a.EmployeeID FROM #CurrentUser a
                INSERT INTO [manufacture].[ProductionTasksHistory] ([ID], [CreateDate], [ShiftID], [ChiefEmployeeID], [StorageStructureSectorID], [StartDate], [EndDate], [CreateType], [HistoryOperationID], [HistoryModifyEmployeeID])
                SELECT [ID], [CreateDate], [ShiftID], [ChiefEmployeeID], [StorageStructureSectorID], [StartDate], [EndDate], [CreateType], 0, @EmployeeID
                FROM inserted
           END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create TRIGGER [TR_ProductionTasks_update]
           on [manufacture].[ProductionTasks]
           FOR UPDATE
           as
           BEGIN
           	    DECLARE @EmployeeID int = null
                IF OBJECT_ID('tempdb..#CurrentUser') IS NOT NULL SELECT @EmployeeID = a.EmployeeID FROM #CurrentUser a           
                INSERT INTO [manufacture].[ProductionTasksHistory] ([ID], [CreateDate], [ShiftID], [ChiefEmployeeID], [StorageStructureSectorID], [StartDate], [EndDate], [CreateType], [HistoryOperationID], [HistoryModifyEmployeeID])
                SELECT [ID], [CreateDate], [ShiftID], [ChiefEmployeeID], [StorageStructureSectorID], [StartDate], [EndDate], [CreateType], 1, @EmployeeID
                FROM inserted
           END
GO

ALTER TABLE [manufacture].[ProductionTasks]
  ADD CONSTRAINT [FK_ProductionTasks_Employees_ID] FOREIGN KEY ([ChiefEmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [manufacture].[ProductionTasks]
  ADD CONSTRAINT [FK_ProductionTasks_Shifts (shifts)_ID] FOREIGN KEY ([ShiftID]) REFERENCES [shifts].[Shifts] ([ID])
GO

ALTER TABLE [manufacture].[ProductionTasks] WITH NOCHECK
  ADD CONSTRAINT [FK_ProductionTasks_StorageStructureSectors (manufacture)_ID] FOREIGN KEY ([StorageStructureSectorID]) REFERENCES [manufacture].[StorageStructureSectors] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasks', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasks', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор смены', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasks', 'COLUMN', N'ShiftID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор начальника смены/бригады/ответственного', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasks', 'COLUMN', N'ChiefEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор участка', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasks', 'COLUMN', N'StorageStructureSectorID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата старта', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasks', 'COLUMN', N'StartDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата окончания', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasks', 'COLUMN', N'EndDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'1-autocreate, 2-autopdate EndDateNull', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasks', 'COLUMN', N'CreateType'
GO