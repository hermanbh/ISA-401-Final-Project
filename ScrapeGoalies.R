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
  fullURL = paste0(base_url, years[counter], '-', second[counter], "-nhl-goalies-stats.html")

  read_html(fullURL) %>%        # Read the html of the site
    html_node("table") %>%      # Find the first table
    html_table(header = T) %>%  # The table includes headers
    data.frame() -> tempTable   # Transfer the data into tempTable
  
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
  fullURL = paste0(base_url, years[counter], '-0', second[counter], "-nhl-goalies-stats.html")
  
  read_html(fullURL) %>% 
    html_node("table") %>% 
    html_table(header = T) %>% 
    data.frame() -> tempTable
  
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
  fullURL = paste0(base_url, years[counter], '-0', second[counter], "-nhl-goalies-stats.html")
  
  read_html(fullURL) %>% 
    html_node("table") %>% 
    html_table(header = T) %>% 
    data.frame() -> tempTable
  
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
  fullURL = paste0(base_url, years[counter], '-', second[counter], "-nhl-goalies-stats.html")
  
  read_html(fullURL) %>% 
    html_node("table") %>% 
    html_table(header = T) %>% 
    data.frame() -> tempTable
  
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
players = subset(players, select = -c(Var.2))



# Manual data cleaning to work around seemingly random special characters.
# Sometimes the same name would be identified correctly one year, but not the next.
players$Name[405] = "Hardy Åström"
players$Name[472] = "Hardy Åström"
players$Name[516] = "Jirí Crha"
players$Name[1132] = "Tommy Söderström"
players$Name[1191] = "Tommy Söderström"
players$Name[1236] = "Tommy Söderström"
players$Name[1274] = "Tommy Söderström"
players$Name[1350] = "Olaf Kölzig"
players$Name[1370] = "Olaf Kölzig"
players$Name[1419] = "Olaf Kölzig"
players$Name[1464] = "Olaf Kölzig"
players$Name[1513] = "Olaf Kölzig"
players$Name[1565] = "Olaf Kölzig"
players$Name[1615] = "José Théodore"
players$Name[1672] = "Olaf Kölzig"
players$Name[1732] = "Olaf Kölzig"
players$Name[1775] = "Niklas Bäckström"
players$Name[1813] = "Niklas Bäckström"
players$Name[1874] = "Niklas Bäckström"
players$Name[1934] = "Niklas Bäckström"
players$Name[1982] = "José Théodore"
players$Name[2016] = "Niklas Bäckström"
players$Name[2085] = "Eddie Läck"
players$Name[2140] = "Eddie Läck"
players$Name[2192] = "Karri Rämö"
players$Name[2257] = "Jacob Markström"
players$Name[2271] = "Jacob Markström"
players$Name[2317] = "Jacob Markström"
players$Name[2375] = "Jacob Markström"
  
# Import the necessary libraries to write to and Excel file, then write to it
library("writexl")
write_xlsx(players, "Goalies.xlsx")