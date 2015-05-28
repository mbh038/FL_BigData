library(dplyr)

# get the data

trendsData<-read.csv("report.csv",skip=4,nrows=595,stringsAsFactors=FALSE )

# look at it

head(trendsData)
tail(trendsData)
str(trendsData)

# extract year from Week column and store as numeric

trendsData$year <- substring(trendsData$Week, first=1, last=4)
trendsData$year <- as.numeric(trendsData$year)

summary(trendsData)

# create 2012 subset

AllFOIs<-NULL
for(thisyear in min(trendsData$year)+1:max(trendsData$year)-1){
        
        trendsDatathisyear<-filter(trendsData,year==thisyear)
        XNextYear<-paste("X",thisyear+1)
        XLastYear<-paste("X",thisyear-1)
        FOI<-sum(trendsDatathisyear$XNextYear) / sum(trendsDatathisyear$XLastYear)
        
        AllFOIs<-c(AllFOIs,FOI)
}

AllFOIs


# calculate FOI for 2012


FOI2012