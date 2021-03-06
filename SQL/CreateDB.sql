USE [master]
GO
/****** Object:  Database [DB_PlintDirections]    Script Date: 20.07.2017 8:04:59 ******/
CREATE DATABASE [DB_PlintDirections]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DB_PlintDirections', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\DB_PlintDirections.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'DB_PlintDirections_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\DB_PlintDirections_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [DB_PlintDirections] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DB_PlintDirections].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [DB_PlintDirections] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [DB_PlintDirections] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [DB_PlintDirections] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [DB_PlintDirections] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [DB_PlintDirections] SET ARITHABORT OFF 
GO
ALTER DATABASE [DB_PlintDirections] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [DB_PlintDirections] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [DB_PlintDirections] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [DB_PlintDirections] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [DB_PlintDirections] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [DB_PlintDirections] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [DB_PlintDirections] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [DB_PlintDirections] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [DB_PlintDirections] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [DB_PlintDirections] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [DB_PlintDirections] SET  DISABLE_BROKER 
GO
ALTER DATABASE [DB_PlintDirections] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [DB_PlintDirections] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [DB_PlintDirections] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [DB_PlintDirections] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [DB_PlintDirections] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [DB_PlintDirections] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [DB_PlintDirections] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [DB_PlintDirections] SET RECOVERY FULL 
GO
ALTER DATABASE [DB_PlintDirections] SET  MULTI_USER 
GO
ALTER DATABASE [DB_PlintDirections] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [DB_PlintDirections] SET DB_CHAINING OFF 
GO
ALTER DATABASE [DB_PlintDirections] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [DB_PlintDirections] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'DB_PlintDirections', N'ON'
GO
USE [DB_PlintDirections]
GO
/****** Object:  StoredProcedure [dbo].[p_Connection_Unit_Add]    Script Date: 20.07.2017 8:05:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[p_Connection_Unit_Add] 
	@Name varchar(max)
	, @Capacity int
	, @ID_Node int
as
begin
	declare @ID_CU int = isnull((select max(ID_CU) from dbo.t_Connection_Unit), 0) + 1
	insert into dbo.t_Connection_Unit (ID_CU, Name, Capacity, ID_Node)
	select @ID_CU, @Name, @Capacity, @ID_Node

	if (@Capacity > 0)
	begin
		declare @PlintNumber int = 0
		while @PlintNumber <= (@Capacity -1)
		begin
		  insert into dbo.t_Plint (ID_CU, PlintNumber)
		  select @ID_CU, @PlintNumber
		  set @PlintNumber += 1
		end
	end

	return @ID_CU
end
GO
/****** Object:  StoredProcedure [dbo].[p_Connection_Unit_Delete]    Script Date: 20.07.2017 8:05:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[p_Connection_Unit_Delete] @ID_CU int
as
begin
	begin try
		begin tran
		delete from dbo.t_Plint where ID_CU = @ID_CU
		delete from dbo.t_PlintDirection where ID_CU_1 = @ID_CU or ID_CU_2 = @ID_CU
		delete from dbo.t_Direction where ID_CU_1 = @ID_CU or ID_CU_2 = @ID_CU
		delete from dbo.t_Connection_Unit where ID_CU = @ID_CU
		if @@trancount > 0 commit
	end try
	begin catch
		declare @errorMessage varchar(max) = error_message()
		if @@trancount > 0 rollback
		raiserror('%s', 16, 1, @errorMessage)
		return -1
	end catch
end


GO
/****** Object:  StoredProcedure [dbo].[p_Direction_List]    Script Date: 20.07.2017 8:05:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[p_Direction_List] @ID_Node int
as 
begin
	select
		row_number() over (order by d.ID_CU_1 asc) as ID_CU_1, 
		cast(d.ID_CU_1 as varchar(255)) + ' [' + cast(d.BeginPlint_1 as varchar(255)) + ':'
			+ cast(d.BeginPlint_1 + d.PlintCount - 1 as varchar(255)) + '] o '
			+ cast(d.ID_CU_2 as varchar(255)) + ' [' + cast(d.BeginPlint_2 as varchar(255)) + ':'
			+ cast(d.BeginPlint_2 + d.PlintCount - 1 as varchar(255)) + ']' as Direction
	from dbo.t_Node as n
		left join dbo.t_Connection_Unit as cu1 on cu1.ID_Node = n.ID_Node
		left join dbo.t_Connection_Unit as cu2 on cu1.ID_Node = n.ID_Node
		join dbo.t_Direction as d on d.ID_CU_1 = cu1.ID_CU and d.ID_CU_2 = cu2.ID_CU
	where n.ID_Node = @ID_Node
end
GO
/****** Object:  StoredProcedure [dbo].[p_Node_Add]    Script Date: 20.07.2017 8:05:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[p_Node_Add] @Name varchar(max)
as
begin
	if (isnull(@Name, '') = '')
		raiserror('Не указано имя узла', 16, 1)
	declare @ID_Node int = isnull((select max(ID_Node) from dbo.t_Node), 0) + 1
	insert into dbo.t_Node (ID_Node, Name)
	select @ID_Node, @Name
	
	return @ID_Node
end
GO
/****** Object:  StoredProcedure [dbo].[p_Node_Delete]    Script Date: 20.07.2017 8:05:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[p_Node_Delete] @ID_Node int
as 
begin
	begin try
		begin tran
		declare curs cursor for 
			select ID_CU from dbo.t_Connection_Unit where ID_Node = @ID_Node
  
		declare @ID_CU int
		open curs
		while 1 = 1 begin
			fetch next from curs into @ID_CU
			if @@fetch_status <> 0 break
			exec dbo.p_Connection_Unit_Delete @ID_CU
		end
		close curs
		deallocate curs
  
		delete from dbo.t_Node where ID_Node = @ID_Node
		if @@trancount > 0 commit
		return 1
	end try
	begin catch
		declare @errorMessage varchar(max) = error_message()
		if @@trancount > 0 rollback
		raiserror('%s', 16, 1, @errorMessage)
		return -1
	end catch	
end
GO
/****** Object:  StoredProcedure [dbo].[p_Node_List]    Script Date: 20.07.2017 8:05:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[p_Node_List]
as
begin
	select ID_Node, Name
	from dbo.t_Node
end
GO
/****** Object:  StoredProcedure [dbo].[p_Plint_Direction_Pack]    Script Date: 20.07.2017 8:05:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[p_Plint_Direction_Pack] @Action int = 0, @ID_Node int
as
begin
	if @Action = 1
	begin
		delete d from 
			dbo.t_Node as n
			left join dbo.t_Connection_Unit as cu1 on cu1.ID_Node = n.ID_Node
			left join dbo.t_Connection_Unit as cu2 on cu1.ID_Node = n.ID_Node
			join dbo.t_Direction as d on d.ID_CU_1 = cu1.ID_CU and d.ID_CU_2 = cu2.ID_CU
		where n.ID_Node = @ID_Node

		declare @t_PlintDirection table (ID_CU_1 int, PlintNumber_1 int, ID_CU_2 int, PlintNumber_2 int)
		insert into @t_PlintDirection (ID_CU_1, PlintNumber_1, ID_CU_2, PlintNumber_2)
		select pd.ID_CU_1, pd.PlintNumber_1, pd.ID_CU_2, pd.PlintNumber_2 
		from dbo.t_Node as n
			left join dbo.t_Connection_Unit as cu1 on cu1.ID_Node = n.ID_Node
			left join dbo.t_Connection_Unit as cu2 on cu1.ID_Node = n.ID_Node
			join dbo.t_PlintDirection as pd on pd.ID_CU_1 = cu1.ID_CU and pd.ID_CU_2 = cu2.ID_CU
		where n.ID_Node = @ID_Node

		insert into dbo.t_Direction (ID_CU_1, BeginPlint_1, ID_CU_2, BeginPlint_2, PlintCount)
		select 
			pd.ID_CU_1					as ID_CU_1
			, pd.PlintNumber_1			as BeginPlint_1
			, pd.ID_CU_2				as ID_CU_2
			, pd.PlintNumber_2			as BeginPlint_2
			, isnull(s.Count, 0) + 1	as PlintCount 
		from @t_PlintDirection as pd
			left join (
				select pd1.ID_CU_1, pd1.PlintNumber_1, count(pd1.PlintNumber_2) as Count
				from 
					@t_PlintDirection as pd1
					join @t_PlintDirection as pd2 on pd2.ID_CU_1 = pd1.ID_CU_1 and pd2.PlintNumber_1 = pd1.PlintNumber_1 + 1
						and pd2.ID_CU_2 = pd1.ID_CU_2 and pd2.PlintNumber_2 = pd1.PlintNumber_2 + 1		
				group by pd1.ID_CU_1, pd1.PlintNumber_1) as s on s.ID_CU_1 = pd.ID_CU_1 and s.PlintNumber_1 = pd.PlintNumber_1
			left join (
				select pd1.ID_CU_1, pd1.PlintNumber_1, pd2.ID_CU_2, pd2.PlintNumber_2 
				from 
					@t_PlintDirection as pd1
					join @t_PlintDirection as pd2 on pd2.ID_CU_1 = pd1.ID_CU_1 and pd2.PlintNumber_1 = pd1.PlintNumber_1 + 1
						and pd2.ID_CU_2 = pd1.ID_CU_2 and pd2.PlintNumber_2 = pd1.PlintNumber_2 + 1) as s2 on s2.ID_CU_2 = pd.ID_CU_2 and s2.PlintNumber_2 = pd.PlintNumber_2
		where s2.ID_CU_2 is null 
		order by pd.ID_CU_1, pd.PlintNumber_1
	end

	select d.ID_CU_1, d.BeginPlint_1, d.ID_CU_2, d.BeginPlint_2, d.PlintCount
	from dbo.t_Node as n
		left join dbo.t_Connection_Unit as cu1 on cu1.ID_Node = n.ID_Node
		left join dbo.t_Connection_Unit as cu2 on cu1.ID_Node = n.ID_Node
		join dbo.t_Direction as d on d.ID_CU_1 = cu1.ID_CU and d.ID_CU_2 = cu2.ID_CU
	where n.ID_Node = @ID_Node
end
GO
/****** Object:  Table [dbo].[t_Connection_Unit]    Script Date: 20.07.2017 8:05:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_Connection_Unit](
	[ID_CU] [int] NULL,
	[Name] [varchar](255) NULL,
	[Capacity] [int] NULL,
	[ID_Node] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[t_Direction]    Script Date: 20.07.2017 8:05:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_Direction](
	[ID_CU_1] [int] NULL,
	[BeginPlint_1] [int] NULL,
	[ID_CU_2] [int] NULL,
	[BeginPlint_2] [int] NULL,
	[PlintCount] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[t_Node]    Script Date: 20.07.2017 8:05:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_Node](
	[ID_Node] [int] NULL,
	[Name] [varchar](255) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[t_Plint]    Script Date: 20.07.2017 8:05:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_Plint](
	[ID_CU] [int] NULL,
	[PlintNumber] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[t_PlintDirection]    Script Date: 20.07.2017 8:05:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_PlintDirection](
	[ID_CU_1] [int] NULL,
	[PlintNumber_1] [int] NULL,
	[ID_CU_2] [int] NULL,
	[PlintNumber_2] [int] NULL
) ON [PRIMARY]

GO
USE [master]
GO
ALTER DATABASE [DB_PlintDirections] SET  READ_WRITE 
GO
