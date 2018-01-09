library(testthat)
library(shinytest)
library(quantmod)
source("functions.R")
options(shiny.testmode=TRUE)

# test xts object
time <- c("1985-01-01", "1985-01-02", "1985-01-03")
xt <- xts(x = 1:3, order.by = as.Date(time))
colnames(xt) <- "test_series"

# test data.frame object
test_df<-data.frame(date = as.Date(time), 
                    price = 1:3, 
                    symbol = rep("test_series",3))

# api test
test_that("API works", {
        
        expect_error(getSymbols("SPY",
                                src = "google", 
                                from = Sys.Date() - 10),
                     regexp = NA
)
})

# xts to df test 
test_that("Function one works", {
        
        expect_equal(df_xts(xt), test_df,
        check.attributes = FALSE)
})

# shiny app test
test_that("Application works", {

        expect_pass(testApp("/srv/shiny-server/myapp/", 
                            testnames = "dates", 
                            compareImages = FALSE))
})



