library(shiny)
library(maps)
library(mapproj)
library(leaflet)
library(RColorBrewer)
library(ggplot2)
library(dplyr)
library(googleVis)

########## The Server Body  #############

shinyServer(function(input, output){
  
########### Tab1 - The Map  #############
  
  # Tab1 - Output 1 --- Interactive Map Name -----
  
    myMapName <- reactive({
     switch(input$Ratio,
           "Perceived Opportunities" = "Percentage of 18-64 population who see good opportunities to start a firm in the area where they live",
           "Perceived Capabilities" = "Percentage of 18-64 population who believe they have the required skills and knowledge to start a business",
           "Fear of Failure Rate" = "Percentage of 18-64 population who indicate that fear of failure would prevent them from setting up a business",
           "Entrepreneurial Intention" = "Percentage of 18-64 population who intend to start a business within three years")
    })
    
    output$mapname <- renderText(myMapName())
  
  # Tab1 - Output 2 --- Interactive Map ---------
    
  #  Step 1 ----- Create dynamic map inputs ----
    
  mypal <- reactive({
    colorNumeric(
      palette = switch (input$Ratio,
                        "Perceived Opportunities" = "YlOrRd",
                        "Perceived Capabilities" = "YlGn",
                        "Fear of Failure Rate" = "YlGnBu",
                        "Entrepreneurial Intention" = "RdPu"
      ),
      domain = switch (input$Ratio,
                       "Perceived Opportunities" = worldaps$Perceived.Opportunities,
                       "Perceived Capabilities" = worldaps$Perceived.Capabilities,
                       "Fear of Failure Rate" = worldaps$Fear.of.Failure.Rate,
                       "Entrepreneurial Intention" = worldaps$Entrepreneurial.Intention
      )
    )
  })

  myratio <- reactive({
    switch (input$Ratio,
            "Perceived Opportunities" = worldaps$Perceived.Opportunities,
            "Perceived Capabilities" = worldaps$Perceived.Capabilities,
            "Fear of Failure Rate" = worldaps$Fear.of.Failure.Rate,
            "Entrepreneurial Intention" = worldaps$Entrepreneurial.Intention
    )
  })

  mylegtitle <- reactive({
    switch(input$Ratio,
           "Perceived Opportunities" = "% Perceived Opportunities",
           "Perceived Capabilities" = "% Perceived Capabilities",
           "Fear of Failure Rate" = "% Fear of Failure",
           "Entrepreneurial Intention" = "% Entrepreneurial Intention"
           )
  })
  
  detail_popup <-  reactive({
                      paste0("<strong> ",worldaps$Economy," </strong>",
                          "<br><strong> Ratio: </strong>",
                          switch (input$Ratio,
                                  "Perceived Opportunities" = worldaps$Perceived.Opportunities,
                                  "Perceived Capabilities" = worldaps$Perceived.Capabilities,
                                  "Fear of Failure Rate" = worldaps$Fear.of.Failure.Rate,
                                  "Entrepreneurial Intention" = worldaps$Entrepreneurial.Intention
                          ),
                          "%"
        )
  })
  
  #  Step 2 --- Render Reactive Map -------------- 
  
  output$mymap <- renderLeaflet({
    leaflet(worldaps) %>%
      setView(lng = -64.787342, lat = 32.300140, zoom = 2) %>%
      addProviderTiles("CartoDB.Positron") %>%
      addPolygons(stroke = TRUE, smoothFactor = 0.2, fillOpacity = 0.7,
                  color = mypal()(myratio()), popup = detail_popup()
      ) %>%
      addLegend("bottomleft", pal = mypal(),
                values = myratio(),
                title = mylegtitle(),
                labFormat = labelFormat(suffix = "%"),
                opacity = 0.7
      )
  })


})


# ------------------- Draft ----------------------------------------------------
    
 # pal <- colorNumeric(
 #    palette = "YlOrRd",
 #    domain = worldaps$Perceived.Opportunities
 #    )
 # 
    # leaflet(worldaps) %>%
    #   setView(lng = -64.787342, lat = 32.300140, zoom = 2) %>%
    #   addProviderTiles("CartoDB.Positron") %>%
    #   addPolygons(stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1,
    #               color = ~pal(worldaps$Perceived.Opportunities)
    #               ) %>%
    #   addLegend("bottomleft", pal = pal,
    #             values = ~worldaps$Perceived.Opportunities,
    #             title = "",
    #             labFormat = labelFormat(suffix = "%"),
    #             opacity = 1
    #             )
#   })
# })
# 

