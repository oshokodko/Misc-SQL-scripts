	SELECT 	p.Name as TeamMemberName, 
		sum(IsNull(a.[Tbs_Corptax_CompletedHours],0)) CompletedCodeReviewHours,
		sum(1.0) CompletedCodeReviews
	--into #CompletedCodeReviewHours
	FROM [TFSWarehouse].[dbo].[DimWorkItem] b with(nolock) 
    join [TFSWarehouse].[dbo].DimPerson p with(nolock) on p.PersonSK = b.Microsoft_VSTS_Common_ClosedBy__PersonSK
	join [TFSWarehouse].[dbo].[FactCurrentWorkItem] a with(nolock) on a.WorkItemSK = b.WorkItemSK
	--join #CompletedIterations s on b.IterationSK = s.IterationSK 
  	where b.[System_WorkItemType] = 'Code Review Response'
	and b.System_State = 'Closed' 
	and b.Microsoft_VSTS_CodeReview_ClosedStatus in ('Looks Good','With Comments','Needs Work')
	and b.Microsoft_VSTS_Common_ClosedDate > '08/25/2017' --between @CompletedSampleStartDate and @CompletedSampleEndDate
	group by p.Name
	having sum(IsNull(a.[Tbs_Corptax_CompletedHours],0)) > 0