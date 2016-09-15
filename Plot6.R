rm(list = ls())

if (!file.exists("pm25.zip")){
  fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(fileUrl, destfile = "pm25.zip")
}

if(!file.exists("Source_Classification_Code.rds")|!file.exists("summarySCC_PM25.rds")){
  unzip("pm25.zip", exdir = ".")
}

#Read in data
pm25 <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")

Baltimore = subset(pm25, fips== "24510")
merged <- merge(Baltimore, scc, by.x = "SCC", by.y = "SCC", all = FALSE)
Emission_due_motor_v = subset(merged, grepl("vehicle", merged$SCC.Level.Two,ignore.case = TRUE))

sum_Emission_due_motor_v <- aggregate(Emission_due_motor_v["Emissions"], 
                                      by=Emission_due_motor_v["year"], FUN= mean)

Los_Angeles <- subset(pm25, fips == "06037")
merged_LA <- merge(Los_Angeles, scc, by.x = "SCC", by.y = "SCC", all = FALSE)
LA_Emission_due_motor_v <- subset(merged_LA, grepl("vehicle", merged_LA$SCC.Level.Two, ignore.case = TRUE))
LA_sum_Emission_due_motor_v <- aggregate(LA_Emission_due_motor_v["Emissions"], by= LA_Emission_due_motor_v["year"], FUN= mean)

#plot
png(filename = "plot6.png")

par(mfrow= c(1,2))

with(sum_Emission_due_motor_v, plot(year, Emissions,type = "l", xlab = "year", ylab = "Total pm2.5 Emissions in tons", main = "Baltimore"))

with(LA_sum_Emission_due_motor_v, plot(year, Emissions,type = "l", xlab = "year", ylab = "Total pm2.5 Emissions in tons", main = "Los Angeles"))

title(main = "Total Emissions per year for Baltimore and Los Aageles",outer = TRUE)

dev.off()
