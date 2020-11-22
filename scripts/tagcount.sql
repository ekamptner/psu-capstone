Select type, k, v,  count(v)
From all_tags
Where event = 'ghost ship' and timestamp > '2016-12-02' 
Group by v, k, type
Order by type, count(v) desc

-- ghost ship
Select timezone('UTC',timestamp), id, k, v, type
from all_tags
Where event = 'ghost ship' and timestamp > '2016-12-02' and timestamp < '2017-01-02' and id||k||v||type not in 
(Select id||k||v||type from all_tags where timestamp < '2016-12-02' and timestamp > '2017-01-02' and event = 'ghost ship')
Order by timestamp

Select k||', '||v, count(k||', '||v)
from all_tags
Where event = 'ghost ship' and timestamp > '2016-12-02' and timestamp < '2017-01-02' and id||k||v||type not in 
(Select id||k||v||type from all_tags where timestamp < '2016-12-02' and timestamp > '2017-01-02' and event = 'ghost ship')
Group by k,v
Order by count(k||', '||v) desc

-- grenfell
Select timezone('+01:00',timestamp), id, k, v, type
from all_tags
Where event = 'grenfell' and timestamp > '2017-06-14' and timestamp < '2017-07-14' and id||k||v||type not in 
(Select id||k||v||type from all_tags where timestamp < '2017-06-14' and timestamp > '2017-07-14' and event = 'grenfell')
Order by timestamp

Select k||', '||v, count(k||', '||v)
from all_tags
Where event = 'grenfell' and timestamp > '2017-06-14' and timestamp < '2017-07-14' and id||k||v||type not in 
(Select id||k||v||type from all_tags where timestamp < '2017-06-14' and timestamp > '2017-07-14' and event = 'grenfell')
Group by k,v
Order by count(k||', '||v) desc

-- plasco
Select timezone('UTC',timestamp), id, k, v, type
from all_tags
Where event = 'plasco' and timestamp > '2017-01-19' and timestamp < '2017-02-19' and id||k||v||type not in 
(Select id||k||v||type from all_tags where timestamp < '2017-01-19' and timestamp > '2017-02-19' and event = 'plasco')
Order by timestamp

Select k||', '||v, count(k||', '||v)
from all_tags
Where event = 'plasco' and timestamp > '2017-01-19' and timestamp < '2017-02-19' and id||k||v||type not in 
(Select id||k||v||type from all_tags where timestamp < '2017-01-19' and timestamp > '2017-02-19' and event = 'plasco')
Group by k,v
Order by count(k||', '||v) desc

