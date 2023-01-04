## Trabajo práctico 6: Python-QGIS

La consigna consiste en georeferenciar las capitales departamentales de la provincia de Corrientes en QGIS, buscar un shapefile con las rutas provinciales (en el trabajo sumamos las nacionales), generar una matriz de OD entre las ciudades y calcular la ruta más rápida entre dos de ellas.

En el archivo "capit_ctes_georef.csv" se encuentran las capitales georeferenciadas, en "OD_matrix_capit_ctes.csv" la matriz de OD y "Ruta de Santo Tome a Bella Vista..jpeg" contiene el mapa con la ruta más rápida entre Santo Tomé y Bella Vista. En la carpeta scripts están los códigos de Python con las tareas realizadas, mientars que la carpeta files contiene los shapefiles con las capitales de los departamentos, sus límites y las rutas de la provincia. 

Para realizar este trabajo, empleamos el paquete QNEAT3 de QGIS. La estrategia de optimización de ruta más rápida de QNEAT3 utiliza un campo de velocidad con valores que están en kilómetros por hora (km/h). Usando este campo, el costo de salida en la matriz OD es en segundos. La velocidad que usamos fue de 9,7844 --> (1 / (0.6213712 × 0.16448)) siendo el denominador millas por km x costo en dólares por milla. Este campo lo calculamos basandonos en los siguientes datos:

* Tomamos un promedio de 0,1 litros de nafta por kilómetro recorrido (https://parabrisas.perfil.com/noticias/noticias/cuanto-cuesta-por-kilometro-una-salida-con-el-auto.phtml), y eso nos dio 0,16 litros por milla.
* Siguiendo https://es.globalpetrolprices.com/Argentina/gasoline_prices/, el precio de un litro de nafta el 8/8/22 era de 1,028 USD en Argentina, lo que nos da un costo por milla de 0,16448. 

Para la matriz OD, usamos una tolerancia de 6 y un default speed = 6.966857 (replicando la velocidad default que emplean Sebastian Hohmann y Giorgio Chiovelli).

Rutas nacionales: https://datos.transporte.gob.ar/dataset/rutas-nacionales

Rutas provinciales: https://datos.transporte.gob.ar/dataset/rutas-provinciales



Créditos a Sebastian Hohmann y Giorgio Chiovelli por su curso de investigación en QGIS y a Maria Amelia Gibbons por sus clases y archivos.
