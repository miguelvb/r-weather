
library(slidify)
library(slidifyLibraries)

author("slidify")


slidify("./slidify/index.Rmd")
system("open ./slidify/index.html")