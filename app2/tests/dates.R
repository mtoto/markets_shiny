options(shiny.testmode=TRUE)

app <- ShinyDriver$new("../", seed = 123)
app$snapshotInit("dates")

app$setInputs(date1 = "2000-10-02", timeout_ = 15000)
app$setInputs(date2 = "2013-11-01", timeout_ = 15000)
app$snapshot(items = list(input = TRUE, output = TRUE))
