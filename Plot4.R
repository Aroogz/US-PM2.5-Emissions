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

#Data is sampled for want of memory
pm25_sample <-  pm25[sample(nrow(pm25), 
                size = 5000, replace = FALSE),]

row.names(pm25_sample) <- 1:nrow(pm25_sample)

merged <- merge(pm25_sample, scc, by.x = "SCC", by.y = "SCC", all=FALSE)
pm25_due_to_coal <- subset(merged, grepl("[cC]oal", merged$SCC.Level.Three))
Emissions_due_to_coal <- aggregate(pm25_due_to_coal["Emissions"], by= pm25_due_to_coal["year"], FUN = mean)

#plot

png(filename = "plot4.png")
with(Emissions_due_to_coal, 
      barplot(Emissions, names.arg = year, 
      xlab = "year", ylab = "Emissions in tons",
      main = "Total Emissions due to Coal per year in the US"))

dev.off()