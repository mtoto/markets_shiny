
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
library(shiny)
library(data.table)
library(tidyquant)

shinyServer(function(input, output) {

        output$plot <- renderPlotly({
                # gedata from API
                indices <- c("AMZN") %>%
                        tq_get(get = "stock.prices", from = "2000-01-01", to = "2017-11-01")
                
                # draw the histogram with the specified number of bins
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

