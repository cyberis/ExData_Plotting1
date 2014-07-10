# plot1.R - Plot the First Graphic
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

# Step 5: Create our histogram on screen
hist(plotData$Global_active_power,
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)",
     col = "red",
     bg = "transparent")

# Step 6: Create our histogram in the png file
png("plot1.png")
hist(plotData$Global_active_power,
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)",
     col = "red",
     bg = "transparent")
dev.off()
