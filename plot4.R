# plot4.R - Plot the Fourth Graphic
# Submitted by Christopher Bortz
# For Exploratory Data Analysis Section 4 - Dr. Roger Peng
# July 7 - August 4, 2014
# Course Project 1 - Electrical Power Consumption

# Step 0: Set up our environment
library(data.table) # fread() and subsetting are very fast with data table
library(lubridate)  # Makes working with dates MUCH easier

# Step 1: Get the Data if we don't already have it
if(!file.exists("./data")) {
    dir.create("./data")
}
if(!file.exists("./data/household_power_consumption.zip")) {
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", "./data/household_power_consumption.zip", method="curl")
}
if(file.exists("./data/household_power_consumption.zip") & !file.exists("./data/household_power_consumption.txt")) {
    unzip("./data/household_power_consumption.zip", exdir = "./data")
}

# Step 2: Create a proper subset of the data for Feb 1 - 2, 2007 and write that out if it doesn't already exist
if(file.exists("./data/household_power_consumption.txt") & !file.exists("./data/hpc_plot_data.txt")) {
    allData <- fread("./data/household_power_consumption.txt", na.strings = "?")
    targetData <- allData[Date %in% c("1/2/2007", "2/2/2007")] # We only need two day's data which is 2,880 rows
    write.table(targetData, "./data/hpc_plot_data.txt",
                row.names = FALSE,
                sep = ";",
                quote = FALSE,
                na = "?")
    rm(allData, targetData)
}

# Step 3: Read in our data
plotData <- fread("./data/hpc_plot_data.txt", 
                  na.strings = "?",
                  colClasses = c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric" ))

# Step 4: Derive Dates and Times From This Data
plotData[, DateTimeString := paste(Date, Time)]
plotData[, DateTime := as.POSIXct(DateTimeString, tz = "", format = "%d/%m/%Y %H:%M:%S")]

# Step 5: Create our 2 x 2 multiplot on screen
par(mfcol = c(2, 2))

# - Plot 1: Line, Global Active Power
plot(plotData$DateTime, 
     plotData$Global_active_power,
     xlab = "",
     ylab = "Global Active Power",
     type = "l")

# - Plot 2: Multiline, Sub Metering
plot(plotData$DateTime, 
     plotData$Sub_metering_1,
     xlab = "",
     ylab = "Energy sub metering",
     type = "l")

lines(plotData$DateTime,
      plotData$Sub_metering_2,
      col = "red")

lines(plotData$DateTime,
      plotData$Sub_metering_3,
      col = "blue")

legend("topright", 
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"),
       lty = 1,
       box.lty = 0,
       bg = "transparent")

# - Plot 3: Line, Voltage
plot(plotData$DateTime, 
     plotData$Voltage,
     xlab = "datetime",
     ylab = "Voltage",
     type = "l")


# - Plot 4: Line, Global Reactive Power
plot(plotData$DateTime, 
     plotData$Global_reactive_power,
     xlab = "datetime",
     ylab = "Global_reactive_power",
     type = "l")


# Step 6: Create our 2 x 2 multiplot in the png file
png("plot4.png", bg = "transparent")
par(mfcol = c(2, 2))

# - Plot 1: Line, Global Active Power
plot(plotData$DateTime, 
     plotData$Global_active_power,
     xlab = "",
     ylab = "Global Active Power",
     type = "l")

# - Plot 2: Multiline, Sub Metering
plot(plotData$DateTime, 
     plotData$Sub_metering_1,
     xlab = "",
     ylab = "Energy sub metering",
     type = "l")

lines(plotData$DateTime,
      plotData$Sub_metering_2,
      col = "red")

lines(plotData$DateTime,
      plotData$Sub_metering_3,
      col = "blue")

legend("topright", 
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"),
       lty = 1,
       box.lty = 0,
       bg = "transparent")

# - Plot 3: Line, Voltage
plot(plotData$DateTime, 
     plotData$Voltage,
     xlab = "datetime",
     ylab = "Voltage",
     type = "l")


# - Plot 4: Line, Global Reactive Power
plot(plotData$DateTime, 
     plotData$Global_reactive_power,
     xlab = "datetime",
     ylab = "Global_reactive_power",
     type = "l")
dev.off()
