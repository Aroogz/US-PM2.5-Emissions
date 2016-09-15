if ("ggplot2" %in% row.names(installed.packages()) == FALSE){install.packages("ggplot2")}
library(ggplot2)

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

#data aggregate
Emissions_agg <- aggregate(baltimore["Emissions"], 
                           by= baltimore[c("year", "type")], 
                           FUN = mean)
#plot
png(filename = "plot3.png")
qplot(year, Emissions, col= type, data = Emissions_agg, geom = "line") + 
  labs(x= "Year", y= expression("total "* pm[2.5]* " Emissions"))+ 
  ggtitle("Total Emission Trend per year for each type")

dev.off()