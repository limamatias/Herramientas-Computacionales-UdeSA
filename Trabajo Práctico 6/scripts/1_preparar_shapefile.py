# Script armado por Catalina Banfi y Matías Lima, utilizando material del curso de QGIS de Giorgio Chiovelli y Sebastian Hohmann,
# y adaptaciones de María Amelia Gibbons.

import processing
from processing.core.Processing import Processing
Processing.initialize()
QgsApplication.processingRegistry().addProvider(QgsNativeAlgorithms())
#########################################################################################
#########################################################################################

from geoprocess import GeoProcess


# Seleccionamos las rutas para los inputs y outputs
mainpath = "/Clases Herramientas Computacionales/6. PyQGIS/tarea"
outpath = "{}/output".format(mainpath)

capit_ctes = "{}/input/shapefile_capit_ctes.shp".format(mainpath)
rutas_prov = "{}/input/rutas_prov/_3_4_1_7_red_vial_ign_ont_a_prov_view.shp".format(mainpath)
rutas_nac = "{}/input/rutas_nac/_3_4_1_1_6_rutas_nacionales_dnv18_view.shp".format(mainpath)


gp = GeoProcess()




###########################################################################
###########################################################################
###########################################################################

######################################################################
# Reproyección de las capitales departamentales, las rutas provinciales y las rutas nacionales a WGS84.
######################################################################
print('reprojecting routes and capital cities to WGS84')
capit_ctes_wgs84 = gp.reproject_layer(capit_ctes, 'EPSG:4326')
rutas_prov_wgs84 = gp.reproject_layer(rutas_prov, 'EPSG:4326')
rutas_nac_wgs84 = gp.reproject_layer(rutas_nac, 'EPSG:4326')

######################################################################
# Unión entre las rutas nacionales y provinciales.
######################################################################

rutas = gp.union(rutas_prov_wgs84, rutas_nac_wgs84)

######################################################################
# Reajustamos la posición de las capitales para coincidir con la ruta más cercana
######################################################################

capit_reajustadas = gp.snap_geometries(capit_ctes_wgs84, rutas, 0.01)

######################################################################
# Reproyectamos las rutas a ESRI:54034
######################################################################

rutas_ESRI = gp.reproject_layer(rutas, 'ESRI:54034')

######################################################################
# Calculamos los costos finales
######################################################################


# Tomamos un promedio de 0,1 litros de nafta por kilómetro recorrido (https://parabrisas.perfil.com/noticias/noticias/cuanto-cuesta-por-kilometro-una-salida-con-el-auto.phtml)
# lo que nos nos da 0,16 litros por milla. 
# Siguiendo https://es.globalpetrolprices.com/Argentina/gasoline_prices/, el precio de un litro de nafta el 8/8/22 era de 
# 1,028 dólares en Argentina, lo que nos da un costo por milla de 0,16448.
print('Calculando costos finales')
millas_por_km=0.6213712
dolares_por_milla=0.16448
formula = '''CASE
 WHEN ("type" = 'trail') THEN "len_km"*{}
END
'''.format(millas_por_km*dolares_por_milla)
rutas_ESRI = gp.generic_field_calculator(rutas_ESRI, 'cost', 'float', formula, field_precision=6)

################################################################
# QNEAT3 necesita "speed", no puede manejar "cost"
################################################################


formula = '''CASE
 WHEN ("type" = 'trail') THEN {}
END 
'''.format(1/(millas_por_km*dolares_por_milla))
rutas_ESRI = gp.generic_field_calculator(rutas_ESRI, 'speed', 'float', formula, field_precision=6)

gp.drop_fields(rutas_ESRI, keep_fields=['len_km', 'type', 'cost', 'speed'], output_object=rutas_prov)







