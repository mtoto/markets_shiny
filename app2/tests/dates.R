app <- ShinyDriver$new("../", seed = 123)
app$snapshotInit("dates")

app$setInputs(date1 = "2011-03-01")
app$setInputs(date2 = "2016-07-03")
app$snapshot(items = list(input = TRUE, export = TRUE))

