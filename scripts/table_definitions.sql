-- way_nodes_centroids definition
Select w.id as way_id, st_centroid(st_union(n.geom)) as centroid, n.timestamp, w.event into way_nodes_centroids
from way_nodes w JOIN nodes n On w.ref::bigint = n.id
Group by w.id, n.timestamp, w.event