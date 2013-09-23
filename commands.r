###
#phyton commands 
###
dir.data <- "~/weather/data"
dir.templates <-  "~/weather/templates"
dir.results <- "~/weather/results"


# this will update the data from the weather station: 
w.logData <- function(){
system("python -m pywws.LogData -vvv ~/weather/data")
}

w.logData()

# this will update the data from the weather station: 
w.hourly <- function(){
  system("python -m pywws.Hourly -vvv ~/weather/data")
}

# this will update the data from the weather station: 
w.process <- function(){
  system("python -m pywws.Process -vvv ~/weather/data")
}

w.process()
w.hourly()


# generate text files from logData: 
#system("python -m pywws.Template ~/weather/data ~/weather/templates/test.txt ~/weather/results/res_test.txt")
#######

w.template <- function(template_name, result_name = template_name, 
                     dirdata = "~/weather/data", 
                     dirtemplates = "~/weather/templates", 
                     dirresults = "~/weather/results") 
  {
  str <- paste("python -m pywws.Template",dirdata, paste(dirtemplates,template_name,sep="/"),paste(dirresults,result_name,sep="/") )
  print(str)
  system(str)
  system(paste("open",paste(dirresults,result_name,sep="/")))
}

# example: 


w.template("yowindow.xml","rtest.xml")
w.template("feed_hourly.xml")
w.template("24hrs.txt")
w.template("24hrs_mg.txt")