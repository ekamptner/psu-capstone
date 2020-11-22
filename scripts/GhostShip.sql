-- Oakland: Ghost Ship Warehouse  '2016-12-02' 
Select date_trunc('day', n.timestamp), count(n.*) as nodes
from relations as n
Where n.filename like '%california%' 
and n.timestamp > '2016-12-01'
and n.timestamp < '2017-01-01' 
Group by date_trunc('day', n.timestamp)
Order by date_trunc('day', n.timestamp);