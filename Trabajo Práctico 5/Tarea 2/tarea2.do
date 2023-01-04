/************************************************************************************
Tarea 2 correspondiente a la quinta clase de Herramientas Computacionales para Investigación.
Grupo: Catalina Banfi y Matías Lima

Archivo basado en el tutorial adaptado por María Amelia Gibbons del curso de Econometría Espacial de Marcos Herrera.
*/

** Guardamos el path bajo el nombre DATA
global DATA = "/Clases Herramientas Computacionales/5. Data Visualization/videos_2_3/data" 
cd "$DATA"

** Instalamos los paquetes necesarios para realizar la tarea.
* ssc install spmap
* ssc install shp2dta
* net install spwmatrix, from(http://fmwww.bc.edu/RePEc/bocode/s)

** Leer la información shape en Stata: este archivo trae los límites de los municipios de Londres, su población y el porcentaje de personas que practican deportes.
shp2dta using london_sport.shp, database(ls) coord(coord_ls) genc(c) genid(id) replace

/* El comando anterior genera dos nuevos archivos: ls.dta y coord_ls.dta
El primero contiene los atributos (variables) del shape. 
El segundo contiene la información sobre las formas geográficas. 
Se generan en el archivo de datos tres variables:
id: identifica a la región. 
c: genera el centroide por medio de las variables x_c (longitud) e y_c (latitud).
*/

** Importamos y transformamos los datos del archivo CSV a formato Stata: este archivo trae datos de crímenes (por tipo) según los municipios de Londres para 2011
import delimited "$DATA/mps-recordedcrime-borough.csv", clear 

** Necesitamos que la variable que vamos a usar el join tenga el mismo nombre en ambas bases, por lo que la renombramos en la de crimen. 
rename borough name
keep if crimetype=="Theft & Handling" //Nos quedamos solo con los robos.
collapse (sum) crimecount, by(name) //Agregamos la cantidad de crímenes por municipio.
replace name = "City of London" if name == "NULL" //Arreglamos el nombre de los datos para este municipio.
gen abbr =upper(substr(name,1,3))
save "theft.dta", replace //Guardamos la nueva base como archivo .dta. 

** Unimos ambas bases: ls y theft. Se usa la función merge con la variable name que se encuentra en ambas bases.

use ls, clear
merge 1:1 name using theft.dta, keep(3) nogen
save london_theft_shp.dta, replace //Guardamos la base con el merge hecho.

** Creamos un mapa utilizando el comando spmap, asignando los distintos parámetros.
spmap crimecount using coord_ls, id(id) clmethod(q) cln(4) title("Total de robos por municipio", size(*0.9)) subtitle("Londres (2011)", size(*0.7)) legstyle(2) legend(size(small) position(5) xoffset(14.05)) fcolor(YlOrBr) plotregion(margin(b+15)) ndfcolor(gray) name(theft_map,replace) label(data(london_theft_shp) xcoord(x_c) ycoord(y_c) label(abbr) size(*0.5 ..) pos(0 0))

graph export "stata_map.png", replace //Guardamos el gráfico como PNG.

