SQL -- Create view of event_gridstat_before and event_gridstat_after and "during" ( < incident date)
	before: All updates before the incident
	after: All updates
	during: Only updates after the incident
QGIS -- Load table into QGIS and join to grid. Export shapefile of event_gridstat_before and event_gridstat_after
GeoDa -- Generate Weights. ex C:\Users\Erola\Documents\Penn State\Capstone\data\part1\grenfell_gridstat_after.gwt
GeoDa -- Run Local G* Cluster to identify hot/cold spots
GeoDa -- Save Results to file Options > Save Results
			C_ID is Hot/Cold Analysis
				0 = Not Significant
				1 = Hot
				2 = Cold

----
QGIS -- Load event_gridstat_after
QGIS --  





