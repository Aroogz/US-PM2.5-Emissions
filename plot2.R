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

baltimore = subset(pm25, fips == "24510")

#plot
png(filename = "plot2.png")
barplot(with(baltimore, tapply(Emissions, year, mean)), 
        xlab = "Year", ylab = "pm2.5 Emissions in tons", 
        main = "pm2.5 Emissions for Baltimore city, Maryland")

dev.off()
