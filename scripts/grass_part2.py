import sys
import os
import atexit

from grass.script import parser, run_command

def cleanup():
    pass

def main():

    list = ['123633', '135163', '933797', '1835512', '2760218', '4225299']

    for uid in list:
        run_command("v.extract",
                    overwrite = True,
                    input = "event_user_nodes_ghostship@PERMANENT",
                    layer = "1",
                    type = "point,line,boundary,centroid,area,face",
                    where = "uid=" + uid,
                    output = "filtered",
                    new = -1)

        run_command("v.delaunay",
                    flags = 'l',
                    overwrite = True,
                    input = "filtered",
                    layer = "-1",
                    output = "delaunay")

        run_command("v.out.ogr",
                    flags = 'c',
                    overwrite = True,
                    input = "delaunay",
                    layer = "1",
                    type = "auto",
                    output = "C:\Users\Erola\Documents\Penn State\Capstone\data\part2\delaunay_working\ghostship_delaunay\delaunay_" + uid +".shp",
                    format = "ESRI_Shapefile",
                    output_layer = "delaunay_"+uid,
                    output_type = "line")
    return 0

if __name__ == "__main__":
    options, flags = parser()
    atexit.register(cleanup)
    sys.exit(main())
