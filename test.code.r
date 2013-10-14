### take dplicates out 
dt <- data.table(x=1:10, y=c(1,2,2,3,4,5,6,7,7,7), key="y")

data.weather$date[1]
min.day <- data.weather$day[1]   # it is keyed by date.
max.day <- data.weather$day[nrow(data.weather)]
min.day <- as.POSIXct(min.day, format = "%Y-%m-%d", tz="UTC")
max.day <- as.POSIXct(max.day, tz="UTC")
min.day
max.day

dt[unique(dt$y)]

unique(dt)
library(scales)
w.graphTemp(data=data.weather,FALSE)

load("~/weather/r-weather/data_weather")
str(data)
datau <-  unique(data); datau
str(datau)

plot.t <- ggplot(data)  +     
  geom_line(aes(x=date,y=tin), colour = "darkorange3", alpha = 0.4) + 
  geom_line(aes(x=date,y=tout), colour = "darkorange3", alpha = 0.4) +
  stat_smooth(aes(x=date,y=tin), colour = "darkslategrey", method="loess", span=0.1) + 
  stat_smooth(aes(x=date,y=tout), colour = "darkslategrey", method="loess", span=0.1) +
  ylab('TEMPERATURE (C)') + 
  xlab('TIME (UT+2)') +  
  scale_y_continuous( breaks=seq(7,24,1)) +
  labs(title = 'MUNKSØGÅRD (55.659,12.123), DENMARK \n Temperature: internal and external') 

plot.t

if(T){
  g.height <- 400
  g.width <- 600
  file.g <- "~/weather/r-weather/graphs/temp.p"
  png(file = file.g,width = g.width, height =  g.height, type ="quartz")
  plot.t
  dev.off()
  tiff(file = file.g,width = g.width, height =  g.height)
  plot.t
  dev.off()
}