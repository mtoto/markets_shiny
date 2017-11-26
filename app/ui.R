library(shiny)
library(shinydashboard)
library(plotly)
options(shiny.sanitize.errors = FALSE)

header <- dashboardHeader(
        title = "Investments Dashboard"
)

body <- dashboardBody(
        fluidRow(
                column(width = 9,
                       box(width = NULL, solidHeader = TRUE,
                           plotlyOutput("plot", height = 500)
                       )
                )
        )
)

dashboardPage(
        header,
        dashboardSidebar(disable = TRUE),
        body
)