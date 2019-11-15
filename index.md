HydroCycle Data Pre-Processing for AQUARIUS Time-Series
================
Margaret Guyette

<style>
  .flat-table {
    display: block;
    font-family: sans-serif;
    -webkit-font-smoothing: antialiased;
    font-size: 115%;
    overflow: auto;
    width: auto;
  }
  thead {
    background-color: rgb(112, 196, 105);
    color: white;
    font-weight: normal;
    padding: 20px 30px;
    text-align: center;
  }
  tbody {
    background-color: rgb(238, 238, 238);
    color: rgb(111, 111, 111);
    padding: 20px 30px;
  }
</style>
### Pre-processing HydroCycle-PO4 Data Files for AQUARIUS Time-Series Integration

The St. Johns River Water Management District uses Sea-Bird Scientific HydroCycle-PO4 Phosphate Sensors to collect phosphate data to support various projects. These are continuously deployed, collecting data every two hours and transmitting data files to District servers via telemetry. The data files are not formatted well for direct import into AQUARIUS Time-Series, and there is some pre-processing that makes it easier for the data to be quality assured once it is imported.

This script was designed to use only base packages

The program for HydroCycle-PO4 data used by the District is formatted like this:

``` r
df <- read.csv("~/Documents/RProjects/Aquarius_Cycle/DataFiles/Jane_Green_Creek_CM_Cycle.dat",
               header = F)
colnames(df) <- as.character(unlist(df[2,]))
kable(head(df))
```

| TIMESTAMP           | RECORD                 | CycleP\_RunNum | CycleP\_PO4mgL | CycleP\_OAQC     | CycleP\_QC1                        | CycleP\_QC2 | CycleP\_BattVolt | CycleP\_Flush1Avg | CycleP\_Last\_Smp\_Status | CycleP\_Date\_Year | CycleP\_Date\_MMDD | CycleP\_Time\_HHMM |
|:--------------------|:-----------------------|:---------------|:---------------|:-----------------|:-----------------------------------|:------------|:-----------------|:------------------|:--------------------------|:-------------------|:-------------------|:-------------------|
| TOA5                | Jane\_Green\_Creek\_CM | CR1000         | 72020          | CR1000.Std.27.04 | CPU:CM\_2017\_New\_Cycle\_Ver2.CR1 | 22435       | Cycle            |                   |                           |                    |                    |                    |
| TIMESTAMP           | RECORD                 | CycleP\_RunNum | CycleP\_PO4mgL | CycleP\_OAQC     | CycleP\_QC1                        | CycleP\_QC2 | CycleP\_BattVolt | CycleP\_Flush1Avg | CycleP\_Last\_Smp\_Status | CycleP\_Date\_Year | CycleP\_Date\_MMDD | CycleP\_Time\_HHMM |
| TS                  | RN                     |                |                |                  |                                    |             |                  |                   |                           |                    |                    |                    |
|                     |                        | Smp            | Smp            | Smp              | Smp                                | Smp         | Smp              | Smp               | Smp                       | Smp                | Smp                | Smp                |
| 2018-02-06 16:00:00 | 14                     | NAN            | NAN            | NAN              | NAN                                | NAN         | NAN              | NAN               | NAN                       | NAN                | NAN                | NAN                |
| 2018-02-06 18:00:00 | 15                     | NAN            | NAN            | NAN              | NAN                                | NAN         | NAN              | NAN               | NAN                       | NAN                | NAN                | NAN                |

First we need to strip the four header rows with metadata from the dataframe. This is not needed during pre-processing, but it will be bound back to the corrected data after pre-processing.

``` r
dfhead <- df[1:4,]
kable(dfhead)
```

| TIMESTAMP | RECORD                 | CycleP\_RunNum | CycleP\_PO4mgL | CycleP\_OAQC     | CycleP\_QC1                        | CycleP\_QC2 | CycleP\_BattVolt | CycleP\_Flush1Avg | CycleP\_Last\_Smp\_Status | CycleP\_Date\_Year | CycleP\_Date\_MMDD | CycleP\_Time\_HHMM |
|:----------|:-----------------------|:---------------|:---------------|:-----------------|:-----------------------------------|:------------|:-----------------|:------------------|:--------------------------|:-------------------|:-------------------|:-------------------|
| TOA5      | Jane\_Green\_Creek\_CM | CR1000         | 72020          | CR1000.Std.27.04 | CPU:CM\_2017\_New\_Cycle\_Ver2.CR1 | 22435       | Cycle            |                   |                           |                    |                    |                    |
| TIMESTAMP | RECORD                 | CycleP\_RunNum | CycleP\_PO4mgL | CycleP\_OAQC     | CycleP\_QC1                        | CycleP\_QC2 | CycleP\_BattVolt | CycleP\_Flush1Avg | CycleP\_Last\_Smp\_Status | CycleP\_Date\_Year | CycleP\_Date\_MMDD | CycleP\_Time\_HHMM |
| TS        | RN                     |                |                |                  |                                    |             |                  |                   |                           |                    |                    |                    |
|           |                        | Smp            | Smp            | Smp              | Smp                                | Smp         | Smp              | Smp               | Smp                       | Smp                | Smp                | Smp                |

``` r
dfdata <- df[-c(1:4),]
kable(head(dfdata, 2))
```

|     | TIMESTAMP           | RECORD | CycleP\_RunNum | CycleP\_PO4mgL | CycleP\_OAQC | CycleP\_QC1 | CycleP\_QC2 | CycleP\_BattVolt | CycleP\_Flush1Avg | CycleP\_Last\_Smp\_Status | CycleP\_Date\_Year | CycleP\_Date\_MMDD | CycleP\_Time\_HHMM |
|-----|:--------------------|:-------|:---------------|:---------------|:-------------|:------------|:------------|:-----------------|:------------------|:--------------------------|:-------------------|:-------------------|:-------------------|
| 5   | 2018-02-06 16:00:00 | 14     | NAN            | NAN            | NAN          | NAN         | NAN         | NAN              | NAN               | NAN                       | NAN                | NAN                | NAN                |
| 6   | 2018-02-06 18:00:00 | 15     | NAN            | NAN            | NAN          | NAN         | NAN         | NAN              | NAN               | NAN                       | NAN                | NAN                | NAN                |

Checking the structure of dfdata reveals that we need to change certain field classes.

``` r
str(dfdata)
```

    ## 'data.frame':    7703 obs. of  13 variables:
    ##  $ TIMESTAMP             : Factor w/ 7706 levels "","2018-02-06 16:00:00",..: 2 3 4 5 6 7 8 9 10 11 ...
    ##  $ RECORD                : Factor w/ 4325 levels "","0","1","10",..: 448 559 670 781 892 1003 1115 1226 1337 1448 ...
    ##  $ CycleP_RunNum         : Factor w/ 498 levels "","0","1","10",..: 497 497 497 497 497 497 497 497 497 497 ...
    ##  $ CycleP_PO4mgL         : Factor w/ 545 levels "","-0.001","-0.002",..: 544 544 544 544 544 544 544 544 544 544 ...
    ##  $ CycleP_OAQC           : Factor w/ 9 levels "","1","2","3",..: 8 8 8 8 8 8 8 8 8 8 ...
    ##  $ CycleP_QC1            : Factor w/ 20 levels "","111","113",..: 19 19 19 19 19 19 19 19 19 19 ...
    ##  $ CycleP_QC2            : Factor w/ 38 levels "","111.2","112.2",..: 37 37 37 37 37 37 37 37 37 37 ...
    ##  $ CycleP_BattVolt       : Factor w/ 41 levels "","10","10.1",..: 40 40 40 40 40 40 40 40 40 40 ...
    ##  $ CycleP_Flush1Avg      : Factor w/ 1822 levels "","0","1348",..: 1821 1821 1821 1821 1821 1821 1821 1821 1821 1821 ...
    ##  $ CycleP_Last_Smp_Status: Factor w/ 9 levels "","0","1","4",..: 8 8 8 8 8 8 8 8 8 8 ...
    ##  $ CycleP_Date_Year      : Factor w/ 6 levels "","2018","2019",..: 5 5 5 5 5 5 5 5 5 5 ...
    ##  $ CycleP_Date_MMDD      : Factor w/ 369 levels "","1.01","1.02",..: 368 368 368 368 368 368 368 368 368 368 ...
    ##  $ CycleP_Time_HHMM      : Factor w/ 99 levels "","0.03","0.04",..: 98 98 98 98 98 98 98 98 98 98 ...

Change all numeric fields to numeric variables and change the TIMESTAMP field to a date to allow for filtering by date.

``` r
dfdata[,2:length(dfdata)] <- sapply(dfdata[,2:length(dfdata)],
                                    function(x) as.numeric(as.character(x)))
dfdata$TIMESTAMP <- as.Date(dfdata$TIMESTAMP)
str(dfdata)
```

    ## 'data.frame':    7703 obs. of  13 variables:
    ##  $ TIMESTAMP             : Date, format: "2018-02-06" "2018-02-06" ...
    ##  $ RECORD                : num  14 15 16 17 18 19 20 21 22 23 ...
    ##  $ CycleP_RunNum         : num  NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ...
    ##  $ CycleP_PO4mgL         : num  NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ...
    ##  $ CycleP_OAQC           : num  NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ...
    ##  $ CycleP_QC1            : num  NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ...
    ##  $ CycleP_QC2            : num  NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ...
    ##  $ CycleP_BattVolt       : num  NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ...
    ##  $ CycleP_Flush1Avg      : num  NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ...
    ##  $ CycleP_Last_Smp_Status: num  NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ...
    ##  $ CycleP_Date_Year      : num  NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ...
    ##  $ CycleP_Date_MMDD      : num  NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ...
    ##  $ CycleP_Time_HHMM      : num  NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ...

The Time-Series are updated regularly, so we work with only 30 days of data each time.

``` r
dfdata <- dfdata[dfdata$TIMESTAMP > (max(dfdata$TIMESTAMP) - 30),]
kable(head(dfdata, 2))
```

|      | TIMESTAMP  |  RECORD|  CycleP\_RunNum|  CycleP\_PO4mgL|  CycleP\_OAQC|  CycleP\_QC1|  CycleP\_QC2|  CycleP\_BattVolt|  CycleP\_Flush1Avg|  CycleP\_Last\_Smp\_Status|  CycleP\_Date\_Year|  CycleP\_Date\_MMDD|  CycleP\_Time\_HHMM|
|------|:-----------|-------:|---------------:|---------------:|-------------:|------------:|------------:|-----------------:|------------------:|--------------------------:|-------------------:|-------------------:|-------------------:|
| 7353 | 2019-10-12 |    1471|              19|           0.209|             1|          111|        112.2|              12.1|               3329|                          4|                2019|               10.11|               22.04|
| 7354 | 2019-10-12 |    1472|              20|           0.212|             1|          111|        112.2|              12.1|               3329|                          4|                2019|               10.12|                0.04|

To align data within AQUARIUS Time-Series, HydroCycle-PO4 data are rounded to the closest hour.

``` r
dfdata$CycleP_Rounded_Time <- ifelse(round((dfdata$CycleP_Time %% 1) * 100) < 30,
                                            trunc(dfdata$CycleP_Time_HHMM),
                                            ceiling(dfdata$CycleP_Time_HHMM))
kable(head(dfdata, 2))
```

|      | TIMESTAMP  |  RECORD|  CycleP\_RunNum|  CycleP\_PO4mgL|  CycleP\_OAQC|  CycleP\_QC1|  CycleP\_QC2|  CycleP\_BattVolt|  CycleP\_Flush1Avg|  CycleP\_Last\_Smp\_Status|  CycleP\_Date\_Year|  CycleP\_Date\_MMDD|  CycleP\_Time\_HHMM|  CycleP\_Rounded\_Time|
|------|:-----------|-------:|---------------:|---------------:|-------------:|------------:|------------:|-----------------:|------------------:|--------------------------:|-------------------:|-------------------:|-------------------:|----------------------:|
| 7353 | 2019-10-12 |    1471|              19|           0.209|             1|          111|        112.2|              12.1|               3329|                          4|                2019|               10.11|               22.04|                     22|
| 7354 | 2019-10-12 |    1472|              20|           0.212|             1|          111|        112.2|              12.1|               3329|                          4|                2019|               10.12|                0.04|                      0|

Before proceeding, rows that contain no data or zeroes in the Date field are removed.

``` r
if(nrow(dfdata) > 0) {
     dfdata$keep <- 1
     for(i in 1:nrow(dfdata)) {
       ifelse(dfdata$CycleP_Date_Year[i] == 0 |
              is.na(dfdata$CycleP_Date_Year[i]) |
              is.nan(dfdata$CycleP_Date_Year[i]),
              dfdata$keep[i] <- 0, dfdata$keep[i] <- 1)
     }     
}
dfdata <- dfdata[dfdata$keep == 1,]
```

As long as the file still contains data, the new TIMESTAMP field is stitched together using the Date and Time data stored by the sonde, and then it is converted to a DateTime POSIXct field.

``` r
if(nrow(dfdata) > 0) {
  for(i in 1:nrow(dfdata)) {
    dfdata$TIMESTAMP <- paste(dfdata$CycleP_Date_Year, "-", 
                              trunc(dfdata$CycleP_Date_MMDD), "-", 
                              round((dfdata$CycleP_Date_MMDD %% 1)*100),
                              " ", trunc(dfdata$CycleP_Rounded_Time), ":00", sep = "")
  }
}
dfdata$TIMESTAMP <- as.POSIXct(dfdata$TIMESTAMP,format = c("%Y-%m-%d %H:%M"), tz = "EST")
kable(head(dfdata, 2))
```

|      | TIMESTAMP           |  RECORD|  CycleP\_RunNum|  CycleP\_PO4mgL|  CycleP\_OAQC|  CycleP\_QC1|  CycleP\_QC2|  CycleP\_BattVolt|  CycleP\_Flush1Avg|  CycleP\_Last\_Smp\_Status|  CycleP\_Date\_Year|  CycleP\_Date\_MMDD|  CycleP\_Time\_HHMM|  CycleP\_Rounded\_Time|  keep|
|------|:--------------------|-------:|---------------:|---------------:|-------------:|------------:|------------:|-----------------:|------------------:|--------------------------:|-------------------:|-------------------:|-------------------:|----------------------:|-----:|
| 7353 | 2019-10-11 22:00:00 |    1471|              19|           0.209|             1|          111|        112.2|              12.1|               3329|                          4|                2019|               10.11|               22.04|                     22|     1|
| 7354 | 2019-10-12 00:00:00 |    1472|              20|           0.212|             1|          111|        112.2|              12.1|               3329|                          4|                2019|               10.12|                0.04|                      0|     1|

The rounded time field is removed.

``` r
dfdata <- dfdata[, -which(names(dfdata) %in% c("CycleP_Rounded_Time"))]
```

All rows with NaN in the RunNum column are removed because they do not include usable data.

``` r
dfdata <- dfdata[!is.nan(dfdata$CycleP_RunNum),]
```

When RunNum repeats, any rows with repeated values are removed after the first instance.

``` r
for(i in 2:nrow(dfdata)) {
  if(dfdata$CycleP_RunNum[i] == dfdata$CycleP_RunNum[i - 1] &
     dfdata$keep[i] == 1) {
     dfdata$keep[i] <- 0
  }
}
dfdata <- dfdata[dfdata$keep == 1,]
```

There are a number of other scenarios where we do not have any confidence in the data. Any rows where Battery Voltage = 0, the PO4 values = -9999999 or NaN, the Last Sample Stage is not 4 or 9, and Flush1Avg = 0 are removed.

``` r
dfdata <- dfdata[
  dfdata$CycleP_BattVolt != 0 &
    dfdata$CycleP_PO4mgL != -9999999 &
    dfdata$CycleP_PO4mgL != -10 &  
    !is.nan(dfdata$CycleP_PO4mgL) &
    dfdata$CycleP_Last_Smp_Status %in% c(4, 9) &
    dfdata$CycleP_Flush1Avg != 0,]
```

Another common occurence is that TIMESTAMP can repeat. In these cases, only the first row containing that TIMESTAMP is retained.

``` r
for(i in 2:nrow(dfdata)) {
  ifelse(dfdata$TIMESTAMP[i] == dfdata$TIMESTAMP[i + 1],
         dfdata$keep[i] <- 0, dfdata$keep[i] <- 1)
}
dfdata <- dfdata[dfdata$keep == 1,]
```

Sometimes the TIMESTAMP comes in out of order. These rows are also removed.

``` r
for(i in 2:nrow(dfdata)) {
  ifelse(dfdata$TIMESTAMP[i] <= dfdata$TIMESTAMP[i-1],
         dfdata$keep[i] <- 0, dfdata$keep[i] <- 1)
}
dfdata <- dfdata[dfdata$keep == 1, c(1:(length(dfdata)-1))]
```

As long as data still exist, if an error occurred in the program where the incorrect units were stored, the values are corrected to convert to mgP/L.

``` r
if(nrow(dfdata) > 0) {
  ## Correct CycleP_PO4mgL field if the units were stored incorrectly
  for(i in 1:nrow(dfdata)) {
    if((dfdata$CycleP_QC2[i] * 10) %% 10 == 1) {
      dfdata$CycleP_PO4mgL[i] <- round(dfdata$CycleP_PO4mgL[i]/3.06618,4)
      dfdata$CycleP_Units[i] <- paste(trunc(CycleP_QC2[i]), ".2", sep="")
    } 
  }
}
```

All fields need to be stored as factors so they can be reattached to the header.

``` r
dfdata[,1:length(dfdata)] <- sapply(dfdata[,1:length(dfdata)], as.factor)
str(dfdata)
```

    ## 'data.frame':    355 obs. of  13 variables:
    ##  $ TIMESTAMP             : chr  "2019-10-11 22:00:00" "2019-10-12 00:00:00" "2019-10-12 02:00:00" "2019-10-12 04:00:00" ...
    ##  $ RECORD                : chr  "1471" "1472" "1473" "1474" ...
    ##  $ CycleP_RunNum         : chr  "19" "20" "21" "22" ...
    ##  $ CycleP_PO4mgL         : chr  "0.209" "0.212" "0.213" "0.211" ...
    ##  $ CycleP_OAQC           : chr  "1" "1" "1" "1" ...
    ##  $ CycleP_QC1            : chr  "111" "111" "111" "111" ...
    ##  $ CycleP_QC2            : chr  "112.2" "112.2" "112.2" "112.2" ...
    ##  $ CycleP_BattVolt       : chr  "12.1" "12.1" "12" "12" ...
    ##  $ CycleP_Flush1Avg      : chr  "3329" "3329" "3329" "3343" ...
    ##  $ CycleP_Last_Smp_Status: chr  "4" "4" "4" "4" ...
    ##  $ CycleP_Date_Year      : chr  "2019" "2019" "2019" "2019" ...
    ##  $ CycleP_Date_MMDD      : chr  "10.11" "10.12" "10.12" "10.12" ...
    ##  $ CycleP_Time_HHMM      : chr  "22.04" "0.04" "2.04" "4.04" ...

Finally, if any rows contain NA in any column, they cannot be used, so they are removed.

``` r
dfdata <- dfdata[complete.cases(dfdata),]
```

The header file and data file are combined again, and the CycleP\_Date\_Year field is removed because it is not needed.

``` r
alldata <- rbind(dfhead,dfdata)
alldata <- alldata[, -which(names(alldata) %in% c("CycleP_Date_Year"))]
kable(head(alldata))
```

|      | TIMESTAMP           | RECORD                 | CycleP\_RunNum | CycleP\_PO4mgL | CycleP\_OAQC     | CycleP\_QC1                        | CycleP\_QC2 | CycleP\_BattVolt | CycleP\_Flush1Avg | CycleP\_Last\_Smp\_Status | CycleP\_Date\_MMDD | CycleP\_Time\_HHMM |
|------|:--------------------|:-----------------------|:---------------|:---------------|:-----------------|:-----------------------------------|:------------|:-----------------|:------------------|:--------------------------|:-------------------|:-------------------|
| 1    | TOA5                | Jane\_Green\_Creek\_CM | CR1000         | 72020          | CR1000.Std.27.04 | CPU:CM\_2017\_New\_Cycle\_Ver2.CR1 | 22435       | Cycle            |                   |                           |                    |                    |
| 2    | TIMESTAMP           | RECORD                 | CycleP\_RunNum | CycleP\_PO4mgL | CycleP\_OAQC     | CycleP\_QC1                        | CycleP\_QC2 | CycleP\_BattVolt | CycleP\_Flush1Avg | CycleP\_Last\_Smp\_Status | CycleP\_Date\_MMDD | CycleP\_Time\_HHMM |
| 3    | TS                  | RN                     |                |                |                  |                                    |             |                  |                   |                           |                    |                    |
| 4    |                     |                        | Smp            | Smp            | Smp              | Smp                                | Smp         | Smp              | Smp               | Smp                       | Smp                | Smp                |
| 7353 | 2019-10-11 22:00:00 | 1471                   | 19             | 0.209          | 1                | 111                                | 112.2       | 12.1             | 3329              | 4                         | 10.11              | 22.04              |
| 7354 | 2019-10-12 00:00:00 | 1472                   | 20             | 0.212          | 1                | 111                                | 112.2       | 12.1             | 3329              | 4                         | 10.12              | 0.04               |
