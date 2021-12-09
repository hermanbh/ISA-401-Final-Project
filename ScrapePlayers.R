if(require(pacman)==FALSE) install.packages("pacman")
pacman::p_load(tidyverse, # for dplyr functions
               magrittr, # for two way pipe
               rvest)

# Assign the year number between 1969 and 1998, to loop through those years
years = 1969:1998

# The season ends with a 2 digit number representing the next year
second = 70:99

# Common start of a URL that is used for data scraping
base_url = "https://www.quanthockey.com/nhl/seasons/"

# Initialized Dataframe
players = NULL;

# Loop through each website, with the qualifiers of year and 2 digit number
for (counter in 1:length(years)) {
  fullURL = paste0(base_url, years[counter], '-', second[counter], "-nhl-players-stats.html")
  
  read_html(fullURL) %>%        # Read the html of the site
    html_node("table") %>%      # Find the first table
    html_table(header = T) %>%  # The table includes headers
    data.frame() -> tempTable   # Transfer the data into tempTable
  
  colnames(tempTable) <- tempTable[1, ] # Set the new headers to be the first row of values
  
  tempTable = tempTable[-1, ]   # Remove the first row, so the first row is where the data starts
  
  tempTable$Year = years[counter] # Add the year to the data set
  
  read_html(fullURL) %>%        # Read the html of the site
    html_node("table") %>%      # Find the first table
    html_elements("img") %>%    # Take all of the images
    html_attr("src") %>%        # Take all of their source urls
    str_replace_all("https://cdn77.quanthockey.com/img/country-flags/", "") %>%
    str_replace_all("Flag-16.png", "") %>%    # Clean for country name
    str_replace_all("-", " ") -> Name         # Store in a dataframe
  
  tempTable$Country <- Name     # Add countries as a field 
  
  players = rbind(players, tempTable) # Aggregate the data
}




# Same as previously, but with the 2000-2003 seasons, because the first 0
# in the season end is excluded by default, and there was no 2004 season

years = 2000:2003
second = 01:04

for (counter in 1:length(years)) {
  fullURL = paste0(base_url, years[counter], '-0', second[counter], "-nhl-players-stats.html")
  
  read_html(fullURL) %>% 
    html_node("table") %>% 
    html_table(header = T) %>% 
    data.frame() -> tempTable
  
  colnames(tempTable) <- tempTable[1, ]
  
  tempTable = tempTable[-1, ]
  
  tempTable$Year = years[counter]
  
  read_html(fullURL) %>%        
    html_node("table") %>%      
    html_elements("img") %>%    
    html_attr("src") %>%        
    str_replace_all("https://cdn77.quanthockey.com/img/country-flags/", "") %>%
    str_replace_all("Flag-16.png", "") %>%    
    str_replace_all("-", " ") -> Name         
  
  tempTable$Country <- Name 
  
  players = rbind(players, tempTable)
}





# Same as previously, but with the 2005-2009 seasons, because the first 0
# in the season end is excluded by default


years = 2005:2008
second = 06:09

for (counter in 1:length(years)) {
  fullURL = paste0(base_url, years[counter], '-0', second[counter], "-nhl-players-stats.html")
  
  read_html(fullURL) %>% 
    html_node("table") %>% 
    html_table(header = T) %>% 
    data.frame() -> tempTable
  
  colnames(tempTable) <- tempTable[1, ]
  
  tempTable = tempTable[-1, ]
  
  tempTable$Year = years[counter]
  
  read_html(fullURL) %>%        
    html_node("table") %>%     
    html_elements("img") %>%    
    html_attr("src") %>%        
    str_replace_all("https://cdn77.quanthockey.com/img/country-flags/", "") %>%
    str_replace_all("Flag-16.png", "") %>%   
    str_replace_all("-", " ") -> Name        
  
  tempTable$Country <- Name     
  
  players = rbind(players, tempTable)
}




# Same as previously, but with the 2009-2019 seasons

years = 2009:2019
second = 10:20

for (counter in 1:length(years)) {
  fullURL = paste0(base_url, years[counter], '-', second[counter], "-nhl-players-stats.html")
  
  read_html(fullURL) %>% 
    html_node("table") %>% 
    html_table(header = T) %>% 
    data.frame() -> tempTable
  
  colnames(tempTable) <- tempTable[1, ]
  
  tempTable = tempTable[-1, ]
  
  tempTable$Year = years[counter]
  
  read_html(fullURL) %>%        
    html_node("table") %>%      
    html_elements("img") %>%    
    html_attr("src") %>%        
    str_replace_all("https://cdn77.quanthockey.com/img/country-flags/", "") %>%
    str_replace_all("Flag-16.png", "") %>%    
    str_replace_all("-", " ") -> Name         
  
  tempTable$Country <- Name     
  
  players = rbind(players, tempTable)
}



# Remove the empty row, which used to contain country flags
players = subset(players, select = -c(2))

# Remove rows which do not have data for earlier years
players = subset(players, select = -c(12:15,32:40,46:50))



# Manual data cleaning to work around seemingly random special characters.
# Sometimes the same name would be identified correctly one year, but not the next.
players$Name[371] = "Börje Salming"
players$Name[421] = "Börje Salming"
players$Name[478] = "Václav Nedomanský"
players$Name[538] = "Václav Nedomanský"
players$Name[592] = "Jörgen Pettersson"
players$Name[723] = "Patrik Sundström"
players$Name[786] = "Mats Näslund"
players$Name[808] = "Mats Näslund"
players$Name[873] = "Mats Näslund"
players$Name[909] = "Håkan Loob"
players$Name[971] = "Tomas Sandström"
players$Name[1043] = "Patrik Sundström"
players$Name[1067] = "Patrik Sundström"
players$Name[1155] = "Teemu Selänne"
players$Name[1210] = "Jaromír Jágr"
players$Name[1251] = "Jaromír Jágr"
players$Name[1302] = "Jaromír Jágr"
players$Name[1352] = "Teemu Selänne"
players$Name[1401] = "Jaromír Jágr"
players$Name[1451] = "Jaromír Jágr"
players$Name[1501] = "Jaromír Jágr"
players$Name[1552] = "Markus Näslund"
players$Name[1602] = "Markus Näslund"
players$Name[1654] = "Markus Näslund"
players$Name[1702] = "Jaromír Jágr"
players$Name[1758] = "Jaromír Jágr"
players$Name[1834] = "Václav Prospal"
players$Name[1860] = "Nicklas Bäckström"
players$Name[1904] = "Nicklas Bäckström"
players$Name[1958] = "Teemu Selänne"
players$Name[2033] = "Teemu Selänne"
players$Name[2066] = "Nicklas Bäckström"
players$Name[2111] = "Nicklas Bäckström"
players$Name[2155] = "Jakub Vorácek"
players$Name[2217] = "Nicklas Bäckström"
players$Name[2254] = "Nicklas Bäckström"
players$Name[2315] = "Jakub Vorácek"
players$Name[2386] = "Teuvo Teräväinen"
players$Name[2429] = "Teuvo Teräväinen"

# Import the necessary libraries to write to and Excel file, then write to it
library("writexl")
write_xlsx(players, "Players.xlsx")