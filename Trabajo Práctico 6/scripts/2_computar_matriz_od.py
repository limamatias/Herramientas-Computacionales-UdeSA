#########################################################################################
#########################################################################################
# SETUP PREAMBLE FOR RUNNING STANDALONE SCRIPTS.
# NOT NECESSARY IF YOU ARE RUNNING THIS INSIDE THE QGIS GUI.
# print('preliminary setup')
# import sys
# import os

# from qgis.core import (
#     QgsApplication,
#     QgsCoordinateReferenceSystem
# )

# from qgis.analysis import QgsNativeAlgorithms

# # See https://gis.stackexchange.com/a/155852/4972 for details about the prefix 
## Mac
# QgsApplication.setPrefixPath('/Users/magibbons/Library/Application Support/QGIS/QGIS3/profiles/default', True)
## Windows 
# QgsApplication.setPrefixPath('C:/OSGeo4W64/apps/qgis', True)
# qgs = QgsApplication([], False)
# qgs.initQgis()

# # Add the path to Processing framework  
## Mac
#sys.path.append('/Users/magibbons/Library/Application Support/QGIS/QGIS3/profiles/default/python/plugins')
## Windows
# sys.path.append('C:/OSGeo4W64/apps/qgis/python/plugins')
# sys.path.append('C:/Users/se.4537/AppData/Roaming/QGIS/QGIS3/profiles/default/python/plugins')

# # Import and initialize Processing framework
# import processing
# from processing.core.Processing import Processing
# Processing.initialize()
# QgsApplication.processingRegistry().addProvider(QgsNativeAlgorithms())
# from QNEAT3.Qneat3Provider import Qneat3Provider
# QgsApplication.processingRegistry().addProvider(Qneat3Provider())
#########################################################################################
#########################################################################################

# if run this from within QGIS python console, you have append the directory 
# containing geoprocess.py to the sys.path; that is:
import sys
# sys.path.append('/path/to/folder/containing/python_script')
#sys.path.append('C:\\Users\\giorg\\Dropbox (LBS Col_con)\\PoliteconGIS\\LBS_2020\\PhD\\lecture_5\\')
sys.path.append('C:/Archivos de Programa/QGIS 3.22.8/apps/qgis-ltr/python/plugins')

from geoprocess import GeoProcess

# set paths to inputs and outputs
#mainpath = "C:\\Users\\giorg\\Dropbox (LBS Col_con)\\PoliteconGIS\\LBS_2020\\PhD\\lecture_5\\gis_data"
mainpath = "/Clases Herramientas Computacionales/6. PyQGIS/tarea"
outpath = "{}/output".format(mainpath)

capit_ctes = "{}/capit_reajustadas.shp".format(outpath)
rutas = "{}/rutas_prov.shp".format(outpath)

gp = GeoProcess()

###########################################################################
###########################################################################
###########################################################################

print('computing origin-destination matrix')

odmat = gp.odmat_nn(rutas, capit_ctes, 'NHGISNAM', tolerance=10,
                      criterion='speed', speed_field='speed',
                      default_speed=6.966857)

print('output to csv')

gp.output_csv(odmat, out)

print('DONE!')






