-- CREATE OR REPLACE FUNCTION ContributionIndex(event text, starttime timestamp, endtime timestamp)
-- 	RETURNS TABLE(id numeric(10), nodecount bigint, waycount bigint, counts bigint, avgversion numeric, nodeusercount bigint, wayusercount bigint,
--                 usercount bigint, nodeattributecount bigint, wayattributecount bigint, attributecount bigint)
-- AS
-- $$
-- Number of nodes

 With nodeCount AS (
 SELECT g.id, count(DISTINCT n.id) AS nodecount
      FROM nodes n, grenfell_grid g
  WHERE st_within(n.geom, g.geom) AND n.event = 'grenfell' AND n."timestamp" > '2017-06-14 00:00:00-04'
  GROUP BY g.id
  ORDER BY g.id
     ),
 wayCount AS(
      SELECT g.id, count(DISTINCT w.way_id) AS waycount
      FROM way_nodes_centroids w, grenfell_grid g
  WHERE st_within(w.centroid, g.geom) AND w.event = 'grenfell' AND w."timestamp" > '2017-06-14 00:00:00-04'
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
     Where n.event = 'grenfell' AND n."timestamp" > '2017-06-14 00:00:00-04'
     Group by n.id
     ),
averageVersions AS(
 SELECT g.id, round(avg(v.maxversion), 2) AS avgversion
      FROM nodes n 
          join maxVersions v ON n.id = v.id,
          grenfell_grid g
  WHERE st_within(n.geom, g.geom) 
  AND n.event = 'grenfell' AND n."timestamp" > '2017-06-14 00:00:00-04'
  GROUP BY g.id
  ORDER BY g.id
    ),
  -- Number of users
 nodeuserCount AS (
 SELECT g.id, count(DISTINCT n.uid) AS nodeusercount
      FROM nodes n, grenfell_grid g
  WHERE st_within(n.geom, g.geom) AND n.event = 'grenfell' AND n."timestamp" > '2017-06-14 00:00:00-04'
  GROUP BY g.id
  ORDER BY g.id
     ),
 wayuserCount AS(
      SELECT g.id, count(DISTINCT w.uid) AS wayusercount
      FROM grenfell_grid g, way_nodes_centroids w
  WHERE st_within(w.centroid, g.geom) AND w.event = 'grenfell' AND w."timestamp" > '2017-06-14 00:00:00-04'
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
     Where n.event = 'grenfell' AND n."timestamp" > '2017-06-14 00:00:00-04'
     Group by n.id, n.type
    ),
nodeattributecount AS(    
    Select g.id, t.attributecount as nodeattributecount
    From nodes n 
     	join maxversionattributes t ON n.id = t.id::bigint,
     	grenfell_grid g
    WHERE st_within(n.geom, g.geom) 
  		AND n.event = 'grenfell' 
     	AND n."timestamp" > '2017-06-14 00:00:00-04' 
     	AND n.version = t.maxversion
     Group by g.id, t.attributecount
     ),
wayattributecount AS(
    Select g.id, t.attributecount as wayattributecount
    From way_nodes_centroids n 
     	join maxversionattributes t ON n.way_id = t.id,
     	grenfell_grid g
    WHERE st_within(n.centroid, g.geom) 
  		AND n.event = 'grenfell' 
     	AND n."timestamp" > '2017-06-14 00:00:00-04' 
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
From grenfell_grid g 
		 LEFT JOIN allcounts ac ON g.id = ac.id
         LEFT JOIN averageversions av ON g.id = av.id
     	 LEFT JOIN usercount au ON g.id = au.id
     	 LEFT JOIN attributecount aa ON g.id = aa.id
 ORDER by ac.counts
 
-- $$ LANGUAGE SQL;

















