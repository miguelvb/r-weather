require(data.table)

### LOAD DATA ######

## from python pywws : 

# this will update the data from the weather station: 
system("python -m pywws.LogData -vvv ~/weather/data")

#######3

# example data: 
v <- c("2013-09-22 20:38:59",1,71,21.3,99,14.2,1012.9,0.7,1.0,10,10.5,0)
names(v) <- c("date_tmp","?","hin","tin","hout","tout","press","?","?","?","?","?")

# files and dir: 
dirdata <- "~/weather/data/live/"
files <- list.files(dirdata,recursive=T, pattern = "*.txt")
files
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
data.weather

data.weather[, date := as.POSIXct(date_tmp, format="%Y-%m-%d %H:%M:%S", tz = "UTC") ][,date_tmp := NULL]

data.weather[, date := date + 2*3600] # add 2 hours for the dates... 
setkey(data.weather,"date")


save(data.weather,file="data_weather")
Sys.time()
unique.name <- paste("data_",as.character(Sys.time()),sep="")
save(data.weather,file=unique.name)

names(data.weather)
data <- data.weather

###############

library(ggplot2)


plot.t <- ggplot(data)  + 
  geom_line(aes(x=date,y=tin), colour = "red") + 
  geom_line(aes(x=date,y=tout), colour = "blue") +
  #ylim(0, 45) + 
  ylab('') + 
  xlab('') +  
  # labs(title = 'Freq distribution of treatments')  +
  #geom_text(data=x,aes(x=labels,y=percent,label=lab),vjust=-0.5) + 
  #theme_bw() +
  #opts(legend.position="none") +
  #scale_y_continuous( breaks=seq(0, 50, 5)  , limits = c(0, 45), expand = c(0,0) ) + 
  theme( 
    #  axis.text.x= element_text( size= 14 ) , 
    #  legend.position = "none" ,
    #  panel.margin = unit(0,"null")  
    )
plot.t


plot.h <- ggplot(data)  + 
  
  geom_line(aes(x=date,y=hin), colour = "darkorange3", alpha = 0.4) + 
  geom_line(aes(x=date,y=hout), colour = "darkorange3", alpha = 0.4) +
  stat_smooth(aes(x=date,y=hin), colour = "darkslategrey", method="loess", span=0.1) + 
  stat_smooth(aes(x=date,y=hout), colour = "darkslategrey", method="loess", span=0.1) +
  ylab('HUMIDITY (%)') + 
  xlab('TIME (UT+2)') +  
  labs(title = 'MUNKSØGÅRD (55.66,12.33), DENMARK \n Humidity: internal and external') 

plot.h


plot.t <- ggplot(data)  + 
  
  geom_line(aes(x=date,y=tin), colour = "darkorange3", alpha = 0.4) + 
  geom_line(aes(x=date,y=tout), colour = "darkorange3", alpha = 0.4) +
  stat_smooth(aes(x=date,y=tin), colour = "darkslategrey", method="loess", span=0.1) + 
  stat_smooth(aes(x=date,y=tout), colour = "darkslategrey", method="loess", span=0.1) +
  ylab('TEMPERATURE (C)') + 
  xlab('TIME (UT+2)') +  
  scale_y_continuous( breaks=seq(10,24,1)) +
  labs(title = 'MUNKSØGÅRD (55.66,12.33), DENMARK \n Temperature: internal and external') 

plot.t



plot.p <- ggplot(data)  + 
  #geom_point(aes(x=date,y=press), colour = "red") + 
  geom_line(aes(x=date,y=press), colour = "red") +
  geom_smooth(aes(x=date,y=press), colour = "grey") +
  
  #ylim(0, 45) + 
  ylab('') + 
  xlab('') +  
  # labs(title = 'Freq distribution of treatments')  +
  #geom_text(data=x,aes(x=labels,y=percent,label=lab),vjust=-0.5) + 
  #theme_bw() +
  #opts(legend.position="none") +
  scale_y_continuous( breaks=seq(1000,1025, 1)  , limits = c(1000,1025), expand = c(0,0) ) + 
  theme( 
    #  axis.text.x= element_text( size= 14 ) , 
    #  legend.position = "none" ,
    #  panel.margin = unit(0,"null")  
    )
plot.p

plot.p2 <- ggplot(data)  + 
  #geom_point(aes(x=date,y=press), colour = "red") + 
  geom_point(aes(x=date,y=press), colour = "grey", alpha = 0.6) +
  geom_smooth(aes(x=date,y=press), colour = "red") +
  #ylim(0, 45) + 
  ylab('') + 
  xlab('') +  
  # labs(title = 'Freq distribution of treatments')  +
  #geom_text(data=x,aes(x=labels,y=percent,label=lab),vjust=-0.5) + 
  #theme_bw() +
  #opts(legend.position="none") +
  scale_y_continuous( breaks=seq(1000,1025, 1)  , limits = c(1000,1025), expand = c(0,0) ) + 
  theme( 
    #  axis.text.x= element_text( size= 14 ) , 
    #  legend.position = "none" ,
    #  panel.margin = unit(0,"null")  
    )
plot.p2


