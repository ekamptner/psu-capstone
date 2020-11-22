-- London: Grenfell Tower Building  '2017-06-14' 
Select date_trunc('day', n.timestamp), count(n.*) as nodes
from relations as n
Where n.filename like '%london%' 
and n.timestamp > '2017-06-13'
and n.timestamp < '2017-07-13' 
Group by date_trunc('day', n.timestamp)
Order by date_trunc('day', n.timestamp);


Create View grenfell_gridstat_after as (
Select g.id, count(distinct n.id) as nodecount, round(avg(version::int),2) as avgversion, count(t.*) as attributecount, count(distinct n.uid) as usercount
From nodes n left join node_tags t on t.id = n.id, grenfell_grid g
Where ST_Within(n.geom, g.geom)
And n.event = 'grenfell'
-- And n.timestamp > '2017-06-14'
Group by g.id
Order by g.id
    )
                                        

Update View grenfell_gridstat_after as (SELECT g.id,
    count(DISTINCT n.id) AS nodecount,
    round(avg(n.version::integer), 2) AS avgversion,
    count(t.*) AS attributecount,
    count(DISTINCT n.uid) AS usercount
   FROM nodes n
     LEFT JOIN node_tags t ON t.id = n.id,
    grenfell_grid g
  WHERE st_within(n.geom, g.geom) AND n.event::text = 'grenfell'::text AND n.timestamp > '06-14-2017'                                     
  GROUP BY g.id
  ORDER BY g.id);