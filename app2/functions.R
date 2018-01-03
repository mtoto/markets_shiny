# load libs
library(data.table)
library(stringr)

# label symbols as words
label_symbols <- function(symbols) {
        
        labels <- ifelse(str_detect(symbols, "JP"), "Japan",
                         ifelse(str_detect(symbols, "CH"), "China",
                                ifelse(str_detect(symbols, "MX"), "Mexico",
                                       ifelse(str_detect(symbols, "CA"), "Canada",
                                              ifelse(str_detect(symbols, "GE"), "Germany","USA")))))
        
        
        return(labels)
}

