# Importamos el paquete (ya estamos trabajando en esa carpeta)
from wwo_hist import retrieve_hist_data



# Setteamos el working directory para que se guarde el CSV
import os
os.chdir("C:/Maestría UdeSA/Materias UdeSA/Herramientas computacionales/3. Scrapping/WorldWeatherOnline-master")


# Código de ejemplo
frequency=24
start_date = '01-JAN-2015'
end_date = '31-DEC-2015'
api_key = '6133c8a4414e46cebb3132420221107'
location_list = ['20637','20653','20688','20724','20740','20871',
                 '21040','21043','21158','21208','21290','21502',
                 '21601','21638','21639','21643','21651','21701',
                 '21749','21804','21811','21853','21901'
                ]


hist_weather_data = retrieve_hist_data(api_key,
                                location_list,
                                start_date,
                                end_date,
                                frequency,
                                location_label = False,
                                export_csv = True,
                                store_df = True)
