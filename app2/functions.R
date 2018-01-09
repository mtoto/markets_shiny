# load libs
library(dplyr)
library(tidyr)
library(fuzzyjoin)
library(stringr)
library(quantmod)
library(ggplot2)
library(ggthemes)
library(shiny)
library(shinydashboard)
library(shinytest)
library(shinythemes)



# retrieve data as list of xts objects
list_xts <- function(symbols) {
        
        list_xts <- lapply(symbols, 
                           getSymbols, 
                           src = "FRED", 
                           auto.assign = FALSE)
        
        return(list_xts)
}

# convert a single xts object to a "tidy" data.frame
df_xts <- function(xts_object) {
        
        df <- data.frame(date = index(xts_object), 
                         coredata(xts_object), 
                         symbol = names(xts_object))
        
        return(df %>% rename_(price = names(xts_object)))
        
}

# wrapper to return single data.frame from vector of symbols
xts_bind_df <- function(symbols) {
        
        l_xts <- list_xts(symbols)
        l_df <- lapply(l_xts, df_xts)
        df <- do.call(rbind, l_df)
        
        return(df)
        
}






