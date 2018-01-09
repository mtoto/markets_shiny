app <- ShinyDriver$new("../", seed = 123)
app$snapshotInit("dates")

app$setInputs(date1 = "2000-10-02")
app$setInputs(date2 = "2013-11-01")
app$snapshot()
