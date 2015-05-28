library(RCurl)
rawData <- getURL("http://stats.grok.se/json/en/201410/Friday")
library(RJSONIO)
parsedData <- fromJSON(rawData)

viewsData <- data.frame(Date=names(parsedData$daily_views), # get the names
           Views=parsedData$daily_views) # get the data points

head(viewsData)

# gives us the dates twice - uses dates as row names, 
# so do this to get rid of them:

viewsData <- data.frame(Date=names(parsedData$daily_views), # get the names
           Views=parsedData$daily_views, # get the data points
           row.names=NULL) # stop using the dates as names

head(viewsData)

str(viewsData)

# the dates are factors and in the wrong order. Convert to Date type and sort

library(dplyr)

viewsData$Date<-as.Date(viewsData$Date)

# sort using dplyr - automatically renumbers the row names in ascending order
#viewsData<-arrange(viewsData,Date)
#viewsData

#or sort using R base - row numbers not renamed, and we have to do it manually
# to get them in ascending order again
viewsData<-viewsData[order(viewsData$Date),]
viewsData
row.names(viewsData)<-NULL
viewsData

## Now plot the data
library(ggplot2)
ggplot(data=viewsData,  # Make a plot using our views data
       aes(x=Date,  # with Date on the x-axis
           y=Views,  # and Views on the y-axis
           group=1)) +  # Use all the data as one data series
        geom_line()  # and draw a line of this data