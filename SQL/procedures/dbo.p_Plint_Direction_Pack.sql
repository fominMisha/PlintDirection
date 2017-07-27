alter procedure [dbo].[p_Plint_Direction_Pack] @Action int = 0, @ID_Node int
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
				
		declare @d_ID_CU_1 int
			, @d_BeginPlint_1 int
			, @d_ID_CU_2 int
			, @d_BeginPlint_2 int
				 
		declare @ID_CU_1 int
			, @PlintNumber_1 int
			, @ID_CU_2 int
			, @PlintNumber_2 int
			, @Diff_1 int
			, @Diff_2 int

		declare @count int = 1
		declare curPlints cursor for
			select pd1.ID_CU_1
				, pd1.PlintNumber_1
				, isnull(pd2.PlintNumber_1, pd1.PlintNumber_1) - pd1.PlintNumber_1 as diff_1 
				, pd1.ID_CU_2
				, pd1.PlintNumber_2
				, isnull(pd2.PlintNumber_2, pd1.PlintNumber_2) - pd1.PlintNumber_2 as diff_2 
			from @t_PlintDirection as pd1
				left join @t_PlintDirection as pd2 on pd2.ID_CU_1 = pd1.ID_CU_1 and pd2.PlintNumber_1 = pd1.PlintNumber_1 + 1
					and pd2.ID_CU_2 = pd1.ID_CU_2 and pd2.PlintNumber_2 = pd1.PlintNumber_2 + 1
			order by pd1.ID_CU_1, pd1.PlintNumber_1
		
		open curPlints
		while 1 = 1 begin
			fetch next from curPlints into 
				@ID_CU_1
				, @PlintNumber_1
				, @Diff_1
				, @ID_CU_2
				, @PlintNumber_2
				, @Diff_2
			if (@@fetch_status <> 0) break
			
			if (@Diff_1 = 1 and @Diff_2 = 1)
			begin
				if @count = 1
					select
						@d_ID_CU_1 = @ID_CU_1
						, @d_BeginPlint_1 = @PlintNumber_1			
						, @d_ID_CU_2 = @ID_CU_2
						, @d_BeginPlint_2 = @PlintNumber_2	 
				set @count += 1
			end	
			else
			begin
				if @count > 1
					insert into dbo.t_Direction (ID_CU_1, BeginPlint_1, ID_CU_2, BeginPlint_2, PlintCount)
					select @d_ID_CU_1 , @d_BeginPlint_1 , @d_ID_CU_2 , @d_BeginPlint_2 , @count
				else
					insert into dbo.t_Direction (ID_CU_1, BeginPlint_1, ID_CU_2, BeginPlint_2, PlintCount)
					select @ID_CU_1, @PlintNumber_1, @ID_CU_2, @PlintNumber_2, @count
				set @count = 1			
			end
		end
		close curPlints
		deallocate curPlints
	end

	select d.ID_CU_1, d.BeginPlint_1, d.ID_CU_2, d.BeginPlint_2, d.PlintCount
	from dbo.t_Node as n
		left join dbo.t_Connection_Unit as cu1 on cu1.ID_Node = n.ID_Node
		left join dbo.t_Connection_Unit as cu2 on cu1.ID_Node = n.ID_Node
		join dbo.t_Direction as d on d.ID_CU_1 = cu1.ID_CU and d.ID_CU_2 = cu2.ID_CU
	where n.ID_Node = @ID_Node
end