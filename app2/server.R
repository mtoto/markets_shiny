source("srv/shiny-server/myapp/functions.R")
source("srv/shiny-server/myapp/data.R")

shinyServer(function(input, output) {
        
        # import data
        trades_import <- reactive({ 
                
                trade_i %>% mutate(symbol = as.character(symbol)) %>%
                        fuzzy_inner_join(dict, match_fun = str_detect) %>%
                        filter(date >= input$date1 &
                               date <= input$date2) %>% 
                        group_by(date) %>%
                        mutate(total = sum(price),
                               country = factor(country,
                                                levels = c("China", "Mexico","Canada",
                                                           "Japan","Germany"))) %>%
                        group_by(country) %>%
                        mutate(ratio = price / total) %>%
                        ungroup() 
        })
        
        # export data
        trades_export <- reactive({ 
                
                trade_e %>% mutate(symbol = as.character(symbol)) %>%
                        fuzzy_inner_join(dict, match_fun = str_detect) %>%
                        filter(date >= input$date1 &
                               date <= input$date2) %>% 
                        group_by(date) %>%
                        mutate(total = sum(price),
                               country = factor(country,
                                                levels = c("China", "Mexico","Canada",
                                                           "Japan","Germany"))) %>%
                        group_by(country) %>%
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
        
        
        # export plot
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
        
        # import plot
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
                              axis.title.y = element_text(color = "red")) +
                        guides(color=FALSE) +
                        scale_color_ptol("cyl") +
                        theme_minimal()
        })
        
        # trade balance plot
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

