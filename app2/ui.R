library(shiny)
library(shinydashboard)
library(shinythemes)

header <- dashboardHeader(
        title = "USA Trade Dashboard"
)

body <- dashboardBody(
        
        fluidRow(
                box(plotOutput("plot_balance", height = 250), width = 12)                
        ),
        
        fluidRow(
                box(plotOutput("plot_total", height = 250), width = 12)                
                ),
        
        fluidRow(
                box(plotOutput("plot_export", height = 250)),
                box(plotOutput("plot_import", height = 250))
                )
        )

sidebar <- dashboardSidebar(sidebarMenu(
        
        dateInput("date1", "Choose a starting date", value = "2014-01-01", max = Sys.Date()),
        dateInput("date2", "Choose an ending date", value = Sys.Date() - 5, max = Sys.Date())
)
)

dashboardPage(
        skin = "black", 
        header,
        sidebar,
        body
)