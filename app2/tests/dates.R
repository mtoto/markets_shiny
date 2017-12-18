app <- ShinyDriver$new("../", seed = 123)
app$snapshotInit("dates")

app$setInputs(date1 = "2011-03-01")
app$setInputs(date2 = "2017-05-01")
# no output cauze of random plotly ids
app$snapshot(items = list(input = TRUE, export = TRUE))
