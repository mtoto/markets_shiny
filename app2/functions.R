# load libs
library(data.table)
library(stringr)

# get data from alphavantage (currently not used)
get_data <- function(sym) {
        
        
        link_intra <- paste0("https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&",
                       "symbol=",sym,"&interval=1min&apikey=PW0YEXZR8QFMNA1X&datatype=csv&outputsize=full")
        link_day <- paste0("https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&",
                       "symbol=",sym,"&interval=1min&apikey=PW0YEXZR8QFMNA1X&datatype=csv&outputsize=full")
        data <- fread(link_day, showProgress = FALSE)
}

# label symbols as words
label_symbols <- function(symbols) {
        
        labels <- ifelse(str_detect(symbols, "JP"), "Japan",
                         ifelse(str_detect(symbols, "CH"), "China",
                                ifelse(str_detect(symbols, "MX"), "Mexico",
                                       ifelse(str_detect(symbols, "CA"), "Canada",
                                              ifelse(str_detect(symbols, "GE"), "Germany","USA")))))
        
        
        return(labels)
}

