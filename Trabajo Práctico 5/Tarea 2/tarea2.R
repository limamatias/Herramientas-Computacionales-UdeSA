## Tarea 2 correspondiente a la quinta clase de Herramientas Computacionales para Investigación.
## Grupo: Catalina Banfi y Matías Lima

## Definimos las librerías que vamos a utilizar.
x <- c("ggmap", "rgdal", "rgeos", "dplyr", "tmap", "broom")

## Instalamos las librerías (en caso de no tenerlas instaladas).
#install.packages(x) 

## Cargamos las librerías requeridas.
lapply(x, library, character.only = TRUE) 

## Definimos el directorio de trabajo.
setwd("C:/Clases Herramientas Computacionales/5. Data Visualization/videos_2_3") 

## Cargamos el shapefile con los municipios de Londres y datos de población, creando el objeto "lnd".
lnd <- readOGR(dsn = "data/london_sport.shp") 

## Creamos un objeto cargando datos de crímenes (por tipo) en Londres desde un archivo CSV.
crime_data <- read.csv("data/mps-recordedcrime-borough.csv",
                       stringsAsFactors = FALSE)

## Extraemos los datos referentes al tipo Theft & Handling.
crime_theft <- crime_data[crime_data$CrimeType == "Theft & Handling", ]

## Calculamos el total de robos por municipio, guardando el resultado.
crime_ag <- aggregate(CrimeCount ~ Borough, FUN = sum, data = crime_theft)

## Cambiamos el nombre del dato NULL en el DF crime_ag, ya que se corresponde con City of London.
crime_ag <- mutate(crime_ag, Borough = recode(Borough, 'NULL' = 'City of London'))

## Agregamos una variable con la abreviatura de cada municipio en mayúsculas.
crime_ag$abbr <- toupper(substr(crime_ag$Borough, 0, 3))



## Hacemos un left join entre las bases, indicando que el enlace lo haremos entre las variables que contienen el nombre del municipio en cada base.
lnd@data <- left_join(lnd@data, crime_ag, by = c('name' = 'Borough'))


## Creamos un mapa usando la función qtm, del paquete tmap. 
tmap_map <- qtm(shp = lnd, fill = "CrimeCount", fill.palette = "Blues", fill.title = "Crímenes", main.title = "Total de robos por municipio en Londres (2011)", main.title.position = "center", text = 'abbr', text.size = 0.5, style="gray", fill.labels=c("1 a 20000", "20001 a 40000", "40001 a 60000", "60001 a 80000")) + tm_scale_bar(position = c("left", "bottom"))

## Guardamos el mapa como archivo PNG.
tmap_save(tmap_map, "tmap_map.png")


## Para poder trabajar con la función ggmap, de ggplot, tenemos que transformar los objetos espaciales, siendo necesario extraerlos como data frame. Para esto utilizamos la función tidy del paquete broom.

lnd_f <- broom::tidy(lnd)

## Generamos una columna llamada id en la base original para enumerar los municipios.
lnd$id <- row.names(lnd)

## Unimos los datos de la base original con la generada con la función broom utilizándose por default la variable que tienen en común, id.
lnd_f <- left_join(lnd_f, lnd@data)

## Creamos un mapa usando la función ggplot, del paquete ggplot2. 
ggplot_map <- ggplot(lnd_f, aes(long, lat, group = group, fill = CrimeCount)) +
  geom_polygon() + coord_equal() +
  labs(x = "Easting (m)", y = "Northing (m)",
       fill = "Cantidad de\ncrímenes") +
  ggtitle("Total de robos por municipio en Londres (2011)")
ggplot_map <- ggplot_map + geom_path(data = lnd_f, aes(x = long, y = lat, group = group), 
                                      color = "black", size = 1)
ggplot_map <- ggplot_map + scale_fill_distiller(palette = "YlOrBr", direction=1) #Agregamos la escala de colores
ggplot_map <- ggplot_map + theme(axis.ticks.x = element_blank(),axis.text.x = element_blank(),axis.ticks.y = element_blank(),axis.text.y = element_blank()) #Removemos los nombres y marcas de los ejes.
ggplot_map <- ggplot_map + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), legend.background = element_blank(), legend.box.background = element_rect(colour = "black")) #Eliminamos la grilla y el color de fondo, agregando también bordes a la leyenda.


## Guardamos el mapa como un archivo PNG.  
ggsave("ggplot_map.png", plot = ggplot_map) 
