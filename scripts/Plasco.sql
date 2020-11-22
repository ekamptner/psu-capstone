-- Tehran: Plasco Building  '2017-01-19' 
Select date_trunc('day', n.timestamp), count(n.*) as nodes, count(w.*) as ways, count(r.*) as relations
from nodes as n, ways as w, relations as r
Where n.filename like '%iran%' and w.filename like '%iran%' and w.filename like '%iran%'
and n.timestamp > '2017-01-18' and w.timestamp > '2017-01-18' and r.timestamp > '2017-01-18'
and n.timestamp < '2017-02-18' and w.timestamp < '2017-02-18' and r.timestamp < '2017-02-18'
Group by date_trunc('day', n.timestamp)
Order by date_trunc('day', n.timestamp);