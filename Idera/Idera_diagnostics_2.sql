select a.SPName into #tmpSPs
from
(select '%LYENTERPRISELOCKLISTSP%' SPName UNION
select '%LYENTERPRISEUNLOCKLISTSP%' UNION
select '%LYGETALLOCATEDK1LINESSP%' UNION
select '%LYGETALLOCATEDUDFDATASP%' UNION
select '%LYGETREFAMOUNTSFORPARTNERSSP%' UNION
select '%LYGETRESOLVEDINTPAGESETTINGSP%' UNION
select '%LYPROCESSORDERGet01SP%' UNION
select '%LYPROCESSORDERGet02SP%' UNION
select '%LYRETRIEVE1118DETAILSSP%' UNION
select '%LYRETRIEVETABLESBYSEVERITYSP%' UNION
select '%LYROLLENTHLSRSP%' UNION
select '%LYRULESETVALUEPERENTITYSP%' UNION
select '%LYRULESETVALUESP%' UNION
select '%Dedup_Enterprise_TaxRates%' UNION
select '%ENTITYDELETE_BODYSP%' UNION
select '%ENTITYDELETE_LOGICALSP%' UNION
select '%ENTITYDELETE_LOGSP%' UNION
select '%ENTITYDELETE_MAINSP%' UNION
select '%Entity_MasterDelSP%' UNION
select '%ENTITYDELETE_PHYSICALSP+A57%' UNION
select '%INT_OWNERSHIPCalSP%' UNION
select '%INT_TRIAL_BAL_LYCSAI_Copy02SP%' UNION
select '%LYALLOCAMOUNTSETLEVELSP%' UNION
select '%LYALLOCGETUDFSUMMTOTSP%' UNION
select '%LYCalcRatiosByDateSP%' UNION
select '%LYCNAVOVERRIDEGET01SP%' UNION
select '%LYCOLUMNFILECreateSP%' UNION
select '%LYCREATEMERGEGROUPFOROFFICESP%' UNION
select '%LYDNAVPURGEDELSP%' UNION
select '%LYEDIOVERFLOWGRIDIMPORTSP%' UNION
select '%LYENTERPRISEUpd02SP%' UNION
select '%LYENTITYDelSP%' UNION
select '%LYENTITYQSUBDELSP%' UNION
select '%LYENTITYSAVE2SP%' UNION
select '%LYGETENTERPRISECOUNTINFOSP%' UNION
select '%LYGETMAINTAXSTATUSTYPESP%' UNION
select '%LYGETRESOLVEDPAGESETTINGSP%' UNION
select '%LYGETRESOLVEDTXRETURNSETTINGSP%' UNION
select '%LYGETSCORPRATIOSBYTRANSP%' UNION
select '%LYGetTransfereeRatiosByTranSP%' UNION
select '%LYGETUSRDEFTYPSSP%' UNION
select '%LYGroupCreateMergeGroupSP%' UNION
select '%LYGSMGetOfficeListSP%' UNION
select '%LYInitializeRatiosSP%' UNION
select '%LYK1SchAllocDetailsPrnSP%' UNION
select '%LYLOCKOFFICESSP%' UNION
select '%LYM3CDWLISTIMPORTSP%' UNION
select '%LYOVERFLOWGETSTMTLISTALLCOLSP%' UNION
select '%LYOVERFLOWGETSTMTLISTSP%' UNION
select '%LYPARTNERCLASSASSOCUPDSP%' UNION
select '%LYPTRSHIPMBRAPPLYDESELECTEDSP%' UNION
select '%LYRULEMERGECOLUMNFILESP%' UNION
select '%LYRULEMERGECOLUMNSP%' UNION
select '%LYRULEUPDATEDATAFORQSUBSP%' UNION
select '%LYRULEUPDATEEQUITYTYPESP%' UNION
select '%LYRULEUPDATEGROUPMASTERSP%' UNION
select '%LYRULEUPDATELYQUERYSP%' UNION
select '%LYRULEUPDATEPARTNERSHIPSP%' UNION
select '%LYRULEUPDATERETURNSP%' UNION
select '%LYRULEUPDATESUBBASKETSP%' UNION
select '%LYFOLDERL01SP%' UNION
select '%R_LYINTREPTNAVSP%' UNION
select '%ListColumnSplitSP%' UNION
select '%LYCREATEDBAUDITLISTSP%' UNION
select '%LYRULEUPDATEBASECALCSP%' UNION
select '%EnterpriseDelete_BodySP%' UNION
select '%ENTITYCODERENAMESP%' UNION
select '%INT_Tax_YearDelSP%' UNION
select '%LYENTITYDELCHILDSP%' UNION
select '%spu_Folder_Delete%' UNION
select '%SPU_TABLEAUDIT_INSERT%' UNION
select '%SPU_PRODUCT_DELETE%' UNION
select '%SPU_PRODUCT_UPDATE%' UNION
select '%EFRemoveAllTablesSP%' UNION
select '%EFGetDocumentsSP%' UNION
select '%EFGetFileDetailsSP%' UNION
select '%EFCheckInValidDocRefSP%' UNION
select '%EFCopyFilingGroupAsSP%' UNION
select '%EFInCompatibilityErrorLoggingSP%' UNION
select '%EFUpdateExcludeFlagSP%' )  a
collate SQL_Latin1_General_CP1_CI_AS


select top 100000 SQLServerName  
      ,DatabaseName  
      , CompletionTime
      ,[CPUMilliseconds]  
      ,[Reads]  
      ,[Writes]  
      --,[StatementType]   
      ,SQLStatement   
	  into #tmpQueries
from [vsdbs01\monitor].[SQLdmRepository].dbo.IderaDiagnosticInformation (nolock) p
--join #tmpSPs a on p.SQLStatement like a.SPName
where CompletionTime between '2014-08-26 00:00:00.000' and '2014-09-03 00:00:00.000'
--and SQLStatement like '%TableData%'
and (SQLStatement not like '%dbcc%' and SQLStatement not like '%sp_Rebuild%' ) 
and SQLStatement not like '%RESTORE%'
and SQLStatement not like '%BACKUP%' 
and DatabaseName not like 'msdb'
and SQLServerName in ('VSDBC01S01\INSTANCE01','VSDBC01S02\INSTANCE02','VSDBC01S03\INSTANCE03','VSDBC01S04\INSTANCE04')
--and SQLStatement like '%CREATE CLUSTERED Index%'
--order by [Reads] desc
--order by [DurationMilliseconds] desc
order by SQLStatement desc
--order by CompletionTime desc
--order by [DurationMilliseconds] desc
