###################### Tarea 1 - Data Visualization ############################
##################### Catalina Banfi y Matias Lima ############################


#Cargamos las librerias necesarias
library("ggplot2")
library("tibble")
library("gridExtra")
library("dplyr")
library("Lock5Data")
library("ggthemes")
library("fun")
library("zoo")
library("corrplot")
library("maps")
library("mapproj")
library("ggthemes")
library("purrr")


# Seteamos directorio de trabajo

setwd("C:/Users/catal/OneDrive - Facultad de Cs Económicas - UBA/UdeSA/Herramientas computacionales/Clase 5")
getwd()


# Cargamos las bases de datos 
df <- read.csv("data/gapminder-data.csv")
df2 <- read.csv("data/xAPI-Edu-Data.csv")
df3 <- read.csv("data/LoanStats.csv")


str(df)
str(df2)
str(df3)

# “The color palette can be found at: “http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf”


---------------------------------------------------------------------------
# Grafico 1 ---------------------------------------------------------------

# Se quiere ver la distribución de las cantidades de los préstamos para diferentes grados de crédito.
# Objetivo: Trazar el monto del préstamo para diferentes grados de crédito usando el faceting.

#Grafico hecho en clase
df3s <- subset(df3,grade %in% c("A","B","C","D","E","F","G"))
pb1<-ggplot(df3s,aes(x=loan_amnt))
pb1
pb2<-pb1+geom_histogram(bins=10,fill="cadetblue4")
pb2
#Facet_wrap
pb3<-pb2+facet_wrap(~grade) 
pb3
#Free y coordinate for the subplots
pb4<-pb3+facet_wrap(~grade, scale="free_y")
pb4 



#Grafico Corregido
df3s <- subset(df3,grade %in% c("A","B","C","D","E","F","G"))
pb1<-ggplot(df3s,aes(x=loan_amnt))
pb1
pb2<-pb1+geom_histogram(bins=10,fill="cadetblue4")
pb2
#Facet_wrap
pb3<-pb2+facet_wrap(~grade) 
pb3
#Free y coordinate for the subplots
pb4<-pb3+facet_wrap(~grade, scale="free_y")
pb4 + labs(x = "", title= "Monto del préstamo para diferentes grados de crédito", 
           y = "Cantidad de clientes") + theme_minimal()



---------------------------------------------------------------------------
# Grafico 2 ---------------------------------------------------------------

#Grafico hecho en clase

dfs <- subset(df,Country %in% c("Germany","India","China","United States"))
var1<-"Electricity_consumption_per_capita"
var2<-"gdp_per_capita"
name1<- "Electricity/capita"
name2<- "GDP/capita"
# Change color and shape of points
p1<- ggplot(dfs,aes_string(x=var1,y=var2))+
  geom_point(color=2,shape=2)+xlim(0,10000)+xlab(name1)+ylab(name2)
p1
#Grouping points by a variable mapped to colour and shape
p2 <- ggplot(dfs,aes_string(x=var1,y=var2))+
  geom_point(aes(color=Country,shape=Country))+xlim(0,10000)+xlab(name1)+ylab(name2)
grid.arrange(p1, p2, nrow = 2)
p2


#Grafico corregido


fig1 <- ggplot(dfs,aes_string(x=var1,y=var2))+
  geom_point(aes(color=Country))+xlim(0,10000)+xlab("")+ylab("") +
  labs(title="Consumo de electricidad (eje X) vs PBI (eje Y)", 
       subtitle= "En términos per cápita")

fig1




fig2 = fig1 +  
  geom_text(x=7500, y=45000, label="Alemania", colour="olivedrab", size = 3.5) + 
  geom_text(x=9500, y=33000, label="Estados Unidos", colour="mediumorchid2", size = 3.5) + 
  geom_text(x=3800, y=11000, label="China", colour="indianred2", size = 3.5) + 
  geom_text(x=1000, y=8000, label="India", colour="deepskyblue2", size = 3.5) + 
 scale_color_manual(values=c("indianred2", "olivedrab", "deepskyblue2", "mediumorchid2")) +
  theme_minimal() + theme(legend.position = "none") +
  theme(
    panel.grid.major = element_blank(),
    panel.border = element_blank(),
    panel.grid.minor = element_blank(),
    axis.line = element_line(colour = "grey")
  ) +
  theme(panel.border = element_rect(colour = "grey", fill = NA),
            panel.grid.major = element_line(colour = "#E5E7E9", size=0.0001, linetype = "dashed"),
            panel.grid.minor = element_blank(),
            panel.background = element_rect(fill="white")
   )


fig2

---------------------------------------------------------------------------
# Grafico 3 ---------------------------------------------------------------

## Este grafico muestra la cantidad de peliculas categorizadas segun genero realizadas durante 2013
### por diferentes estudios cinematograficos

# Grafico hecho en clase
dfn <- subset(HollywoodMovies2013, Genre %in% c("Action","Adventure","Comedy","Drama","Romance")
              & LeadStudio %in% c("Fox","Sony","Columbia","Paramount","Disney"))
p1 <- ggplot(dfn,aes(Genre,WorldGross)) 
p1
p2 <- p1+geom_bar(stat="Identity",aes(fill=LeadStudio),position="dodge")
p2
p3 <- p2+theme(axis.title.x=element_text(size=15),
               axis.title.y=element_text(size=15),
               plot.background=element_rect(fill="gray87"),
               panel.background = element_rect(fill="beige"),
               panel.grid.major = element_line(color="Gray",linetype=1)
)
p3


dfn <- subset(HollywoodMovies2013, Genre %in% c("Action","Adventure","Comedy","Drama","Romance")
              & LeadStudio %in% c("Fox","Sony","Columbia","Paramount","Disney"))
p1 <- ggplot(dfn,aes(Genre,WorldGross)) 
p1
p2 <- p1+geom_bar(stat="Identity",aes(fill=LeadStudio),position="dodge")
p2
p7b <- p2+theme_economist()+ggtitle("theme_economist()")+scale_colour_economist()
p7b




# Grafico corregido 1
## En este queremos ver con mas detenimiento el Gross World, cuanto es generado por cada tipo de pelicula y cuanto por cada estudio cinematrografico

positions <- c("Action", "Comedy", "Drama", "Adventure", "Romance")

p1 <- ggplot(dfn,aes(x = Genre, y=WorldGross)) + geom_bar(stat="identity", fill = "lightseagreen") + scale_x_discrete(limits = positions)
p2 <- p1 +ggtitle("theme_minimal()") +  theme_minimal() +
  xlab("") + 
  ylab("") +
  labs(title = "Ganancia bruta mundial (USD) - peliculas 2013", subtitle="Por género") +
  theme(
    panel.grid.major = element_blank(),
    panel.border = element_blank(),
    panel.grid.minor = element_blank(),
    axis.line = element_line(colour = "grey")
  )

positions2 <- c("Fox", "Paramount", "Disney", "Sony", "Columbia")
p3 <- ggplot(dfn,aes(LeadStudio,WorldGross)) + geom_bar(stat="identity", fill = "mediumorchid") + scale_x_discrete(limits = positions2)
p4 <- p3 +ggtitle("theme_minimal()") +  theme_minimal() +
  xlab("") + 
  ylab("") +
  labs(subtitle="Por estudio cinematográfico", title = "") + theme(
    panel.grid.major = element_blank(),
    panel.border = element_blank(),
    panel.grid.minor = element_blank(),
    axis.line = element_line(colour = "grey")
  )
  
peliculascorr1 <- grid.arrange(p2,p4,ncol=2) 



# Grafico corregido 2

peliculascorr2 = ggplot(dfn, aes(x=Genre, fill = LeadStudio)) +
  geom_bar(position = "stack") + theme_bw() +
  scale_colour_economist() + 
  xlab("") + 
  ylab("") +
  theme(legend.position = "top") +
  theme(legend.title = element_blank()) +
  labs(title= "Peliculas por género y estudio cinematográfico", subtitle = "Cantidad realizada durante 2013") +
  theme(panel.border = element_rect(colour = "grey", fill = NA),
        panel.grid.major = element_line(colour = "#E5E7E9", size=0.0001, linetype = "dashed"),
        panel.grid.minor = element_blank(),
        panel.background = element_rect(fill="white")
  )


peliculascorr2 




