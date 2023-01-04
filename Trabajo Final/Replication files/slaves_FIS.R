## Trabajo final de Herramientas Computacionales para Investigación
## Alumnos: Catalina Banfi y Matías Lima
## Docente: María Amelia Gibbons

## En este script creamos un gráfico con ggplot2 para buscar ilustrar una regresión básica entre el comercio de esclavos africano y el Fragile States Index de 2022.

# Cargamos los paquetes 

library(tidyr)
library(dplyr)
library(scales)
library(ggplot2)

# Elegimos el directorio de trabajo.
setwd("C:/Clases Herramientas Computacionales/Trabajo final/") 

# Cargamos la base trabajada en QGIS, incluyendo las distintas tribus trabajadas por Nunn & Wantchikon (2011), los individuos tomados como esclavos en sus territorios y el país actual con el que se corresponden.
tribe_slaves_country <- read.csv("output/tribes_countries_slaves.csv") 

# Arreglamos el nombre de Costa de Marfil.
tribe_slaves_country1 <- tribe_slaves_country %>% 
  mutate(COUNTRY = replace(COUNTRY, COUNTRY == "CÃ¯Â¿Â½te d\'Ivoire", "Côte d'Ivoire"))   

# Hacemos la suma del total de esclavos por país.
slaves_country <- tribe_slaves_country1 %>% 
  group_by(COUNTRY) %>% 
  summarise(TOTAL_ATLANTIC = sum(TOTAL_ATLANTIC), TOTAL_INDIAN = sum(TOTAL_INDIAN))

# Arreglamos los NA en esclavos y una observación vacía, además de transformar columnas a numeric.
slaves_country1 <- slaves_country %>% mutate(TOTAL_ATLANTIC = replace(TOTAL_ATLANTIC, is.na(TOTAL_ATLANTIC), "0")) %>%
  mutate(TOTAL_INDIAN = replace(TOTAL_INDIAN, is.na(TOTAL_INDIAN), "0")) %>% 
  filter(COUNTRY != "") %>% 
  mutate(TOTAL_ATLANTIC = as.numeric(TOTAL_ATLANTIC), TOTAL_INDIAN = as.numeric(TOTAL_INDIAN))


# Creamos una variable con el total de esclavos.

slaves_country2 <- slaves_country1 %>% mutate(slaves_country1,TOTAL_SLAVES = TOTAL_ATLANTIC + TOTAL_INDIAN)

# Recuperamos el prefijo de los países.

slaves_country3 <- slaves_country2 %>% 
  left_join(tribe_slaves_country1, by="COUNTRY") %>% 
  group_by(COUNTRY) %>% 
  mutate(number = 1) %>% 
  mutate(ticker = cumsum(number)) %>% 
  slice(1) %>%
  ungroup() %>% 
  mutate(TOTAL_ATLANTIC = TOTAL_ATLANTIC.x, TOTAL_INDIAN = TOTAL_INDIAN.x) %>% 
  filter(ISO3 != "") %>% 
  select(COUNTRY, ISO3, TOTAL_ATLANTIC, TOTAL_INDIAN, TOTAL_SLAVES)

# Cargamos una base con la población de los países en 2021 (Fuente: Banco Mundial)
population <- read.csv("input/population.csv", sep=";") 

slaves_pop_country <- slaves_country3 %>%
  left_join(population, by="ISO3") %>% 
  mutate(POP = X2021_pop, SLAVES_POP = log(TOTAL_SLAVES/X2021_pop), SLAVES_LOG = log(TOTAL_SLAVES)) %>% 
  select(COUNTRY, ISO3, TOTAL_ATLANTIC, TOTAL_INDIAN, TOTAL_SLAVES, SLAVES_LOG, POP, SLAVES_POP)

# Cargamos una base con los datos del Fragile States Index para 2022.

fsi_2022 <- read.csv("input/fsi_2022.csv", sep=";", dec = ",") 

final_countries <- slaves_pop_country %>% 
  left_join(fsi_2022, by="ISO3") %>% 
  mutate(FSI = Total) %>% 
  select(COUNTRY, ISO3, TOTAL_ATLANTIC, TOTAL_INDIAN, TOTAL_SLAVES, SLAVES_LOG, FSI, POP, SLAVES_POP)

# Creamos el gráfico relacionando FSI y esclavos totales (en logaritmo).

slaves_FSI <- ggplot(final_countries, x=FSI, y=SLAVES_LOG, label=ISO3) +
  geom_jitter(aes(x = FSI, y = SLAVES_LOG), color = "red") +
  geom_smooth(aes(x = FSI, y = SLAVES_LOG), method='lm', se=FALSE) +
  scale_fill_gradient(trans="pseudo_log") + 
  theme_classic() + 
  labs(x = "Fragile States Index (2022)", y = "Slaves (log)") +
  geom_text(data = final_countries, aes(x = FSI, y = SLAVES_LOG, label = ISO3, hjust=1, vjust=1, family="serif"), size=3.5)

# Guardamos el gráfico como un archivo PNG.  
ggsave("FSI_slaves.png", plot = slaves_FSI) 

                                                                      