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

#subset data: Note I could not work on the wole data for memory challenges
pm25_sample <- pm25[sample(nrow(pm25), 5000, replace= FALSE), ]

row.names(pm25_sample) <- 1:nrow(pm25_sample)

#emission
tot_emission <- aggregate(x = pm25_sample["Emissions"], by= pm25_sample["year"], mean)

#plot
png(filename = "plot1.png")

barplot(tot_emission$Emissions, names.arg = tot_emission$year, xlab = "Year", 
        ylab = "Total Emission in tons", col = "red", 
        main = "Total pm2.5 Emissions per year in the US")

dev.off()
