import os
    
for layer in os.listdir("C:\Users\Erola\Documents\Penn State\Capstone\data\part2\delaunay_working\ghostship_delaunay"):
    if layer.endswith('.shp'):
        print(layer +  " Complete")

        # Generate delaunay triangulation
        outputs_QGISFIELDCALCULATOR_1=processing.runalg('qgis:fieldcalculator', layer,'length',0,10.0,3.0,True,'$length',None)

        print(layer + "complete")


