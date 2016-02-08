library(httr)
library(xml2)
library(dplyr)

splunk_server <- "https://splunk.sqor.com:8089"
username <-"sqorrestful"
passwd <- "Sq0rR0cks!"

query <- "search index=nginx host=prod*POST="/favorites/*" earliest=9/7/2015:0:0:0 latest=9/14/2015:0:0:0"

response <- POST(splunk_server,
                 path = "services/search/jobs",
                 config(ssl_verifhost = F, ssl_verifypeer = 0),
                 authenticate(username,passwd),
                 encode = "form",
                 body = list(search = query, output_mode = "csv"),
                 verbose())

stop_for_status(response)
result <- content(response,type = "raw")
result %>% read_xml()

sid <- (result %>% read_xml() %>% as_list()) $ sid
sid