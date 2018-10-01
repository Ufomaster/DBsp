CREATE TABLE [dbo].[SystemCustomers] (
  [ID] [int] IDENTITY,
  [CustomerID] [int] NOT NULL,
  [IsDefault] [bit] NULL,
  CONSTRAINT [PK_SystemCustomers_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.SystemCustomers.IsDefault'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TR_SystemCustomers_iud] ON [SystemCustomers]

FOR INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @ID Int

    SELECT @ID = ID FROM INSERTED
    
    IF EXISTS(SELECT * FROM DELETED) AND EXISTS(SELECT * FROM INSERTED) -- Update
    BEGIN
        -- if IsDefaule is set to 1
        IF EXISTS(SELECT * FROM INSERTED WHERE IsDefault = 1)           
            -- reset all others records
            UPDATE a
            SET a.IsDefault = 0
            FROM SystemCustomers a
            WHERE a.ID <> @ID
    END
    ELSE
    IF EXISTS(SELECT * FROM DELETED) AND NOT EXISTS(SELECT * FROM INSERTED) -- DELETED
    BEGIN
        -- Если удаляем дефолтовую, ставим первой любой записи дефолт  
        IF EXISTS(SELECT * FROM DELETED WHERE IsDefault = 1)
            -- Set
            UPDATE a
            SET a.IsDefault = 1
            FROM SystemCustomers a
            WHERE a.ID IN (SELECT TOP 1 ID FROM SystemCustomers WHERE ID <> @ID)
    END

    -- ставим записи дефолт, если несуществует дефолтов.
    IF NOT EXISTS(SELECT * FROM SystemCustomers WHERE IsDefault = 1)
        UPDATE a
        SET a.IsDefault = 1
        FROM SystemCustomers a 
        WHERE ID = @ID
END
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Собственные фирмы', 'SCHEMA', N'dbo', 'TABLE', N'SystemCustomers'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'SystemCustomers', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор контрагента', 'SCHEMA', N'dbo', 'TABLE', N'SystemCustomers', 'COLUMN', N'CustomerID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Компания по умолчанию', 'SCHEMA', N'dbo', 'TABLE', N'SystemCustomers', 'COLUMN', N'IsDefault'
GO