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
pwr_data_2007[,4:10] <- sapply(pwr_data_2007[,4:10], as.numeric)#char to num
pwr_data_2007 <- as.data.frame(pwr_data_2007)                   #data works best as df
#Plot commands
png(filename = "Plot1.png", width = 480, height = 480, units = "px") #start graphics device
with(pwr_data_2007, hist(Global_active_power,                        #create histogram
                         col ="red", 
                         xlab = "Global Active Power (kilowatts)", 
                         ylab = "Frequency", 
                         main = "Global Active Power"))
dev.off()