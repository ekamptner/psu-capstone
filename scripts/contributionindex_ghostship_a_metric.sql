With nodeCount AS (
 SELECT g.id, count(DISTINCT n.id) AS nodecount
      FROM nodes n, ghostship_grid_metric_30 g
  WHERE st_within(n.geom, st_transform(g.geom,4326)) AND n.event = 'ghost ship' AND n."timestamp" > '2016-11-02 00:00:00-04' AND n.timestamp < '2016-12-02' 
  GROUP BY g.id
  ORDER BY g.id
     ),
 wayCount AS(
      SELECT g.id, count(DISTINCT w.way_id) AS waycount
      FROM way_nodes_centroids w, ghostship_grid_metric_30 g
  WHERE st_within(w.centroid, st_transform(g.geom,4326)) AND w.event = 'ghost ship' AND w."timestamp" > '2016-11-02 00:00:00-04' AND w.timestamp < '2016-12-02' 
  GROUP BY g.id
  ORDER BY g.id
      ),
 allcounts AS(
  Select COALESCE(c.id, w.id) as id, COALESCE(nodecount, 0) as nodecount, 
     COALESCE(waycount, 0) as waycount, (COALESCE(nodecount, 0) + COALESCE(waycount, 0)) as counts
  From nodeCount c full outer join wayCount w ON c.id = w.id
  ORder by COALESCE(c.id, w.id)   
     ),
 -- Average Version
maxVersions AS (
     Select n.id, MAX(n.version) as maxversion
     From nodes n
     Where n.event = 'ghost ship' AND n."timestamp" > '2016-11-02 00:00:00-04' AND n.timestamp < '2016-12-02' 
     Group by n.id
     ),
averageVersions AS(
 SELECT g.id, round(avg(v.maxversion), 2) AS avgversion
      FROM nodes n 
          join maxVersions v ON n.id = v.id,
          ghostship_grid_metric_30 g
  WHERE st_within(n.geom, st_transform(g.geom,4326)) 
  AND n.event = 'ghost ship' AND n."timestamp" > '2016-11-02 00:00:00-04' AND n.timestamp < '2016-12-02' 
  GROUP BY g.id
  ORDER BY g.id
    ),
  -- Number of users
 nodeuserCount AS (
 SELECT g.id, count(DISTINCT n.uid) AS nodeusercount
      FROM nodes n, ghostship_grid_metric_30 g
  WHERE st_within(n.geom, st_transform(g.geom,4326)) AND n.event = 'ghost ship' AND n."timestamp" > '2016-11-02 00:00:00-04' AND n.timestamp < '2016-12-02' 
  GROUP BY g.id
  ORDER BY g.id
     ),
 wayuserCount AS(
      SELECT g.id, count(DISTINCT w.uid) AS wayusercount
      FROM ghostship_grid_metric_30 g, way_nodes_centroids w
  WHERE st_within(w.centroid, st_transform(g.geom,4326)) AND w.event = 'ghost ship' AND w."timestamp" > '2016-11-02 00:00:00-04' AND w.timestamp < '2016-12-02' 
  GROUP BY g.id
  ORDER BY g.id
      ), 
 usercount AS(
     Select COALESCE(c.id, w.id) as id, COALESCE(nodeusercount, 0) as nodeusercount, COALESCE(wayusercount, 0) as wayusercount, 
  (COALESCE(nodeusercount, 0) + COALESCE(wayusercount, 0)) as usercount
  From nodeuserCount c full outer join wayuserCount w ON c.id = w.id
  ORder by COALESCE(c.id, w.id) 
     ),
-- Average Attributes
maxversionattributes AS(
     Select n.id, MAX(n.version) as maxversion, n.type, count(n.*) as attributecount
     From all_tags n
     Where n.event = 'ghost ship' AND n."timestamp" > '2016-11-02 00:00:00-04' AND n.timestamp < '2016-12-02' 
     Group by n.id, n.type
    ),
nodeattributecount AS(    
    Select g.id, t.attributecount as nodeattributecount
    From nodes n 
     	join maxversionattributes t ON n.id = t.id::bigint,
     	ghostship_grid_metric_30 g
    WHERE st_within(n.geom, st_transform(g.geom,4326)) 
  		AND n.event = 'ghost ship' 
     	AND n."timestamp" > '2016-11-02 00:00:00-04' AND n.timestamp < '2016-12-02'  
     	AND n.version = t.maxversion
     Group by g.id, t.attributecount
     ),
wayattributecount AS(
    Select g.id, t.attributecount as wayattributecount
    From way_nodes_centroids n 
     	join maxversionattributes t ON n.way_id = t.id,
     	ghostship_grid_metric_30 g
    WHERE st_within(n.centroid, st_transform(g.geom,4326) )
  		AND n.event = 'ghost ship' 
     	AND n."timestamp" > '2016-11-02 00:00:00-04' AND n.timestamp < '2016-12-02' 
     	AND n.version = t.maxversion
     Group by g.id, t.attributecount
     ),
attributecount AS(
    Select COALESCE(n.id, w.id) as id, COALESCE(nodeattributecount, 0) as nodeattributecount, 
    COALESCE(wayattributecount, 0) as wayattributecount, 
    (COALESCE(nodeattributecount, 0) + COALESCE(wayattributecount, 0)) as attributecount
    From nodeattributecount n full outer join wayattributecount w ON n.id = w.id 
    )
Select g.id, ac.nodecount, ac.waycount, ac.counts, 
	av.avgversion, 
    au.nodeusercount, au.wayusercount, au.usercount, 
    aa.nodeattributecount, aa.wayattributecount, aa.attributecount
From ghostship_grid_metric_30 g 
		 LEFT JOIN allcounts ac ON g.id = ac.id
         LEFT JOIN averageversions av ON g.id = av.id
     	 LEFT JOIN usercount au ON g.id = au.id
     	 LEFT JOIN attributecount aa ON g.id = aa.id
 ORDER by ac.counts