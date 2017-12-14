app <- ShinyDriver$new("../")
app$snapshotInit("date_widgets")

app$setInputs(date1 = "201-01-01")
app$setInputs(date1 = "2010-01-01")
app$setInputs(date2 = "2017-12-06")
app$setInputs(date2 = "201-12-06")
app$setInputs(date2 = "2016-12-06")
app$snapshot()
