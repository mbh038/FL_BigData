library(dplyr)

# get the Google Trends data and calculate the FOIs

allFileNames<-list.files("Trends")
allFOIs<-NULL

for(fileName in allFileNames){

        #fullFileName<-"./Trends/AR.csv"

        fullFileName<-paste0("./Trends/",fileName)
        trendsData<-read.csv(fullFileName,skip=4,nrows=476-5,stringsAsFactors=FALSE )

        #head(trendsData)
        #tail(trendsData)
        #str(trendsData)
        
        # extract year from Week column and store as numeric
        
        trendsData$year <- substring(trendsData$Week, first=1, last=4)
        trendsData$year <- as.numeric(trendsData$year)
        
        # summary(trendsData)
        
        # create 2012 subset
        
        trendsData2012<-filter(trendsData,year==2012)
        
        foi<-sum(trendsData2012$X2013) / sum(trendsData2012$X2011)
        
        country<-substring(fileName,first=1,last=2)
        
        
        foirow<-data.frame(Country=country,FOI=foi)
                
        allFOIs<-rbind(allFOIs,foirow)
}

allFOIs #ddd

# gwt GDPS

gdpPerCap <- read.csv("rawdata_2004.txt",
                      sep="\t",    # columns are separated with tabs
                      header=F,    # no column names are given,
                      row.names=1, # row names (numbers) are in the 1st column.
                      stringsAsFactors=FALSE) 
head(gdpPerCap)

# tidy the gdp data
names(gdpPerCap)<-c("Country","GDP_PC")
head(gdpPerCap)
str(gdpPerCap)

# remove the $s from the GDP column

gdpPerCap$GDP_PC<-gsub("\\$","",gdpPerCap$GDP_PC)
#gdpPerCap$GDP_PC <- substring(gdpPerCap$GDP_PC, first=2) # does the same thing
gdpPerCap$GDP_PC<-gsub(",","",gdpPerCap$GDP_PC)

# combine GDP and FOI data.

gdpPerCap$GDP_PC<-as.numeric(gdpPerCap$GDP_PC)
head(gdpPerCap)

# replace country names with codes
library(countrycode)

gdpPerCap$Country <- countrycode(gdpPerCap$Country,  # change this data
                                 origin="country.name",  # from a name
                                 destination="iso2c")    # to a 2-char code

# merge FOI and GDP data

foiGDP <- merge(allFOIs, gdpPerCap)

head(foiGDP)

# plot GDP vs FOI

library(ggplot2)

ggplot(data=foiGDP, aes(x=FOI ,y=GDP_PC)) + geom_point() 
        
# check for correlation
cor.test(foiGDP$FOI, foiGDP$GDP_PC)
             # Plot each of the points