/*Script generating list of unique diagnoses*/

--Generate patient diagnoses set; 
--make a separate record per diagnosis at each primary and secondary level;
--drop all null values and assign F99 to all non-spesific diagnoses
WITH Diagnosis_Leveled AS
(SELECT BrcId,Diagnosis_Date,
	   CASE WHEN Primary_Diag like'%.X%' THEN
	        RTRIM(STUFF(Primary_Diag, CHARINDEX('.X',Primary_Diag),150,''))
	        WHEN Primary_Diag like'#%' THEN
	        RTRIM(STUFF(Primary_Diag, CHARINDEX(' ',Primary_Diag),150,''))    
			WHEN Primary_Diag IN (
				'F00-F99 - Mental and behavioural disorders',
				'FXX - Diagnosis not Specified',
				'FXMAX - No Axis 1 disorder - CAMHS',
				'No Axis 1 Diagnosis') THEN 'F99'
	   ELSE 
			RTRIM(STUFF(Primary_Diag, CHARINDEX(' -',Primary_Diag),150,''))
	   END AS Diag_Code
      	,Primary_Diag AS Diag_Name
      	,F_ICD10 = CASE
		WHEN  Primary_Diag LIKE '#%' OR	Primary_Diag LIKE '&%'			 						  
        THEN NULL 
			ELSE 
			CASE							  
				  WHEN Primary_Diag LIKE 'F%' 
				  THEN 1 ELSE 0 
		     END
		END
		,Diag_Rank = CASE 
		WHEN Primary_Diag LIKE '#%' 
		THEN 5 ELSE 0 END
		,CAG,CN_Doc_ID
FROM SQLCRIS.dbo.Diagnosis
where Primary_Diag NOT LIKE 'xNx'	
--		AND Primary_Diag NOT LIKE '#%'
--		AND Primary_Diag NOT LIKE '&%'

--Secondary_Diag_1
UNION ALL
SELECT BrcId,Diagnosis_Date,
	   CASE WHEN Secondary_Diag_1 like'%.X%' THEN
	        RTRIM(STUFF(Secondary_Diag_1, CHARINDEX('.X',Secondary_Diag_1),150,''))
	        WHEN Secondary_Diag_1 like'#%' THEN
	        RTRIM(STUFF(Secondary_Diag_1, CHARINDEX(' ',Secondary_Diag_1),150,''))    
			WHEN Secondary_Diag_1 IN (
				'F00-F99 - Mental and behavioural disorders',
				'FXX - Diagnosis not Specified',
				'FXMAX - No Axis 1 disorder - CAMHS',
				'No Axis 1 Diagnosis') THEN 'F99'
	   ELSE 
			RTRIM(STUFF(Secondary_Diag_1, CHARINDEX(' -',Secondary_Diag_1),150,''))
	   END AS Diag_Code
      	,Secondary_Diag_1 AS Diag_Name
      	,F_ICD10 = CASE
		WHEN  Secondary_Diag_1 LIKE '#%' OR	Secondary_Diag_1 LIKE '&%'			 						  
        THEN NULL 
			ELSE 
			CASE							  
				  WHEN Secondary_Diag_1 LIKE 'F%' 
				  THEN 1 ELSE 0 
		     END
		END
		,Diag_Rank = CASE 
		WHEN Secondary_Diag_1 LIKE '#%' 
		THEN 5 ELSE 1 END
		,CAG,CN_Doc_ID
FROM SQLCRIS.dbo.Diagnosis
where Secondary_Diag_1 NOT LIKE 'xNx'

--Secondary_Diag_2
UNION ALL
SELECT BrcId,Diagnosis_Date,
	   CASE WHEN Secondary_Diag_2 like'%.X%' THEN
	        RTRIM(STUFF(Secondary_Diag_2, CHARINDEX('.X',Secondary_Diag_2),150,''))
	        WHEN Secondary_Diag_2 like'#%' THEN
	        RTRIM(STUFF(Secondary_Diag_2, CHARINDEX(' ',Secondary_Diag_2),150,''))    
			WHEN Secondary_Diag_2 IN (
				'F00-F99 - Mental and behavioural disorders',
				'FXX - Diagnosis not Specified',
				'FXMAX - No Axis 1 disorder - CAMHS',
				'No Axis 1 Diagnosis') THEN 'F99'
	   ELSE 
			RTRIM(STUFF(Secondary_Diag_2, CHARINDEX(' -',Secondary_Diag_2),150,''))
	   END AS Diag_Code
      	,Secondary_Diag_2 AS Diag_Name
      	,F_ICD10 = CASE
		WHEN  Secondary_Diag_2 LIKE '#%' OR	Secondary_Diag_2 LIKE '&%'			 						  
        THEN NULL 
			ELSE 
			CASE							  
				  WHEN Secondary_Diag_2 LIKE 'F%' 
				  THEN 1 ELSE 0 
		     END
		END
		,Diag_Rank = CASE 
		WHEN Secondary_Diag_2 LIKE '#%' 
		THEN 5 ELSE 2 END
		,CAG,CN_Doc_ID
FROM SQLCRIS.dbo.Diagnosis
where Secondary_Diag_2 NOT LIKE 'xNx'

--Secondary_Diag_3
UNION ALL
SELECT BrcId,Diagnosis_Date,
	   CASE WHEN Secondary_Diag_3 like'%.X%' THEN
	        RTRIM(STUFF(Secondary_Diag_3, CHARINDEX('.X',Secondary_Diag_3),150,''))
	        WHEN Secondary_Diag_3 like'#%' THEN	        
	        RTRIM(STUFF(Secondary_Diag_3, CHARINDEX(' ',Secondary_Diag_3),150,''))    
			WHEN Secondary_Diag_3 IN (
				'F00-F99 - Mental and behavioural disorders',
				'FXX - Diagnosis not Specified',
				'FXMAX - No Axis 1 disorder - CAMHS',
				'No Axis 1 Diagnosis') THEN 'F99'
	   ELSE 
			RTRIM(STUFF(Secondary_Diag_3, CHARINDEX(' -',Secondary_Diag_3),150,''))
	   END AS Diag_Code
      	,Secondary_Diag_3 AS Diag_Name
      	,F_ICD10 = CASE
		WHEN  Secondary_Diag_3 LIKE '#%' OR	Secondary_Diag_3 LIKE '&%'			 						  
        THEN NULL 
			ELSE 
			CASE							  
				  WHEN Secondary_Diag_3 LIKE 'F%' 
				  THEN 1 ELSE 0 
		     END
		END
		,Diag_Rank = CASE 
		WHEN Secondary_Diag_3 LIKE '#%' 
		THEN 5 ELSE 3 END
		,CAG,CN_Doc_ID
FROM SQLCRIS.dbo.Diagnosis
where Secondary_Diag_3 NOT LIKE 'xNx'

--Secondary_Diag_4
UNION ALL
SELECT BrcId,Diagnosis_Date,
	   CASE WHEN Secondary_Diag_4 like'%.X%' THEN
	        RTRIM(STUFF(Secondary_Diag_4, CHARINDEX('.X',Secondary_Diag_4),150,''))
	        WHEN Secondary_Diag_4 like'#%' THEN
	        RTRIM(STUFF(Secondary_Diag_4, CHARINDEX(' ',Secondary_Diag_4),150,''))    
			WHEN Secondary_Diag_4 IN (
				'F00-F99 - Mental and behavioural disorders',
				'FXX - Diagnosis not Specified',
				'FXMAX - No Axis 1 disorder - CAMHS',
				'No Axis 1 Diagnosis') THEN 'F99'
	   ELSE 
			RTRIM(STUFF(Secondary_Diag_4, CHARINDEX(' -',Secondary_Diag_4),150,''))
	   END AS Diag_Code
      	,Secondary_Diag_4 AS Diag_Name
      	,F_ICD10 = CASE
		WHEN  Secondary_Diag_4 LIKE '#%' OR	Secondary_Diag_4 LIKE '&%'			 						  
        THEN NULL 
			ELSE 
			CASE							  
				  WHEN Secondary_Diag_4 LIKE 'F%' 
				  THEN 1 ELSE 0 
		     END
		END
		,Diag_Rank = CASE 
		WHEN Secondary_Diag_4 LIKE '#%' 
		THEN 5 ELSE 4 END
		,CAG,CN_Doc_ID
FROM SQLCRIS.dbo.Diagnosis
where Secondary_Diag_4 NOT LIKE 'xNx'

--Secondary_Diag_5 (mostly # by Child and Adolescent Mental Health Services)
UNION ALL
SELECT BrcId,Diagnosis_Date,
	   CASE WHEN Secondary_Diag_5 like'%.X%' THEN
	        RTRIM(STUFF(Secondary_Diag_5, CHARINDEX('.X',Secondary_Diag_5),150,''))	 
	        WHEN Secondary_Diag_5 like'#%' THEN
	        RTRIM(STUFF(Secondary_Diag_5, CHARINDEX(' ',Secondary_Diag_5),150,''))     
			WHEN Secondary_Diag_5 IN (
				'F00-F99 - Mental and behavioural disorders',
				'FXX - Diagnosis not Specified',
				'FXMAX - No Axis 1 disorder - CAMHS',
				'No Axis 1 Diagnosis') THEN 'F99'
	   ELSE 
			RTRIM(STUFF(Secondary_Diag_5, CHARINDEX(' -',Secondary_Diag_5),150,''))
	   END AS Diag_Code
      	,Secondary_Diag_5 AS Diag_Name
      	,F_ICD10 = CASE
		WHEN  Secondary_Diag_5 LIKE '#%' OR	Secondary_Diag_5 LIKE '&%'		 						  
        THEN NULL 
			ELSE 
			CASE							  
				  WHEN Secondary_Diag_5 LIKE 'F%' 
				  THEN 1 ELSE 0 
		     END
		END
		,Diag_Rank = 5 
		,CAG,CN_Doc_ID
FROM SQLCRIS.dbo.Diagnosis
where Secondary_Diag_5 NOT LIKE 'xNx'

--Secondary_Diag_6 (mostly & by Child and Adolescent Mental Health Services)
UNION ALL
SELECT BrcId,Diagnosis_Date,
	   CASE WHEN Secondary_Diag_6 like '%.X%' THEN
	        RTRIM(STUFF(Secondary_Diag_6, CHARINDEX('.X',Secondary_Diag_6),150,''))
	        WHEN Secondary_Diag_6 like '#%' THEN
	        RTRIM(STUFF(Secondary_Diag_6, CHARINDEX(' ',Secondary_Diag_6),150,''))     
	        WHEN Secondary_Diag_6 IN (
				'F00-F99 - Mental and behavioural disorders',
				'FXX - Diagnosis not Specified',
				'FXMAX - No Axis 1 disorder - CAMHS',
				'No Axis 1 Diagnosis') THEN 'F99'
	   ELSE 
			RTRIM(STUFF(Secondary_Diag_6, CHARINDEX(' -',Secondary_Diag_6),150,''))
	   END AS Diag_Code
      	,Secondary_Diag_6 AS Diag_Name
      	,F_ICD10 = CASE
		WHEN  Secondary_Diag_6 LIKE '#%' OR	Secondary_Diag_6 LIKE '&%'			 						  
        THEN NULL 
			ELSE 
			CASE							  
				  WHEN Secondary_Diag_6 LIKE 'F%' 
				  THEN 1 ELSE 0 
		     END
		END
		,Diag_Rank = CASE 
		WHEN Secondary_Diag_6 LIKE '#%' 
		THEN 5 ELSE 6 END
		,CAG,CN_Doc_ID
FROM SQLCRIS.dbo.Diagnosis
where Secondary_Diag_6 NOT LIKE 'xNx'
)

SELECT distinct Diag_Code
FROM Diagnosis_Leveled
order by Diag_Code
