library(shiny)
library(tidyquant)
library(ggthemes)
source("functions.R")

# get data from API
import_series <- c("IMPJP", "IMPCH", "IMPMX", "IMPCA", "IMPGE")
export_series <- c("EXPJP", "EXPCH", "EXPMX", "EXPCA", "EXPGE")
economic_series <- c("BOPGSTB","IMP0004","EXP0004")

all_data <- tq_get(c(import_series, export_series, economic_series), "economic.data")
trade_i <- all_data %>% filter(symbol %in% import_series)
trade_e <- all_data %>% filter(symbol %in% export_series)
trade_t <- all_data %>% filter(symbol %in% economic_series)

shinyServer(function(input, output) {
        
        # imports data
        trades_import <- reactive({ 
                trade_i %>% filter(date >= input$date1 &
                                   date <= input$date2) %>% 
                group_by(date) %>%
                mutate(total = sum(price),
                       country = factor(label_symbols(symbol),
                                        levels = c("China", "Mexico","Canada",
                                                   "Japan","Germany"))) %>%
                group_by(symbol) %>%
                mutate(ratio = price / total) %>%
                ungroup() 
        })
        
        # export data
        trades_export <- reactive({ 
                trade_e %>% filter(date >= input$date1 &
                                   date <= input$date2) %>% 
                        group_by(date) %>%
                        mutate(total = sum(price),
                               country = factor(label_symbols(symbol),
                                                levels = c("China", "Mexico","Canada",
                                                           "Japan","Germany"))) %>%
                        group_by(symbol) %>%
                        mutate(ratio = price / total) %>%
                        ungroup() 
        })
        
        # total import data
        trades_import_t <- reactive({
                trade_t %>% filter(date >= input$date1 &
                                   date <= input$date2 & 
                                   symbol == "IMP0004")
        })
        
        # total export data
        trades_export_t <- reactive({
                trade_t %>% filter(date >= input$date1 &
                                   date <= input$date2 & 
                                   symbol == "EXP0004")
        })
        
        # trade balance data
        trades_balance <- reactive({
                trade_t %>% filter(date >= input$date1 &
                                   date <= input$date2 & 
                                   symbol == "BOPGSTB")
        })
      
        exportTestValues(trades_import = { trades_import() },
                         trades_export = { trades_export() },
                         
                         trades_import_t = { trades_import_t() },
                         trades_export_t = { trades_export_t() }
        )
        
        
        # export & import plot
        output$plot_export <- renderPlot({ 
                
                ggplot(trades_export(), aes(x = date, y = ratio, fill = country)) +
                        geom_col() +
                        scale_y_continuous(labels=scales::percent) +
                        labs(y = "Share of Total") +
                        ggtitle("Top 5 Exporters to USA") +
                        guides(color=FALSE)  +
                        scale_fill_ptol("cyl") +
                        theme_minimal()

                })
        
        output$plot_import <- renderPlot({ 
                
                ggplot(trades_import() , aes(x = date, y = ratio, fill = country)) +
                        geom_col() +
                        scale_y_continuous(labels=scales::percent) +
                        labs(y = "Share of Total") +
                        ggtitle("Top 5 Importers from USA") +
                        guides(color=FALSE)  +
                        scale_fill_ptol("cyl") +
                        theme_minimal()

        })
        
        # totals plot
        output$plot_total <- renderPlot({
                
                rbind(trades_export_t(), trades_import_t()) %>%
                        spread(symbol, price) %>%
                        ggplot(aes(x = date)) +
                        geom_line(aes(y = EXP0004, color = "red" )) +
                        geom_line(aes(y = IMP0004 / 1.5, color = "blue")) +
                        scale_y_continuous(sec.axis = sec_axis(~.*1.5, name = "Import in millions USD")) + 
                        labs(y = "Export in millions USD") +
                        ggtitle("Exports and Imports: USA") +
                        theme(axis.title.y.right = element_text(color = "blue"),
                              axis.title.y.left = element_text(color = "red")) +
                        guides(color=FALSE) +
                        scale_color_ptol("cyl") +
                        theme_minimal()
        })
        
        # totals plot
        output$plot_balance <- renderPlot({
                
                        ggplot(trades_balance(),aes(x = date, y = price)) +
                        geom_line() +
                        labs(y = "Trade Balance in millions USD") +
                        ggtitle("USA Trade Balance") +
                        guides(color=FALSE) +
                        scale_color_ptol("cyl") +
                        theme_minimal()
        })
        
})

