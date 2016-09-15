
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
png(filename = "plot5.png")

with(sum_Emission_due_motor_v, barplot(Emissions, 
                                       names.arg = year, 
                                       xlab = "Year", ylab = "Total pm2.5 Emissions in tons", 
                                       main = "Emissions due to Motor Vehicle in Baltimore City by Year"))

dev.off()