import subprocess
import os

os.chdir("C:/Program Files/PostgreSQL/9.6/bin")
# '3862886',
list = ('18069','3626968','25975','359757','123633','135163','3381552','2969887','339581','5713','3545587','322039',
        '1967717','933797','3941637','873940','1835512','3432400','2357857','2760218','763799','3360520','113813','1468043','24119','1016290','3743902',
        '3790533','481116','142831','4225299','4227883','4356388','4449060','4705905','4834184','4847578','4868563','4977128','5082288','5156848','5168616',
        '5212793','5281566','5315254')

for uid in mylist:
    fileoutput = "C:/capstonedata/dissolved/" + uid
    query = "SELECT ST_Union(geometry) FROM input" + uid
    command = 'ogr2ogr "%s" -h 127.0.0.1 -p 5433 -u postgres -P postgres -g geom osm "%s"' %(fileoutput,query)
    ogr2ogr output.shp input.shp -dialect sqlite -sql 


    print command

    subprocess.call(command)

    print uid + " complete"
