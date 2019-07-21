library(zip)
library(lubridate)

fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipfilename <- "./powerConsumption.zip"
filename <- "./household_power_consumption.txt"
pngfile <- "./plot4.png"

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
df$Sub_metering_1 <- as.numeric(df$Sub_metering_1)
df$Sub_metering_2 <- as.numeric(df$Sub_metering_2)
df$Voltage <- as.numeric(df$Voltage)
df$Global_reactive_power <- as.numeric(df$Global_reactive_power)

par(mfcol=c(2,2))

# 1st quarter
plot(df$DateTime, df$Global_active_power, xlab = "", ylab="Global Active Power (kilowatts)", type = "n")
lines(df$DateTime, df$Global_active_power)

# 2nd quarter
plot(df$DateTime, df$Sub_metering_1, xlab = "", ylab="Energy sub metering", type = "n")
lines(df$DateTime, df$Sub_metering_1)
lines(df$DateTime, df$Sub_metering_2, col = "red")
lines(df$DateTime, df$Sub_metering_3, col = "blue")
legend("topright", lty = 1, col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       )

# 3rd quarter
plot(df$DateTime, df$Voltage, xlab = "", ylab="Voltage", type = "n")
lines(df$DateTime, df$Voltage)

# 4th quarter
plot(df$DateTime, df$Global_reactive_power, xlab = "", ylab="Global reactive power", type = "n")
lines(df$DateTime, df$Global_reactive_power)


dev.copy(png, filename = pngfile)
dev.off()
