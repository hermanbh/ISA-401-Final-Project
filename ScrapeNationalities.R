if(require(pacman)==FALSE) install.packages("pacman")
pacman::p_load(tidyverse, # for dplyr functions
               magrittr, # for two way pipe
               rvest)

# Assign the year number between 1969 and 1998, to loop through those years
years = 1969:1998

# The season ends with a 2 digit number representing the next year
second = 70:99

# Common start of a URL that is used for data scraping
base_url = "https://www.quanthockey.com/nhl/nationality-totals/nhl-players-"

# Initialized Dataframe
players = NULL;

# Loop through each website, with the qualifiers of year and 2 digit number
for (counter in 1:length(years)) {
  fullURL = paste0(base_url, years[counter], '-', second[counter], "-stats.html")
  
  read_html(fullURL) %>%        # Read the html of the site
    html_node("table") %>%      # Find the first table
    html_table(header = T) %>%  # The table includes headers
    data.frame() -> tempTable   # Transfer the data into tempTable
  
  tempTable$Year = years[counter] # Add the year to the data set
  
  players = rbind(players, tempTable) # Aggregate the data
}




# Same as the loop, but with the 1999-2000 season, due to 2 digit limitation

fullURL = paste0(base_url, 1999, "-00-stats.html")

read_html(fullURL) %>% 
  html_node("table") %>% 
  html_table(header = T) %>% 
  data.frame() -> tempTable

tempTable$Year = 1999

players = rbind(players, tempTable)





# Same as previously, but with the 2000-2003 seasons, because the first 0
# in the season end is excluded by default, and there was no 2004 season

years = 2000:2003
second = 01:04

for (counter in 1:length(years)) {
  fullURL = paste0(base_url, years[counter], '-0', second[counter], "-stats.html")
  
  read_html(fullURL) %>% 
    html_node("table") %>% 
    html_table(header = T) %>% 
    data.frame() -> tempTable
  
  tempTable$Year = years[counter]
  
  players = rbind(players, tempTable)
}





# Same as previously, but with the 2005-2009 seasons, because the first 0
# in the season end is excluded by default


years = 2005:2008
second = 06:09

for (counter in 1:length(years)) {
  fullURL = paste0(base_url, years[counter], '-0', second[counter], "-stats.html")
  
  read_html(fullURL) %>% 
    html_node("table") %>% 
    html_table(header = T) %>% 
    data.frame() -> tempTable
  
  tempTable$Year = years[counter]
  
  players = rbind(players, tempTable)
}




# Same as previously, but with the 2009-2019 seasons

years = 2009:2019
second = 10:20

for (counter in 1:length(years)) {
  fullURL = paste0(base_url, years[counter], '-', second[counter], "-stats.html")
  
  read_html(fullURL) %>% 
    html_node("table") %>% 
    html_table(header = T) %>% 
    data.frame() -> tempTable
  
  tempTable$Year = years[counter]
  
  players = rbind(players, tempTable)
}




# Remove the empty row, which used to contain country flags
players = subset(players, select = -c(Var.2))

# Import the necessary libraries to write to and Excel file, then write to it
library("writexl")
write_xlsx(players, "NationalityCounts.xlsx")