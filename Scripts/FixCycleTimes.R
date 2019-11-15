#=====================================================#
#### Script to fix date-time stamps for Cycle data ####
#### and remove rows of bad data                   ####
#=====================================================#

## This script grabs Cycle telemetry files copied from 
## the telemetry servers, fixes the DateTime stamp using
## the Date and Time variables stored by the sondes, and
## writes these corrected files to the folder used by
## Aquarius for telemetry updates

## Get file names from the Old_Cycles and New_Cycles directories
old_files <- list.files("C:/WQ_TEL_LZ/Old_Cycles/")
new_files <- list.files("C:/WQ_TEL_LZ/New_Cycles/")

## Create a vector holding filenames without .dat extension
o_filenames <- substr(old_files,1,nchar(old_files)-4)
n_filenames <- substr(new_files,1,nchar(new_files)-4)

## Read in Old Cycle data, making a list of all files
oldfiles <- lapply(o_filenames, function(i) 
    read.csv(file.path("C:/WQ_TEL_LZ/Old_Cycles",paste(i,".dat",sep="")),
             col.names = c("TIMESTAMP","RECORD","CycleP_Date",
                           "CycleP_Time","CycleP_RunNum",
                           "CycleP_PO4mgL","CycleP_Units",
                           "CycleP_LastSmplStage","CycleP_BattVolt"),
             header = F))

## Store names of files with the list elements
names(oldfiles) <- o_filenames

## Read in New Cycle data, making a list of all files
newfiles <- lapply(n_filenames, function(i) 
    read.csv(file.path("C:/WQ_TEL_LZ/New_Cycles",paste(i,".dat",sep="")),
             col.names = c("TIMESTAMP","RECORD","CycleP_RunNum",
                           "CycleP_PO4mgL","CycleP_OAQC","CycleP_QC1",
                           "CycleP_QC2","CycleP_BattVolt","CycleP_Flush1Avg",
                           "CycleP_Last_Smp_Status","CycleP_Date_Year",
                           "CycleP_Date_MMDD","CycleP_Time_HHMM"),
             header = F))

## Store names of files with the list elements
names(newfiles) <- n_filenames

if(length(newfiles) > 0) {
    ## Correct the DateTime (TIMESTAMP) field for the New Cycle data ####
    for(j in 1:length(newfiles)) {
        ## Store the list element as a data frame
        x <- newfiles[[j]]
        
        ## Strip 4 header rows with metadata to be attached to the corrected
        ## data after the TIMESTAMP field is corrected
        xhead <- x[1:4,]
        
        ## Remove the 4 header rows (stored above as xhead)
        xdata <- x[-c(1:4),]
        
        ## Convert numeric fields to numeric variables
        xdata[,2:length(xdata)] <- sapply(xdata[,2:length(xdata)],function(x) as.numeric(as.character(x)))
        
        ## Store the TIMESTAMP as a date field for to allow for filtering by date
        xdata$TIMESTAMP <- as.Date(xdata$TIMESTAMP)
        
        ## Reduce the data frame to only the last 30 days of data
        xdata <- xdata[xdata$TIMESTAMP > (Sys.Date() - 30),]
        
        ## Convert the TIMESTAMP field back to a factor
        xdata$TIMESTAMP <- as.factor(xdata$TIMESTAMP)
        
        ## Create a new field that stores the time rounded to the closest hour
        xdata$CycleP_Rounded_Time <- ifelse(round((xdata$CycleP_Time %% 1)*100) < 30,
                                            trunc(xdata$CycleP_Time_HHMM),
                                            ceiling(xdata$CycleP_Time_HHMM))
        
        ## Flag any rows that contain no data (or zeroes) in the Date field
	if(nrow(xdata) > 0) {
	    xdata$keep <- 1
            for(i in 1:nrow(xdata)) {
            	ifelse(xdata$CycleP_Date_Year[i] == 0 |
                       is.na(xdata$CycleP_Date_Year[i]) |
                       is.nan(xdata$CycleP_Date_Year[i]),
                       xdata$keep[i] <- 0,xdata$keep[i] <- 1)
	    }     
        }
        
        ## Remove rows with no data (or zeroes) in the Date field
        xdata <- xdata[xdata$keep == 1,]
        
        ## Stitch together the new TIMESTAMP field using the Date and Time data
        ## stored by the sonde
                if(nrow(xdata) > 0) {
            for(i in 1:nrow(xdata)) {
                xdata$TIMESTAMP <- paste(xdata$CycleP_Date_Year, "-", 
                                         trunc(xdata$CycleP_Date_MMDD), "-", 
                                         round((xdata$CycleP_Date_MMDD %% 1)*100),
                                         " ", trunc(xdata$CycleP_Rounded_Time), ":00", sep = "")
            }
            
            ## Convert TIMESTAMP to a DateTime field for consistent formatting
            xdata$TIMESTAMP <- as.POSIXct(xdata$TIMESTAMP,format = c("%Y-%m-%d %H:%M"), tz = "EST")
            
            ## Remove the rounded time field
            xdata <- xdata[, -which(names(xdata) %in% c("CycleP_Rounded_Time"))]
            
            
            ## Remove the fields with NaN in RunNum
            xdata <- xdata[!is.nan(xdata$CycleP_RunNum),]
            
            if(nrow(xdata) > 1) {
            ## Flag rows with run number repeating (after first instance)
            for(i in 2:nrow(xdata)) {
                if(xdata$CycleP_RunNum[i] == xdata$CycleP_RunNum[i-1] &
                   xdata$keep[i] == 1) {
                    xdata$keep[i] <- 0
                }
            }
            
            ## Remove rows with run number repeating (after first instance)
            xdata <- xdata[xdata$keep == 1,]
            
            ## Remove any rows where Battery Voltage = 0
            ## Remove any rows where PO4 value = -9999999 or NaN
            ## Remove any rows where Last Sample Stage is not 4 or 9
            ## Remove any rows where Flush1Avg = 0
            xdata <- xdata[
                xdata$CycleP_BattVolt != 0 &
                    xdata$CycleP_PO4mgL != -9999999 &
                    xdata$CycleP_PO4mgL != -10 &  
                    !is.nan(xdata$CycleP_PO4mgL) &
                    xdata$CycleP_Last_Smp_Status %in% c(4,9) &
                    xdata$CycleP_Flush1Avg != 0,]
            }
            
            if(nrow(xdata) > 1) {
            ## Flag rows with TIMESTAMP repeating (flag first instance)
            for(i in 2:nrow(xdata)) {
                ifelse(xdata$TIMESTAMP[i] == xdata$TIMESTAMP[i+1],
                       xdata$keep[i] <- 0, xdata$keep[i] <- 1)
            }
            
            ## Remove rows with TIMESTAMP repeating (remove first instance)
            xdata <- xdata[xdata$keep == 1,]
            }
            
            if(nrow(xdata) > 1) {
            ## Flag rows with TIMESTAMP out of order
            for(i in 2:nrow(xdata)) {
                ifelse(xdata$TIMESTAMP[i] <= xdata$TIMESTAMP[i-1],
                       xdata$keep[i] <- 0, xdata$keep[i] <- 1)
            }
            
            ## Remove rows with TIMESTAMP out of order
            xdata <- xdata[xdata$keep == 1,c(1:(length(xdata)-1))]
            }
            if(nrow(xdata) > 0) {
            ## Correct CycleP_PO4mgL field if the units were stored incorrectly
            for(i in 1:nrow(xdata)) {
                if((xdata$CycleP_QC2[i] * 10) %% 10 == 1) {
                    xdata$CycleP_PO4mgL[i] <- round(xdata$CycleP_PO4mgL[i]/3.06618,4)
                    xdata$CycleP_Units[i] <- paste(trunc(CycleP_QC2[i]),".2",sep="")
                } 
            }
            }
            
            ## Convert all data back into factor so they can be reattached to the header
            xdata[,1:length(xdata)] <- sapply(xdata[,1:length(xdata)],as.factor)
            
            ## Remove any rows with NA in any column
            xdata <- xdata[complete.cases(xdata),]
        }
        
        ## Bind the 4 header rows back to the data
        alldata <- rbind(xhead,xdata)
        
        ## Remove the CycleP_Date_Year field
        alldata <- alldata[, -which(names(alldata) %in% c("CycleP_Date_Year"))]
        
        ## Store the corrected data back into the list
        newfiles[[j]] <- alldata
    }
    ## Write corrected files to C:/WQ_TEL_LZ/    
    for(k in 1:length(newfiles)) {
        write.table(newfiles[[k]],file = paste("C:/WQ_TEL_LZ/",names(newfiles)[k],".dat",sep=""),
                    row.names = F, sep = ",", col.names = F)
    }  
}


if(length(oldfiles) > 0) {
    ## Correct the DateTime field for the Old Cycle data ####    
    for(j in 1:length(oldfiles)) {
        ## Store the list element as a data frame
        x <- oldfiles[[j]]
        
        ## Strip 4 header rows with metadata to be attached to the corrected
        ## data after the TIMESTAMP field is corrected
        xhead <- x[1:4,]
        
        ## Remove the 4 header rows (stored above as xhead)
        xdata <- x[-c(1:4),]
        
        ## Convert numeric fields to numeric variables
        xdata[,3:length(xdata)] <- sapply(xdata[,3:length(xdata)],
                                          function(x) as.numeric(as.character(x)))
        
        ## Store the TIMESTAMP as a date field for to allow for filtering by date
        xdata$TIMESTAMP <- as.Date(xdata$TIMESTAMP)
        
        ## Reduce the data frame to only the last 30 days of data
        xdata <- xdata[xdata$TIMESTAMP > (Sys.Date() - 30),]
        
        ## Convert the TIMESTAMP field back to a factor
        xdata$TIMESTAMP <- as.factor(xdata$TIMESTAMP)
        
        ## Create a new field that stores the time rounded to the closest hour
        xdata$CycleP_Rounded_Time <- ifelse(round((xdata$CycleP_Time %% 1)*100) < 30,
                                            trunc(xdata$CycleP_Time),
                                            ceiling(xdata$CycleP_Time))
        
        ## Flag any rows that contain no data (or zeroes) in the Date field
        if(nrow(xdata) > 0) {
	    xdata$keep <- 1
            for(i in 1:nrow(xdata)) {
            	ifelse(xdata$CycleP_Date[i] == 0 |
                       is.na(xdata$CycleP_Date[i]) |
                       is.nan(xdata$CycleP_Date[i]),
                       xdata$keep[i] <- 0,xdata$keep[i] <- 1)
	    }
        }
        
        ## Stitch together the new TIMESTAMP field using the Date and Time data
        ## stored by the sonde
        for(i in 1:nrow(xdata)) {
            xdata$TIMESTAMP <- paste("20",trunc(xdata$CycleP_Date), "-", 
                                     round((xdata$CycleP_Date %% 1)*100), "-",
                                     as.integer(round(xdata$CycleP_Date * 10000)) %% 100,
                                     " ", trunc(xdata$CycleP_Rounded_Time), ":00", sep = "")
        }
        
        ## Convert TIMESTAMP to a DateTime field for consistent formatting
        xdata$TIMESTAMP <- as.POSIXct(xdata$TIMESTAMP,format = c("%Y-%m-%d %H:%M"), tz = "EST")
        
        ## Remove the rounded time field
        xdata <- xdata[, -which(names(xdata) %in% c("CycleP_Rounded_Time"))]
        
        
        ## Remove the fields with NaN in RunNum
        xdata <- xdata[!is.nan(xdata$CycleP_RunNum),]
        
        ## Flag rows with run number repeating (after first instance)
        for(i in 2:nrow(xdata)) {
            if(xdata$CycleP_RunNum[i] == xdata$CycleP_RunNum[i-1] &
               xdata$keep[i] == 1) {
                xdata$keep[i] <- 0
            }
        }
        
        ## Remove rows with run number repeating (after first instance)
        xdata <- xdata[xdata$keep == 1,]
        
        ## Remove any rows where Battery Voltage = 0
        ## Remove any rows where PO4 value = -9999999 or NaN
        ## Remove any rows where Last Sample Stage is not 4 or 9
        ## Remove any rows where Flush1Avg = 0
        xdata <- xdata[xdata$CycleP_BattVolt != 0 &
                       xdata$CycleP_PO4mgL != -9999999 &
                       xdata$CycleP_PO4mgL != -10 &  
                       !is.nan(xdata$CycleP_PO4mgL) &
                       xdata$CycleP_LastSmplStage %in% c(4,9),]
        
        ## Flag rows with TIMESTAMP repeating (flag first instance)
        for(i in 2:nrow(xdata)) {
            ifelse(xdata$TIMESTAMP[i] == xdata$TIMESTAMP[i+1],
                   xdata$keep[i] <- 0, xdata$keep[i] <- 1)
        }
        
        ## Remove rows with TIMESTAMP repeating (remove first instance)
        xdata <- xdata[xdata$keep == 1,]
        
        ## Flag rows with TIMESTAMP out of order
        for(i in 2:nrow(xdata)) {
            ifelse(xdata$TIMESTAMP[i] <= xdata$TIMESTAMP[i-1],
                   xdata$keep[i] <- 0, xdata$keep[i] <- 1)
        }
        
        ## Remove rows with TIMESTAMP out of order
        xdata <- xdata[xdata$keep == 1,c(1:(length(xdata)-1))]
        
        ## Correct CycleP_PO4mgL field if the units were stored incorrectly
        for(i in 1:nrow(xdata)) {
            if(xdata$CycleP_Units[i] == 1) {
                xdata$CycleP_PO4mgL[i] <- round(xdata$CycleP_PO4mgL[i]/3.06618,4)
                xdata$CycleP_Units[i] <- 2
            } 
        }
        
        ## Convert all data back into factor so they can be reattached to the header
        xdata[,1:length(xdata)] <- sapply(xdata[,1:length(xdata)],as.factor)
        
        ## Remove any rows with NA in any column
        xdata <- xdata[complete.cases(xdata),]
        
        ## Bind the 4 header rows back to the data
        alldata <- rbind(xhead,xdata)
        
        ## Store the corrected data back into the list
        oldfiles[[j]] <- alldata
    }
    for(k in 1:length(oldfiles)) {
        write.table(oldfiles[[k]],file = paste("C:/WQ_TEL_LZ/",names(oldfiles)[k],".dat",sep=""),
                    row.names = F, sep = ",", col.names = F)
    } 
}


