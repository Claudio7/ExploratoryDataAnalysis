library(zip)
library(lubridate)

fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipfilename <- "./powerConsumption.zip"
filename <- "./household_power_consumption.txt"
pngfile <- "./plot2.png"

if(!file.exists(filename)) {
    download.file(url = fileUrl, destfile = zipfilename, method = "curl")
    downloadDate <- date()
    unzip(zipfilename)
}

# read data (first 70000 rows contain 1-2/2/2007)
completedf <- read.table(file = filename, sep=";", header = TRUE,
                         stringsAsFactors = FALSE, nrows = 70000)
df <- completedf[completedf$Date == "1/2/2007" | completedf$Date == "2/2/2007",]

names(df) <- names(completedf)

df$DateTime <- paste(df$Date,df$Time)

df$DateTime <- strptime(df$DateTime, format = "%d/%m/%Y %H:%M:%S")

df$Global_active_power <- as.numeric(df$Global_active_power)

plot(df$DateTime, df$Global_active_power, xlab = "", ylab="Global Active Power (kilowatts)", type = "n")
lines(df$DateTime, df$Global_active_power)
dev.copy(png, filename = pngfile)
dev.off()
