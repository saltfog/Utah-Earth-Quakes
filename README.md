### Utah Earth Quakes 1850 to 2015 greater than a magnitude of 5.

#### This code is a Shiny web application using the Shiny library in R, with the purpose of visualizing earthquake epicenters in Utah from 1850 to 2016. Here's a breakdown:

```r
library(shiny)
library(leaflet)
library(dplyr)
library(RColorBrewer)
library(RCurl)
library(htmltools)
```

#### The required libraries are loaded. shiny is for building the web application, leaflet for interactive maps, and others for data manipulation and visualization.

```r
df <- read.csv("C:/Users/Cal/Downloads/Utah_Earthquake_Epicenters_1850_to_2016.csv")
```
#### Reads earthquake data from a CSV file into a data frame (df).

```r
ui <- bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  tags$h4(
    tags$div(class="text-center", "Utah Earth Quakes 1850 - 2016 (Magnitude > 5)")),
  tags$h6(
    tags$div(class="text-center", "https://opendata.gis.utah.gov")),
  leafletOutput("map", width = "100%", height = "100%")
)
```
#### Defines the user interface layout using Bootstrap. It includes a title, source attribution, and a placeholder for the leaflet map.

```r
server <- function(input, output, session) {
  outline <- df[chull(df$Long, df$Lat),]
  
  M5 <- df %>%
    filter(df$Mag > 5)
  
  output$map <- renderLeaflet({
    leaflet(df) %>% addTiles() %>%
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
```
#### Defines the server logic. It calculates the convex hull (outline) and filters earthquakes with magnitude greater than 5 (M5). The renderLeaflet function generates the dynamic leaflet map based on the data and user inputs.

```r
shinyApp(ui, server)
```

#### Initializes the Shiny app, combining the UI and server components.

In summary, this Shiny app displays earthquake epicenters in Utah with a magnitude greater than 5 on an interactive map. The map includes markers for these earthquakes, a convex hull outline, and layers control for toggling the display of different map elements.


![Utah Quakes](https://github.com/saltfog/Utah-Earth-Quakes/assets/4485016/f8447c18-e28f-47ad-be95-7377d135a476)
