library(shiny)
library(shinydashboard)
library(plotly)
library(shinytest)
library(shinythemes)

options(shiny.sanitize.errors = FALSE)

header <- dashboardHeader(
        title = "Investments Dashboard"
)

body <- dashboardBody(
        
        fluidRow(
                tabBox(type = "tabs",
                            tabPanel("Trade Balance", 
                               plotlyOutput("plot_balance", width = 900, height = 400)),
                            tabPanel("Import and Export to / from the USA", 
                                     plotlyOutput("plot_total", width = 900, height = 400)),
                            
                       width = 1000
                )
        ),
        
        fluidRow(
                tabBox(type = "tabs",
                        tabPanel("Exports / Imports per country",
                                 plotlyOutput("plot_export", width = 1000, height = 400)),
                       width = 1000
                )
        )
)

sidebar <- dashboardSidebar(sidebarMenu(
        
        dateInput("date", "Choose a starting date", value = "2014-01-01", max = Sys.Date())
)
)

dashboardPage(
        skin = "black", 
        header,
        sidebar,
        body
)