##set file path to save download to
    path <- file.path(paste(getwd(), 'exdata%2Fdata%2Fhousehold_power_consumption.zip', sep = "/"))
##set url for download
    url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip";
##download file and save to working directory
    download.file(url, path)
##unzip file and put it in user's current working directory
    chooseFile<-file.choose()
    workingDir<-getwd()
    unzip(chooseFile,exdir = workingDir)
##import data based on condition Dates 01-02-2007 to 02-02-2007 
    imported_hpc <- read.table("household_power_consumption.txt", header = FALSE, nrows = 2880 , skip = 66637 , sep = ";", na.strings = c(" ", "NA", "?"), stringsAsFactors = FALSE, strip.white = TRUE, col.names = c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), colClasses = c("character", "character", "numeric", "numeric", "numeric","numeric","numeric","numeric","numeric")) 
##check environment for tidyr package and install or not as required
##credit Matthew on StackOverflow https://stackoverflow.com/users/4125693/matthew
    using<-function(...) {
        libs<-unlist(list(...))
        req<-unlist(lapply(libs,require,character.only=TRUE))
        need<-libs[req==FALSE]
        n<-length(need)
        if(n>0){
            libsmsg<-if(n>2) paste(paste(need[1:(n-1)],collapse=", "),",",sep="") else need[1]
            print(libsmsg)
        if(n>1){
            libsmsg<-paste(libsmsg," and ", need[n],sep="")
        }
        libsmsg<-paste("The following packages could not be found: ",libsmsg,"\n\r\n\rInstall missing packages?",collapse="")
        if(winDialog(type = c("yesno"), libsmsg)=="YES"){       
            install.packages(need)
            lapply(need,require,character.only=TRUE)
        }
        }
        }
##install and load packages    
    using("tidyr")
    using("lubridate")
##combine Date and Time column together 
    imported_hpc <- unite(imported_hpc, "DateTime", c("Date", "Time"), sep = " ")
##convert new column into Date/Time class
    imported_hpc[ ,1] <- dmy_hms(imported_hpc[ ,1])
##open the graphics device
    png(filename = "plot1.png")
##plot the graph
    par(font.main = 2) 
    hist(imported_hpc$Global_active_power, breaks = 13, freq = TRUE, plot = TRUE, col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)", ylab = "Frequency") 
##turn graphics device off
    dev.off()