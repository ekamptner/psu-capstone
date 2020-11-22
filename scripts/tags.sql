Select k, v, timestamp, count(*) from all_tags
Where timestamp > '2017-06-13' and timestamp < '2017-06-23' and event = 'grenfell'
Group by k, v, timestamp
Order by Count(*) desc

Select k, v, timestamp, count(*) from all_tags
Where timestamp > '2017-06-13' and timestamp < '2017-06-23' and event = 'grenfell'
Group by k, v, timestamp
Order by Count(*) desc



Select k, v, timestamp, count(*) from all_tags
Where timestamp > '2016-12-02' and timestamp < '2016-12-12' and event = 'ghost ship'
Group by k, v, timestamp
Order by Count(*) desc