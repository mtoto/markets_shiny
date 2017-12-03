library(shiny)
library(tidyquant)

# get data from API
import_series <- c("IMPJP", "IMPCH", "IMPMX", "IMPCA", "IMPGE")
export_series <- c("EXPJP", "EXPCH", "EXPMX", "EXPCA", "EXPGE")
economic_series <- c("BOPGSTB", "DTWEXM","IMP0004","EXP0004")

all_data <- tq_get(c(import_series, export_series, economic_series), "economic.data")
trade_i <- all_data %>% filter(symbol %in% import_series)
trade_e <- all_data %>% filter(symbol %in% export_series)
trade_t <- all_data %>% filter(symbol %in% economic_series)

shinyServer(function(input, output) {
        
        # imports data
        trades_import <- reactive({ 
                trade_i %>% filter(date >= input$date) %>% 
                group_by(date) %>%
                mutate(total = sum(price),
                       country = factor(ifelse(symbol == "IMPJP", "Japan",
                                        ifelse(symbol == "IMPCH", "China",
                                        ifelse(symbol == "IMPMX", "Mexico",
                                        ifelse(symbol == "IMPCA", "Canada","Germany")))),
                                        levels = c("China", "Mexico","Canada","Japan","Germany"))) %>%
                group_by(symbol) %>%
                mutate(ratio = price / total) %>%
                ungroup() 
        })
        
        # export data
        trades_export <- reactive({ 
                trade_e %>% filter(date >= input$date) %>% 
                        group_by(date) %>%
                        mutate(total = sum(price),
                               country = factor(ifelse(symbol == "EXPJP", "Japan",
                                                ifelse(symbol == "EXPCH", "China",
                                                ifelse(symbol == "EXPMX", "Mexico",
                                                ifelse(symbol == "EXPCA", "Canada","Germany")))),
                                                levels = c("China", "Mexico","Canada","Japan","Germany"))) %>%
                        group_by(symbol) %>%
                        mutate(ratio = price / total) %>%
                        ungroup() 
        })
        
        # total export data
        trades_import_t <- reactive({
                trade_t %>% filter(date >= input$date & symbol == "IMP0004")
        })
        
        # total export data
        trades_export_t <- reactive({
                trade_t %>% filter(date >= input$date & symbol == "EXP0004")
        })
        
        # trade balance data
        trades_balance <- reactive({
                trade_t %>% filter(date >= input$date & symbol == "BOPGSTB")
        })
        
        
        # export & import plot
        output$plot_export <- renderPlotly({ 
                
                plot_export <- plot_ly(trades_export(), 
                        x = ~ date, 
                        y = ~ratio, 
                        split = ~country, 
                        type = "bar",
                        hoverinfo = 'text',
                        text = ~paste(country, date,
                                      '<br> Export (millions): ', price,
                                      '</br> Percentage', paste0(round(ratio*100,2)," %"))) %>%
                        layout(barmode = "stack",
                               xaxis = list(title = "Date"),
                               yaxis = list(title = "Imports (%)", tickformat = ".0%"),
                               showlegend = FALSE)
                
                plot_import <- 
                        plot_ly(trades_import(), x = ~date, y = ~ratio, 
                        split = ~country, type = "bar",
                        hoverinfo = 'text',
                        text = ~paste(country, date,
                                      '<br> Imports (millions): ', price,
                                      '</br> Percentage', paste0(round(ratio*100,2)," %"))) %>%
                        layout(barmode = "stack",
                               xaxis = list(title = "Date"),
                               yaxis = list(title = "Imports (%)", tickformat = ".0%"),
                               showlegend = FALSE)
                
                subplot(plot_import, plot_export) %>%
                        layout(annotations = list(
                                list(x = 0.2 , y = 1.05, text ="Largest Exports from the USA", 
                                     showarrow = F, xref='paper', yref='paper'),
                                list(x = 0.8 , y = 1.05, text = "Largest Imports to the USA", 
                                     showarrow = F, xref='paper', yref='paper'))
                        )
                
                })
        
        # totals plot
        a_y <- list(
                tickfont = list(color = "blue"),
                side = "right",
                title = "Export (millions USD)"
        )
        
        b_y <- list(
                tickfont = list(color = "orange"),
                overlaying = "y",
                side = "left",
                title = "Import (millions USD)"
        )
        
        output$plot_total <- renderPlotly({
                plot_ly() %>%
                        add_lines(x = ~trades_export_t()$date, 
                                  y = ~trades_export_t()$price, 
                                  name = "Export ") %>%
                        add_lines(x = ~trades_import_t()$date, 
                                  y = ~trades_import_t()$price,
                                  name = "Import", yaxis = "y2") %>%
                        layout(
                                yaxis = a_y,
                                yaxis2 = b_y,
                                xaxis = list(title="x"),
                                legend = list(orientation = 'h')
                        )
        })
        
        # trade balance plot
        output$plot_balance <- renderPlotly({
                plot_ly(x = ~ trades_balance()$date, 
                        y = ~ trades_balance()$price, 
                        mode = 'lines') %>%
                layout(xaxis = list(title = "Date"),
                       yaxis = list(title = "Trade Balance"),
                       legend = list(orientation = 'h'))
        })
        
        
})

