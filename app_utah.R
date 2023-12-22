library(shiny)
library(leaflet)
library(dplyr)
library(RColorBrewer)
library(RCurl)
library(htmltools)

df <- read.csv("C:/Users/Cal/Downloads/Utah_Earthquake_Epicenters_1850_to_2016.csv")



ui <- bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  tags$h4(
    tags$div(class="text-center", "Utah Earth Quakes 1850 - 2016 (Magnitude > 5)")),
  tags$h6(
    tags$div(class="text-center", "https://opendata.gis.utah.gov")),
  leafletOutput("map", width = "100%", height = "100%")
)

server <- function(input, output, session) {
  outline <- df[chull(df$Long, df$Lat),]
  
  M5 <- df %>%
    filter(df$Mag > 5)
  
  output$map <- renderLeaflet({
    leaflet(df) %>% addTiles() %>% #addCircles(~Long, ~Lat, ~10^Mag/6, color = "red") %>%
      addProviderTiles(providers$Esri.WorldStreetMap) %>%
      addMarkers(data = M5, ~M5$Long, ~M5$Lat, popup = ~as.character(M5$Year), label = ~as.character(M5$Mag), group = "5 Magnitude") %>%
      addPolygons(data = outline, lng = ~Long, lat = ~Lat,
                  fill = F, weight = 2, color = "black", group = "Outline") %>%
      fitBounds(~min(Long), ~min(Lat), ~max(Long), ~max(Lat)) %>%
      addLayersControl(
        overlayGroups = c("Outline"),
        options = layersControlOptions(collapsed = FALSE)
      )
  })
}

shinyApp(ui, server)