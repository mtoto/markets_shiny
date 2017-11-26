
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
library(shiny)
library(tidyquant)

shinyServer(function(input, output) {

        output$plot <- renderPlotly({
                # get data from API
                indices <- c("AMZN") %>%
                        tq_get(get = "stock.prices", from = "2000-01-01", to = "2017-11-01")
                
                # draw line chart for closing price
                n <- 20
                p<-indices %>%
                        ggplot(aes(x = date, y = close)) +
                        geom_line() + 
                        labs(subtitle = "Closing Price",
                             x = "", y = "Closing Price") +
                        theme_tq()
                ggplotly(p)
            
        })

  })

