library(shiny)
library(shinydashboard)
library(leaflet)

shinyUI(dashboardPage(
  skin = "yellow",
  ######### Dashboard Header ###############
  dashboardHeader(title = "GEM 2015"),
  
  ######### Dashboard Sidebar ##############
  dashboardSidebar(
    sidebarMenu(
      menuItem("Global Overview", tabName = "map", icon = icon("map")),
      selectInput("Ratio",
                  "Choose your Ratio to Map",
                  choice = list(
                    "Perceived Opportunities",
                    "Perceived Capabilities",
                    "Fear of Failure Rate",
                    "Entrepreneurial Intention"
                  ), selected = "Perceived Opportunities"),
      menuItem("Country Profile", tabName = "country", icon = icon("map-marker")),
      menuItem("Country Rank", tabName = "rank", icon = icon("list-ol")),
      menuItem("Data Table", tabName = "table", icon = icon("table")),
      menuItem("About", tabName = "info", icon = icon("info"))
    )
  ),
  
  ######### Dashboard Body #################
  dashboardBody(
    tabItems(
      
      # ---- Display Global Map in this tab ----
      tabItem(tabName = "map",
              tags$style(type = "text/css", "#mymap {height: calc(100vh - 120px) !important;}"),
              fluidRow(box(title = textOutput("mapname"),
                           width = 12, solidHeader = TRUE,
                           leafletOutput("mymap")))
      ),
      tabItem(tabName = "country", ""),
      
      tabItem(tabName = "rank", ""),
      
      tabItem(tabName = "table", ""),
      
      tabItem(tabName = "info", "")
    )
  )
))
  

