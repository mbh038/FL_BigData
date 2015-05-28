## R SCRIPT:

library(RCurl)
library(RJSONIO)

allViewsData <- NULL # change this line

for (theURL in allURLs) { 
        
        cat("Downloading data from", theURL, "\n") 
        
        rawData <- getURL(theURL)
        parsedData <- fromJSON(rawData)
        viewsData <- data.frame(Date=names(parsedData$daily_views),
                                Views=parsedData$daily_views,
                                row.names=NULL)
        
        allViewsData<-rbind(allViewsData,viewsData)
        #print(viewsData) 
} 

## Sort the data by date
library(dplyr)

allViewsData$Date<-as.Date(allViewsData$Date)
allViewsData<-arrange(allViewsData,Date) # sort by date
allViewsData<-filter(allViewsData,!is.na(Date)) # remove Data = NA lines
str(allViewsData)
head(allViewsData)
tail(allViewsData)

## Plot the data
library(ggplot2)
ggplot(data=allViewsData, aes(x=Date, y=Views, group=1)) + geom_line()

spike<-filter(allViewsData,Views==max(Views))
spike


## END OF SCRIPT