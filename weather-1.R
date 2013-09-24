
dir <- "~/weather/r-weather"
setwd(dir)
require(data.table)
source("functions.R")

template.names <- list.files("~/weather/templates")
template.names
tname <- template.names[6]; tname
w.template(tname,"6h.html")

#### station position : 
lat <- 55.659124
long <- 12.132110

##

w.logAndGraph()

##
data <- w.getData()
load("~/weather/r-weather/data_weather")
str(data)
tail(data)
w.graphTemp(data,T)