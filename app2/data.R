source("functions.R")

# series to download
import_series <- c("IMPJP", "IMPCH", "IMPMX", "IMPCA", "IMPGE")
export_series <- c("EXPJP", "EXPCH", "EXPMX", "EXPCA", "EXPGE")
economic_series <- c("BOPGSTB","IMP0004","EXP0004")

# download as dataframes
trade_i <- xts_bind_df(import_series)
trade_e <- xts_bind_df(export_series)
trade_t <- xts_bind_df(economic_series)

# dictionary for fuzzy join
dict <- data.frame(symbol = c("JP","CH", "MX", "CA", "GE"),
                   country = c("Japan", "China", "Mexico", 
                               "Canada", "Germany"),
                   stringsAsFactors = FALSE)