### WEATHER STATION FUNCTIONS #####

w.logData <- function(){
  print(system("python -m pywws.LogData -vvv ~/weather/data"))
 
}

w.getData <- function(){
  
  require(data.table)
  
  w.logData()
  # example data: 
  v <- c("2013-09-22 20:38:59",1,71,21.3,99,14.2,1012.9,0.7,1.0,10,10.5,0)
  names(v) <- c("date_tmp","?","hin","tin","hout","tout","press","?","?","?","?","?")
  
  # files and dir: 
  dirdata <- "~/weather/data/live/"
  files <- list.files(dirdata,recursive=T, pattern = "*.txt")
  #files
  nf <- length(files)
  list.data <- vector("list",nf)
  
  for( i in 1:nf){ 
    f1 <- paste(dirdata,files[[i]],sep="/");
    dr <- read.csv(f1,stringsAsFactors = F)
    names(dr) <- names(v)
    dr <- as.data.table(dr)
    list.data[[i]] <- dr  
  }
  
  data.weather <- rbindlist(list.data)
#  data.weather
  
  data.weather[, date := as.POSIXct(date_tmp, format="%Y-%m-%d %H:%M:%S", tz = "UTC") ][,date_tmp := NULL]
  
  data.weather[, date := date + 2*3600] # add 2 hours for the dates... 
  setkey(data.weather,"date")
  
  # now clean it, removing duplcates :
  data.weather <- unique(data.weather)
  
  # save : 
  save(data.weather,file="~/weather/r-weather/data_weather")
#  Sys.time()
  unique.name <- paste("data_",as.character(Sys.time()),sep="")
  save(data.weather,file=unique.name)
  
  names(data.weather)
  data <- data.weather
  return(data)
} 

w.cleanData <- function(data){
  
  
  
}

w.graphTemp <- function(data,save_image=FALSE){
  
  
  plot.t <- ggplot(data)  +     
    geom_line(aes(x=date,y=tin), colour = "darkorange3", alpha = 0.4) + 
    geom_line(aes(x=date,y=tout), colour = "darkorange3", alpha = 0.4) +
    stat_smooth(aes(x=date,y=tin), colour = "darkslategrey", method="loess", span=0.1) + 
    stat_smooth(aes(x=date,y=tout), colour = "darkslategrey", method="loess", span=0.1) +
    ylab('TEMPERATURE (C)') + 
    xlab('TIME (UT+2)') +  
    scale_y_continuous( breaks=seq(7,24,1)) +
    labs(title = 'MUNKSØGÅRD (55.659,12.123), DENMARK \n Temperature: internal and external') 
  
  if(save_image){
    g.height <- 400
    g.width <- 600
    g.dir <- "~/weather/r-weather/graphs"
    png(file = paste(g.dir,"temp.png",sep="/"),width = g.width, height =  g.height, type ="quartz")
    print(plot.t)
    dev.off()
  }
  
 plot.t
  
}

w.graphPress <- function(data,save_image=FALSE){
  
  plot.p <- ggplot(data)  + 
    
    geom_line(aes(x=date,y=press), colour = "darkorange3", alpha = 0.4) +
    stat_smooth(aes(x=date,y=press), colour = "darkslategrey", method="loess", span=0.1) +
    ylab('PRESSURE (hpa)') + 
    xlab('TIME (UT+2)') +  
    scale_y_continuous( breaks=seq(1010,1025, 1)  , limits = c(1010,1025)) + 
    labs(title = 'MUNKSØGÅRD (55.659,12.123), DENMARK \n Barometric Pressure') 
  if(save_image){
    g.height <- 400
    g.width <- 600
    g.dir <- "~/weather/r-weather/graphs"
    png(file = paste(g.dir,"press.png",sep="/"),width = g.width, height =  g.height,type ="quartz")
    print(plot.p)
    dev.off()
  }
  plot.p
  
}

w.graphHum <- function(data,save_image=FALSE){
  
  plot.h <- ggplot(data)  + 
    
    geom_line(aes(x=date,y=hin), colour = "darkorange3", alpha = 0.4) + 
    geom_line(aes(x=date,y=hout), colour = "darkorange3", alpha = 0.4) +
    stat_smooth(aes(x=date,y=hin), colour = "darkslategrey", method="loess", span=0.1) + 
    stat_smooth(aes(x=date,y=hout), colour = "darkslategrey", method="loess", span=0.1) +
    ylab('HUMIDITY (%)') + 
    xlab('TIME (UT+2)') +  
    labs(title = 'MUNKSØGÅRD (55.659,12.123), DENMARK \n Humidity: internal and external') 
  
  if(save_image){
    g.height <- 400
    g.width <- 600
    g.dir <- "~/weather/r-weather/graphs"
    png(file = paste(g.dir,"hum.png",sep="/"),width = g.width, height =  g.height,type ="quartz")
    print(plot.h)
    dev.off()
  }
  
  plot.h 
}


w.logAndGraph <- function(save_images=TRUE){
  
  require(ggplot2)
  g.height <- 400
  g.width <- 600
  g.dir <- "~/weather/r-weather/graphs"
  
  data <- w.getData()
  plot.t <- w.graphTemp(data, save_images)
  plot.p <- w.graphPress(data, save_images)
  plot.h <- w.graphHum(data, save_images)
  print(plot.t)
  print(plot.h)
  print(plot.p) 
 
}




