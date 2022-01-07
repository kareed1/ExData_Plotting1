#load packages
library(data.table)
library(lubridate)
library(dplyr)
#download and unzip data
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileURL, "ElecPwrCons.zip")                     #download zip file
unzip("ElecPwrCons.zip")                                      #unzip file
#read file and manipulate data set
pwr_data <- fread("household_power_consumption.txt", sep = ";") #read to data.table
pwr_data %>%
  mutate(Date_Time = dmy_hms(paste(Date, Time))) %>%            #create date+time col
  mutate(Date = dmy(Date)) %>%                                  #change char to date
  mutate(Time = hms(Time)) %>%                                  #char to time
  filter(Date == ymd("20070201") | Date == ymd("20070202")) %>% #filter dates
  select(Date_Time, Date:Sub_metering_3) -> pwr_data_2007       #select all vars
remove(pwr_data)                                                #remove unnecessary data
pwr_data_2007 <- as.data.frame(pwr_data_2007)                   #data works best as df
#plot commands
png(filename = "Plot4.png", width = 480, height = 480, units = "px")
par(mfrow = c(2,2))
#top left
with(pwr_data_2007, plot(Date_Time,                             #create plot axes
                         Global_active_power,
                         type = "n", 
                         xlab = NA,  
                         ylab = "Global Active Power"))
with(pwr_data_2007, lines(Date_Time,                            #plot line on axes
                          Global_active_power,
                          lty = 1))
#top right
with(pwr_data_2007, plot(Date_Time,                             #create plot axes
                         Voltage,
                         type = "n", 
                         xlab = "datetime",  
                         ylab = "Voltage"))
with(pwr_data_2007, lines(Date_Time,                            #plot line on axes
                          Voltage,
                          lty = 1))
#bottom left
with(pwr_data_2007, plot(Date_Time,                             #create plot axes
                         Global_active_power,
                         type = "n",
                         ylim = c(0,38),
                         xlab = NA,  
                         ylab = "Energy sub metering"))
with(pwr_data_2007, lines(Date_Time,                            #plot sm1 line on axes
                          Sub_metering_1,
                          lty = 1,
                          col = "black"))
with(pwr_data_2007, lines(Date_Time,                            #plot sm1 line on axes
                          Sub_metering_2,
                          lty = 1,
                          col = "red"))
with(pwr_data_2007, lines(Date_Time,                            #plot sm1 line on axes
                          Sub_metering_3,
                          lty = 1,
                          col = "blue"))
legend(x = pwr_data_2007$Date_Time[750], y = 39,
       legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"),
       lty = c(1, 1, 1), 
       lwd = c(1, 1, 1), 
       col = c("black", "red", "blue"),
       box.col = NA)
#bottom right
with(pwr_data_2007, plot(Date_Time,                             #create plot axes
                         Global_reactive_power,
                         type = "n", 
                         xlab = "datetime",  
                         ylab = "Global_reactive_power"))
with(pwr_data_2007, lines(Date_Time,                            #plot line on axes
                          Global_reactive_power,
                          lty = 1))
dev.off()