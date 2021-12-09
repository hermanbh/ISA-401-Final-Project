if(require(pacman)==FALSE) install.packages("pacman")
pacman::p_load(tidyverse, # for dplyr functions
               magrittr, # for two way pipe
               rvest,
               tibble)

# assign the years used to loop through those years
years = 1970:2004

# start with URL used
base_url = "https://www.hockeydb.com/ihdb/stats/leagues/seasons/nhl1927"

# Initialize data frame
standings = NULL;

# loop through each site with qualifiers for end of season year
for (counter in 1:length(years)) {
  fullURL = paste0(base_url, years[counter], ".html")
  read_html(fullURL) %>% # read site HTML
    html_node("table") %>% # find the first table
    html_table(header = T) %>% # table includes headers
    data.frame -> tempTable # transfer data to temptable
  
  colnames(tempTable) <- tempTable[1, ]   # Set the column names to the first row
  tempTable = tempTable[-1, ]             # Then remove the first row
  
  # We only care about the Team, Games Played, Wins, Losses, and Points, so filter for those
  tempTable = subset(tempTable, select = c("Team", "GP", "W", "L", "Pts"))
  
  tempTable$Year = years[counter] - 1 # add year to data set
  standings = rbind(standings, tempTable) # aggregate the data
}


# Same as previously, but with the 2005-2019 seasons, since 2004 did not happen

years = 2006:2020

for (counter in 1:length(years)) {
  fullURL = paste0(base_url, years[counter], ".html")
  read_html(fullURL) %>% # read site HTML
    html_node("table") %>% # find the first table
    html_table(header = T) %>% # table includes headers
    data.frame -> tempTable # transfer data to temptable
  
  
  colnames(tempTable) <- tempTable[1, ]
  tempTable = tempTable[-1, ]
  tempTable = subset(tempTable, select = c("Team", "GP", "W", "L", "Pts"))
  
  tempTable$Year = years[counter] - 1 # add year to data set
  standings = rbind(standings, tempTable) # aggregate the data
}

# Find where the games played are 0, it is a table break
idx = which(standings$GP == 0)

# Loop through that many times
for (counter in 1:length(idx)) {
  # Remove the next 3 rows from that index to remove break lines
  standings <- standings[-c(idx[1]:(idx[1] + 2)), ]
  idx = which(standings$GP == 0) # Reset the next index to be used
  counter = counter - 1 # Reduce the counter so indexes are not skipped
}

# Import the necessary libraries to write to and Excel file, then write to it
install.packages("writexl")
library("writexl")
write_xlsx(standingsedit, "Standings.xlsx")