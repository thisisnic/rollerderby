# load the relevant library
library(XML)

# choose the relevant URL
derbyURL="http://www.britishchamps.com/tables/"

# get the content
webPage=htmlTreeParse(derbyURL,useInternal=TRUE)

# get the tiers! they are all denoted by h5 tags
tiers=xpathSApply(webPage,"//h5",xmlValue)

# get out the table headings
tableNames=xpathSApply(webPage,"//table[@class='leagueengine_season_table']/tr/th",xmlValue)[1:9]

# splits data into a data frame and delete the blank second column
longList=xpathApply(webPage,"//table/tr/td",xmlValue)
bigTable=data.frame(matrix(unlist(longList), nrow=72, byrow=T))[,-2]
names(bigTable)=tableNames
bigTable$tier=NA

# associate the name of the tier with the 
tierNum=0
for(i in 1:nrow(bigTable)){
  if(bigTable$'#'[i]==1){
    tierNum=tierNum+1;
  }
  bigTable$tier[i]=tiers[tierNum]
}

# change the factor into a numeric so we can analyse it!
bigTable$F=as.numeric(as.character(bigTable$F))

# Let's take a look at our table of leagues, ready for analysis
bigTable
