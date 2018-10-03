﻿CREATE DATABASE [Spekler]
GO

ALTER DATABASE [Spekler]
  SET
    ANSI_NULL_DEFAULT OFF,
    ANSI_NULLS OFF,
    ANSI_PADDING OFF,
    ANSI_WARNINGS OFF,
    ARITHABORT OFF,
    AUTO_CLOSE OFF,
    AUTO_CREATE_STATISTICS ON,
    AUTO_SHRINK OFF,
    AUTO_UPDATE_STATISTICS ON,
    AUTO_UPDATE_STATISTICS_ASYNC OFF,
    COMPATIBILITY_LEVEL = 100,
    CONCAT_NULL_YIELDS_NULL OFF,
    CURSOR_CLOSE_ON_COMMIT OFF,
    CURSOR_DEFAULT LOCAL,
    DATE_CORRELATION_OPTIMIZATION OFF,
    DB_CHAINING OFF,
    HONOR_BROKER_PRIORITY OFF,
    MULTI_USER,
    NUMERIC_ROUNDABORT OFF,
    PAGE_VERIFY CHECKSUM,
    PARAMETERIZATION SIMPLE,
    QUOTED_IDENTIFIER OFF,
    READ_COMMITTED_SNAPSHOT OFF,
    RECOVERY SIMPLE,
    RECURSIVE_TRIGGERS OFF,
    TRUSTWORTHY OFF
    WITH ROLLBACK IMMEDIATE
GO

ALTER DATABASE [Spekler]
  COLLATE Cyrillic_General_CI_AS
GO

ALTER DATABASE [Spekler]
  SET DISABLE_BROKER
GO

ALTER DATABASE [Spekler]
  SET ALLOW_SNAPSHOT_ISOLATION OFF
GO

ALTER AUTHORIZATION ON DATABASE :: [Spekler] TO [SPEKL\PoliatykinO]
GO

GRANT CONNECT TO [dbo]
GO

GRANT CONNECT TO [NT AUTHORITY\SYSTEM]
GO

GRANT CONNECT TO [QlikView]
GO

GRANT CONNECT TO [SPEKL\ChepelN]
GO

GRANT CONNECT TO [SPEKL\OleynikY]
GO

GRANT CONNECT TO [SpeklerUser]
GO

GRANT CONNECT TO [SyncCRM]
GO