library('RMySQL')
library('leaflet')
library('leaflet.extras')
library('htmlwidgets')

con <- dbConnect(RMySQL::MySQL(),
                 host = "tp19db.ck5zqe1er1df.ap-southeast-2.rds.amazonaws.com",
                 port = 3306,
                 dbname = "tp19db",
                 user = "admin",
                 password = "5120tp19")

dt <- dbGetQuery(con, "select `recordID`,`vernacularName`, `scientificName`, `decimalLatitude`,
          `decimalLongitude`,`eventDate`,year(eventDate) as year,`stateProvince` from possum 
                 where year(eventDate) >2000;")

dbDisconnect(con)

# dt1 <- dt[which((dt$vernacularName %in% inputvar_type)&
#                   (dt$year >= input$year[1])&(dt$year <= input$year[2]) & 
#                   (dt$stateProvince %in% inputvar_state)),]


map <- leaflet(data =dt) %>%   addProviderTiles(providers$CartoDB.Positron) %>%
                              # these markers will appear on your map:
                              addResetMapButton() %>%
                              # these markers will be "invisible" on the map:
                              addCircleMarkers(
                                data = dt, lng = ~decimalLongitude, lat = ~decimalLatitude, label = dt$vernacularName,
                                clusterOptions = markerClusterOptions(),
                                popup = ~as.character(paste('Possum type: ',vernacularName,'</br>', 
                                                            'Occurrence date: ', eventDate, '</br>', 
                                                            'Geographic location: ', stateProvince, '</br
                                                                Longitude: ', decimalLongitude, 
                                                            ', Latitude: ', decimalLatitude
                                )))

map
saveWidget(map, file = "map.html")
