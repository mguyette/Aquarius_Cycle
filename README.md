
The St. Johns River Water Management District uses Sea-Bird Scientific HydroCycle-PO4 Phosphate Sensors to collect phosphate data to support various projects. These are continuously deployed, collecting data every two hours and transmitting data files to District servers via telemetry. The data files are not formatted well for direct import into AQUARIUS Time-Series, and there is some pre-processing that makes it easier for the data to be quality assured once it is imported.

This script was designed to use only base packages

The program for HydroCycle-PO4 data used by the District is formatted like this:

``` r
df <- read.csv("./DataFiles/Jane_Green_Creek_CM_Cycle.dat",
               header = F, check.names = F)
colnames(df) <- as.character(unlist(df[2,]))
pander(head(df), style = "rmarkdown", split.tables = Inf)
```

<table>
<colgroup>
<col width="8%" />
<col width="8%" />
<col width="6%" />
<col width="6%" />
<col width="7%" />
<col width="12%" />
<col width="5%" />
<col width="6%" />
<col width="7%" />
<col width="9%" />
<col width="7%" />
<col width="7%" />
<col width="7%" />
</colgroup>
<thead>
<tr class="header">
<th align="center">TIMESTAMP</th>
<th align="center">RECORD</th>
<th align="center">CycleP_RunNum</th>
<th align="center">CycleP_PO4mgL</th>
<th align="center">CycleP_OAQC</th>
<th align="center">CycleP_QC1</th>
<th align="center">CycleP_QC2</th>
<th align="center">CycleP_BattVolt</th>
<th align="center">CycleP_Flush1Avg</th>
<th align="center">CycleP_Last_Smp_Status</th>
<th align="center">CycleP_Date_Year</th>
<th align="center">CycleP_Date_MMDD</th>
<th align="center">CycleP_Time_HHMM</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="center">TOA5</td>
<td align="center">Jane_Green_Creek_CM</td>
<td align="center">CR1000</td>
<td align="center">72020</td>
<td align="center">CR1000.Std.27.04</td>
<td align="center">CPU:CM_2017_New_Cycle_Ver2.CR1</td>
<td align="center">22435</td>
<td align="center">Cycle</td>
<td align="center"></td>
<td align="center"></td>
<td align="center"></td>
<td align="center"></td>
<td align="center"></td>
</tr>
<tr class="even">
<td align="center">TIMESTAMP</td>
<td align="center">RECORD</td>
<td align="center">CycleP_RunNum</td>
<td align="center">CycleP_PO4mgL</td>
<td align="center">CycleP_OAQC</td>
<td align="center">CycleP_QC1</td>
<td align="center">CycleP_QC2</td>
<td align="center">CycleP_BattVolt</td>
<td align="center">CycleP_Flush1Avg</td>
<td align="center">CycleP_Last_Smp_Status</td>
<td align="center">CycleP_Date_Year</td>
<td align="center">CycleP_Date_MMDD</td>
<td align="center">CycleP_Time_HHMM</td>
</tr>
<tr class="odd">
<td align="center">TS</td>
<td align="center">RN</td>
<td align="center"></td>
<td align="center"></td>
<td align="center"></td>
<td align="center"></td>
<td align="center"></td>
<td align="center"></td>
<td align="center"></td>
<td align="center"></td>
<td align="center"></td>
<td align="center"></td>
<td align="center"></td>
</tr>
<tr class="even">
<td align="center"></td>
<td align="center"></td>
<td align="center">Smp</td>
<td align="center">Smp</td>
<td align="center">Smp</td>
<td align="center">Smp</td>
<td align="center">Smp</td>
<td align="center">Smp</td>
<td align="center">Smp</td>
<td align="center">Smp</td>
<td align="center">Smp</td>
<td align="center">Smp</td>
<td align="center">Smp</td>
</tr>
<tr class="odd">
<td align="center">2018-02-06 16:00:00</td>
<td align="center">14</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
</tr>
<tr class="even">
<td align="center">2018-02-06 18:00:00</td>
<td align="center">15</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
</tr>
</tbody>
</table>

First we need to strip the four header rows with metadata from the dataframe. This is not needed during pre-processing, but it will be bound back to the corrected data after pre-processing.

``` r
dfhead <- df[1:4,]
pander(dfhead, style = "rmarkdown", split.tables = Inf)
```

<table style="width:100%;">
<colgroup>
<col width="4%" />
<col width="8%" />
<col width="6%" />
<col width="6%" />
<col width="7%" />
<col width="13%" />
<col width="5%" />
<col width="7%" />
<col width="7%" />
<col width="10%" />
<col width="7%" />
<col width="7%" />
<col width="7%" />
</colgroup>
<thead>
<tr class="header">
<th align="center">TIMESTAMP</th>
<th align="center">RECORD</th>
<th align="center">CycleP_RunNum</th>
<th align="center">CycleP_PO4mgL</th>
<th align="center">CycleP_OAQC</th>
<th align="center">CycleP_QC1</th>
<th align="center">CycleP_QC2</th>
<th align="center">CycleP_BattVolt</th>
<th align="center">CycleP_Flush1Avg</th>
<th align="center">CycleP_Last_Smp_Status</th>
<th align="center">CycleP_Date_Year</th>
<th align="center">CycleP_Date_MMDD</th>
<th align="center">CycleP_Time_HHMM</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="center">TOA5</td>
<td align="center">Jane_Green_Creek_CM</td>
<td align="center">CR1000</td>
<td align="center">72020</td>
<td align="center">CR1000.Std.27.04</td>
<td align="center">CPU:CM_2017_New_Cycle_Ver2.CR1</td>
<td align="center">22435</td>
<td align="center">Cycle</td>
<td align="center"></td>
<td align="center"></td>
<td align="center"></td>
<td align="center"></td>
<td align="center"></td>
</tr>
<tr class="even">
<td align="center">TIMESTAMP</td>
<td align="center">RECORD</td>
<td align="center">CycleP_RunNum</td>
<td align="center">CycleP_PO4mgL</td>
<td align="center">CycleP_OAQC</td>
<td align="center">CycleP_QC1</td>
<td align="center">CycleP_QC2</td>
<td align="center">CycleP_BattVolt</td>
<td align="center">CycleP_Flush1Avg</td>
<td align="center">CycleP_Last_Smp_Status</td>
<td align="center">CycleP_Date_Year</td>
<td align="center">CycleP_Date_MMDD</td>
<td align="center">CycleP_Time_HHMM</td>
</tr>
<tr class="odd">
<td align="center">TS</td>
<td align="center">RN</td>
<td align="center"></td>
<td align="center"></td>
<td align="center"></td>
<td align="center"></td>
<td align="center"></td>
<td align="center"></td>
<td align="center"></td>
<td align="center"></td>
<td align="center"></td>
<td align="center"></td>
<td align="center"></td>
</tr>
<tr class="even">
<td align="center"></td>
<td align="center"></td>
<td align="center">Smp</td>
<td align="center">Smp</td>
<td align="center">Smp</td>
<td align="center">Smp</td>
<td align="center">Smp</td>
<td align="center">Smp</td>
<td align="center">Smp</td>
<td align="center">Smp</td>
<td align="center">Smp</td>
<td align="center">Smp</td>
<td align="center">Smp</td>
</tr>
</tbody>
</table>

``` r
dfdata <- df[-c(1:4),]
pander(head(dfdata, 2), style = "rmarkdown", split.tables = Inf)
```

<table style="width:100%;">
<colgroup>
<col width="3%" />
<col width="9%" />
<col width="3%" />
<col width="6%" />
<col width="6%" />
<col width="6%" />
<col width="5%" />
<col width="5%" />
<col width="7%" />
<col width="8%" />
<col width="10%" />
<col width="8%" />
<col width="8%" />
<col width="8%" />
</colgroup>
<thead>
<tr class="header">
<th align="center"> </th>
<th align="center">TIMESTAMP</th>
<th align="center">RECORD</th>
<th align="center">CycleP_RunNum</th>
<th align="center">CycleP_PO4mgL</th>
<th align="center">CycleP_OAQC</th>
<th align="center">CycleP_QC1</th>
<th align="center">CycleP_QC2</th>
<th align="center">CycleP_BattVolt</th>
<th align="center">CycleP_Flush1Avg</th>
<th align="center">CycleP_Last_Smp_Status</th>
<th align="center">CycleP_Date_Year</th>
<th align="center">CycleP_Date_MMDD</th>
<th align="center">CycleP_Time_HHMM</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="center"><strong>5</strong></td>
<td align="center">2018-02-06 16:00:00</td>
<td align="center">14</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
</tr>
<tr class="even">
<td align="center"><strong>6</strong></td>
<td align="center">2018-02-06 18:00:00</td>
<td align="center">15</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
<td align="center">NAN</td>
</tr>
</tbody>
</table>

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
pander(head(dfdata, 2), style = "rmarkdown", split.tables = Inf)
```

<table>
<colgroup>
<col width="4%" />
<col width="5%" />
<col width="4%" />
<col width="7%" />
<col width="7%" />
<col width="6%" />
<col width="5%" />
<col width="5%" />
<col width="8%" />
<col width="8%" />
<col width="11%" />
<col width="8%" />
<col width="8%" />
<col width="8%" />
</colgroup>
<thead>
<tr class="header">
<th align="center"> </th>
<th align="center">TIMESTAMP</th>
<th align="center">RECORD</th>
<th align="center">CycleP_RunNum</th>
<th align="center">CycleP_PO4mgL</th>
<th align="center">CycleP_OAQC</th>
<th align="center">CycleP_QC1</th>
<th align="center">CycleP_QC2</th>
<th align="center">CycleP_BattVolt</th>
<th align="center">CycleP_Flush1Avg</th>
<th align="center">CycleP_Last_Smp_Status</th>
<th align="center">CycleP_Date_Year</th>
<th align="center">CycleP_Date_MMDD</th>
<th align="center">CycleP_Time_HHMM</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="center"><strong>7353</strong></td>
<td align="center">2019-10-12</td>
<td align="center">1471</td>
<td align="center">19</td>
<td align="center">0.209</td>
<td align="center">1</td>
<td align="center">111</td>
<td align="center">112.2</td>
<td align="center">12.1</td>
<td align="center">3329</td>
<td align="center">4</td>
<td align="center">2019</td>
<td align="center">10.11</td>
<td align="center">22.04</td>
</tr>
<tr class="even">
<td align="center"><strong>7354</strong></td>
<td align="center">2019-10-12</td>
<td align="center">1472</td>
<td align="center">20</td>
<td align="center">0.212</td>
<td align="center">1</td>
<td align="center">111</td>
<td align="center">112.2</td>
<td align="center">12.1</td>
<td align="center">3329</td>
<td align="center">4</td>
<td align="center">2019</td>
<td align="center">10.12</td>
<td align="center">0.04</td>
</tr>
</tbody>
</table>

To align data within AQUARIUS Time-Series, HydroCycle-PO4 data are rounded to the closest hour.

``` r
dfdata$CycleP_Rounded_Time <- ifelse(round((dfdata$CycleP_Time %% 1) * 100) < 30,
                                            trunc(dfdata$CycleP_Time_HHMM),
                                            ceiling(dfdata$CycleP_Time_HHMM))
pander(head(dfdata, 2), style = "rmarkdown", split.tables = Inf)
```

<table>
<colgroup>
<col width="4%" />
<col width="5%" />
<col width="3%" />
<col width="6%" />
<col width="6%" />
<col width="5%" />
<col width="5%" />
<col width="5%" />
<col width="7%" />
<col width="7%" />
<col width="10%" />
<col width="7%" />
<col width="7%" />
<col width="7%" />
<col width="8%" />
</colgroup>
<thead>
<tr class="header">
<th align="center"> </th>
<th align="center">TIMESTAMP</th>
<th align="center">RECORD</th>
<th align="center">CycleP_RunNum</th>
<th align="center">CycleP_PO4mgL</th>
<th align="center">CycleP_OAQC</th>
<th align="center">CycleP_QC1</th>
<th align="center">CycleP_QC2</th>
<th align="center">CycleP_BattVolt</th>
<th align="center">CycleP_Flush1Avg</th>
<th align="center">CycleP_Last_Smp_Status</th>
<th align="center">CycleP_Date_Year</th>
<th align="center">CycleP_Date_MMDD</th>
<th align="center">CycleP_Time_HHMM</th>
<th align="center">CycleP_Rounded_Time</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="center"><strong>7353</strong></td>
<td align="center">2019-10-12</td>
<td align="center">1471</td>
<td align="center">19</td>
<td align="center">0.209</td>
<td align="center">1</td>
<td align="center">111</td>
<td align="center">112.2</td>
<td align="center">12.1</td>
<td align="center">3329</td>
<td align="center">4</td>
<td align="center">2019</td>
<td align="center">10.11</td>
<td align="center">22.04</td>
<td align="center">22</td>
</tr>
<tr class="even">
<td align="center"><strong>7354</strong></td>
<td align="center">2019-10-12</td>
<td align="center">1472</td>
<td align="center">20</td>
<td align="center">0.212</td>
<td align="center">1</td>
<td align="center">111</td>
<td align="center">112.2</td>
<td align="center">12.1</td>
<td align="center">3329</td>
<td align="center">4</td>
<td align="center">2019</td>
<td align="center">10.12</td>
<td align="center">0.04</td>
<td align="center">0</td>
</tr>
</tbody>
</table>

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
pander(head(dfdata, 2), style = "rmarkdown", split.tables = Inf)
```

<table style="width:100%;">
<colgroup>
<col width="4%" />
<col width="8%" />
<col width="3%" />
<col width="6%" />
<col width="6%" />
<col width="5%" />
<col width="4%" />
<col width="4%" />
<col width="6%" />
<col width="7%" />
<col width="9%" />
<col width="7%" />
<col width="7%" />
<col width="7%" />
<col width="8%" />
<col width="2%" />
</colgroup>
<thead>
<tr class="header">
<th align="center"> </th>
<th align="center">TIMESTAMP</th>
<th align="center">RECORD</th>
<th align="center">CycleP_RunNum</th>
<th align="center">CycleP_PO4mgL</th>
<th align="center">CycleP_OAQC</th>
<th align="center">CycleP_QC1</th>
<th align="center">CycleP_QC2</th>
<th align="center">CycleP_BattVolt</th>
<th align="center">CycleP_Flush1Avg</th>
<th align="center">CycleP_Last_Smp_Status</th>
<th align="center">CycleP_Date_Year</th>
<th align="center">CycleP_Date_MMDD</th>
<th align="center">CycleP_Time_HHMM</th>
<th align="center">CycleP_Rounded_Time</th>
<th align="center">keep</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="center"><strong>7353</strong></td>
<td align="center">2019-10-11 22:00:00</td>
<td align="center">1471</td>
<td align="center">19</td>
<td align="center">0.209</td>
<td align="center">1</td>
<td align="center">111</td>
<td align="center">112.2</td>
<td align="center">12.1</td>
<td align="center">3329</td>
<td align="center">4</td>
<td align="center">2019</td>
<td align="center">10.11</td>
<td align="center">22.04</td>
<td align="center">22</td>
<td align="center">1</td>
</tr>
<tr class="even">
<td align="center"><strong>7354</strong></td>
<td align="center">2019-10-12</td>
<td align="center">1472</td>
<td align="center">20</td>
<td align="center">0.212</td>
<td align="center">1</td>
<td align="center">111</td>
<td align="center">112.2</td>
<td align="center">12.1</td>
<td align="center">3329</td>
<td align="center">4</td>
<td align="center">2019</td>
<td align="center">10.12</td>
<td align="center">0.04</td>
<td align="center">0</td>
<td align="center">1</td>
</tr>
</tbody>
</table>

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
dfdata[,1:length(dfdata)] <- lapply(dfdata[,1:length(dfdata)], as.factor)
str(dfdata)
```

    ## 'data.frame':    355 obs. of  13 variables:
    ##  $ TIMESTAMP             : Factor w/ 355 levels "2019-10-11 22:00:00",..: 1 2 3 4 5 6 7 8 9 10 ...
    ##  $ RECORD                : Factor w/ 355 levels "1471","1472",..: 1 2 3 4 5 6 7 8 9 10 ...
    ##  $ CycleP_RunNum         : Factor w/ 355 levels "19","20","21",..: 1 2 3 4 5 6 7 8 9 10 ...
    ##  $ CycleP_PO4mgL         : Factor w/ 113 levels "0.05","0.051",..: 110 112 113 111 109 108 107 105 105 100 ...
    ##  $ CycleP_OAQC           : Factor w/ 3 levels "1","3","4": 1 1 1 1 1 3 1 1 1 1 ...
    ##  $ CycleP_QC1            : Factor w/ 1 level "111": 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ CycleP_QC2            : Factor w/ 4 levels "111.2","112.2",..: 2 2 2 2 2 4 2 2 2 2 ...
    ##  $ CycleP_BattVolt       : Factor w/ 14 levels "11.8","11.9",..: 4 4 3 3 2 2 14 12 8 8 ...
    ##  $ CycleP_Flush1Avg      : Factor w/ 226 levels "2850","2852",..: 221 221 221 226 225 224 222 223 220 219 ...
    ##  $ CycleP_Last_Smp_Status: Factor w/ 2 levels "4","9": 1 1 1 1 1 2 1 1 1 1 ...
    ##  $ CycleP_Date_Year      : Factor w/ 1 level "2019": 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ CycleP_Date_MMDD      : Factor w/ 31 levels "10.11","10.12",..: 1 2 2 2 2 2 2 2 2 2 ...
    ##  $ CycleP_Time_HHMM      : Factor w/ 12 levels "0.04","2.04",..: 12 1 2 3 4 5 6 7 8 9 ...

Finally, if any rows contain NA in any column, they cannot be used, so they are removed.

``` r
dfdata <- dfdata[complete.cases(dfdata),]
```

The header file and data file are combined again, and the CycleP\_Date\_Year field is removed because it is not needed.

``` r
alldata <- rbind(dfhead,dfdata)
alldata <- alldata[, -which(names(alldata) %in% c("CycleP_Date_Year"))]
pander(head(alldata), style = "rmarkdown", split.tables = Inf)
```

<table style="width:100%;">
<colgroup>
<col width="4%" />
<col width="8%" />
<col width="8%" />
<col width="6%" />
<col width="6%" />
<col width="7%" />
<col width="13%" />
<col width="5%" />
<col width="7%" />
<col width="7%" />
<col width="9%" />
<col width="7%" />
<col width="7%" />
</colgroup>
<thead>
<tr class="header">
<th align="center"> </th>
<th align="center">TIMESTAMP</th>
<th align="center">RECORD</th>
<th align="center">CycleP_RunNum</th>
<th align="center">CycleP_PO4mgL</th>
<th align="center">CycleP_OAQC</th>
<th align="center">CycleP_QC1</th>
<th align="center">CycleP_QC2</th>
<th align="center">CycleP_BattVolt</th>
<th align="center">CycleP_Flush1Avg</th>
<th align="center">CycleP_Last_Smp_Status</th>
<th align="center">CycleP_Date_MMDD</th>
<th align="center">CycleP_Time_HHMM</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="center"><strong>1</strong></td>
<td align="center">TOA5</td>
<td align="center">Jane_Green_Creek_CM</td>
<td align="center">CR1000</td>
<td align="center">72020</td>
<td align="center">CR1000.Std.27.04</td>
<td align="center">CPU:CM_2017_New_Cycle_Ver2.CR1</td>
<td align="center">22435</td>
<td align="center">Cycle</td>
<td align="center"></td>
<td align="center"></td>
<td align="center"></td>
<td align="center"></td>
</tr>
<tr class="even">
<td align="center"><strong>2</strong></td>
<td align="center">TIMESTAMP</td>
<td align="center">RECORD</td>
<td align="center">CycleP_RunNum</td>
<td align="center">CycleP_PO4mgL</td>
<td align="center">CycleP_OAQC</td>
<td align="center">CycleP_QC1</td>
<td align="center">CycleP_QC2</td>
<td align="center">CycleP_BattVolt</td>
<td align="center">CycleP_Flush1Avg</td>
<td align="center">CycleP_Last_Smp_Status</td>
<td align="center">CycleP_Date_MMDD</td>
<td align="center">CycleP_Time_HHMM</td>
</tr>
<tr class="odd">
<td align="center"><strong>3</strong></td>
<td align="center">TS</td>
<td align="center">RN</td>
<td align="center"></td>
<td align="center"></td>
<td align="center"></td>
<td align="center"></td>
<td align="center"></td>
<td align="center"></td>
<td align="center"></td>
<td align="center"></td>
<td align="center"></td>
<td align="center"></td>
</tr>
<tr class="even">
<td align="center"><strong>4</strong></td>
<td align="center"></td>
<td align="center"></td>
<td align="center">Smp</td>
<td align="center">Smp</td>
<td align="center">Smp</td>
<td align="center">Smp</td>
<td align="center">Smp</td>
<td align="center">Smp</td>
<td align="center">Smp</td>
<td align="center">Smp</td>
<td align="center">Smp</td>
<td align="center">Smp</td>
</tr>
<tr class="odd">
<td align="center"><strong>7353</strong></td>
<td align="center">2019-10-11 22:00:00</td>
<td align="center">1471</td>
<td align="center">19</td>
<td align="center">0.209</td>
<td align="center">1</td>
<td align="center">111</td>
<td align="center">112.2</td>
<td align="center">12.1</td>
<td align="center">3329</td>
<td align="center">4</td>
<td align="center">10.11</td>
<td align="center">22.04</td>
</tr>
<tr class="even">
<td align="center"><strong>7354</strong></td>
<td align="center">2019-10-12 00:00:00</td>
<td align="center">1472</td>
<td align="center">20</td>
<td align="center">0.212</td>
<td align="center">1</td>
<td align="center">111</td>
<td align="center">112.2</td>
<td align="center">12.1</td>
<td align="center">3329</td>
<td align="center">4</td>
<td align="center">10.12</td>
<td align="center">0.04</td>
</tr>
</tbody>
</table>
