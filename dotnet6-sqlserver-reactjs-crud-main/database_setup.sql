-- Create Database if not exists
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'testdb')
BEGIN
    CREATE DATABASE [testdb];
END
GO

USE [testdb];
GO

-- Create Users table if not exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[users]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[users] (
        [id] INT IDENTITY(1,1) NOT NULL,
        [first_name] NVARCHAR(MAX) NULL,
        [last_name] NVARCHAR(MAX) NULL,
        [email] NVARCHAR(MAX) NULL,
        CONSTRAINT [PK_users] PRIMARY KEY CLUSTERED ([id] ASC)
    );
END
GO
