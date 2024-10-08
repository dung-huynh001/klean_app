USE [master]
GO
/****** Object:  Database [klean]    Script Date: 10/2/2024 2:03:32 AM ******/
CREATE DATABASE [klean]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'klean', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.HCDUNG\MSSQL\DATA\klean.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'klean_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.HCDUNG\MSSQL\DATA\klean_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [klean] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [klean].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [klean] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [klean] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [klean] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [klean] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [klean] SET ARITHABORT OFF 
GO
ALTER DATABASE [klean] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [klean] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [klean] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [klean] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [klean] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [klean] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [klean] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [klean] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [klean] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [klean] SET  DISABLE_BROKER 
GO
ALTER DATABASE [klean] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [klean] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [klean] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [klean] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [klean] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [klean] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [klean] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [klean] SET RECOVERY FULL 
GO
ALTER DATABASE [klean] SET  MULTI_USER 
GO
ALTER DATABASE [klean] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [klean] SET DB_CHAINING OFF 
GO
ALTER DATABASE [klean] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [klean] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [klean] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [klean] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'klean', N'ON'
GO
ALTER DATABASE [klean] SET QUERY_STORE = ON
GO
ALTER DATABASE [klean] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [klean]
GO
/****** Object:  Table [dbo].[__EFMigrationsHistory]    Script Date: 10/2/2024 2:03:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__EFMigrationsHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[user_table]    Script Date: 10/2/2024 2:03:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[user_table](
	[UserId] [int] NOT NULL,
	[user_name] [nvarchar](20) NOT NULL,
	[password_hash] [nvarchar](100) NOT NULL,
	[date_of_birth] [datetime2](7) NOT NULL,
	[contact_mbile] [nvarchar](30) NULL,
	[contact_tel] [nvarchar](max) NULL,
	[cntact_email] [nvarchar](30) NULL,
	[user_lv] [int] NOT NULL,
	[login_permit] [bit] NOT NULL,
	[register_date] [datetime2](7) NOT NULL,
	[last_modified_date] [datetime2](7) NOT NULL,
	[address_state] [nvarchar](max) NULL,
	[address_suburb] [nvarchar](max) NULL,
	[address_detail] [nvarchar](max) NULL,
	[postcode] [int] NOT NULL,
	[note] [nvarchar](500) NULL,
 CONSTRAINT [PK_user_table] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20240715165645_Inital', N'8.0.7')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20240718201858_UpdateUsrLv_v1', N'8.0.7')
GO
INSERT [dbo].[user_table] ([UserId], [user_name], [password_hash], [date_of_birth], [contact_mbile], [contact_tel], [cntact_email], [user_lv], [login_permit], [register_date], [last_modified_date], [address_state], [address_suburb], [address_detail], [postcode], [note]) VALUES (10000001, N'hcdung01', N'0de27c19767c51e58d9502946abc307f498391b517c1cbd3d8f34d837491a204', CAST(N'2024-09-30T00:00:00.0000000' AS DateTime2), NULL, NULL, NULL, 3, 0, CAST(N'2024-10-01T00:00:12.5084479' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'2', N'4', N'Hoa Binh, Bac Lieu', 941, NULL)
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_user_table_user_name]    Script Date: 10/2/2024 2:03:33 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_user_table_user_name] ON [dbo].[user_table]
(
	[user_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[user_table] ADD  DEFAULT ((3)) FOR [user_lv]
GO
ALTER TABLE [dbo].[user_table] ADD  DEFAULT (CONVERT([bit],(0))) FOR [login_permit]
GO
ALTER TABLE [dbo].[user_table]  WITH CHECK ADD  CONSTRAINT [CK_User_UserId_Range] CHECK  (([UserId]>=(10000000) AND [UserId]<=(99999999)))
GO
ALTER TABLE [dbo].[user_table] CHECK CONSTRAINT [CK_User_UserId_Range]
GO
USE [master]
GO
ALTER DATABASE [klean] SET  READ_WRITE 
GO
