 -- Clean up Scripts
 -- update event field from filename
    
Update public.relations
    Set event = 'ghost ship'
    Where event like '%california%';
    
    
Update public.relations
    Set event = 'plasco'
    Where event like '%iran%';
         
    
Update public.relations
    Set event = 'grenfell'
    Where event like '%london%';
    
    
Update public.relations
    Set event = 'kilinto'
    Where event like '%ethiopia%';
 
 -- proper cast
    
Update public.relations
    Set id = id_txt::bigint, uid = uid_txt::bigint;
    


-- Update user tables
With CTE AS (Select distinct n.uid, n.user, n."event"
from nodes as n
Where n.event = 'plasco' and n.timestamp > '2017-01-18' and n.timestamp < '2017-02-18'
UNION
Select distinct n.uid, n.user, n."event"
from ways as n
Where n.event = 'plasco' and n.timestamp > '2017-01-18' and n.timestamp < '2017-02-18'        
UNION
Select distinct n.uid, n.user, n."event"
from relations as n
Where n.event = 'plasco' and n.timestamp > '2017-01-18' and n.timestamp < '2017-02-18')
Insert into public.users Select distinct uid, "user", event from CTE;