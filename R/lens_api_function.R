# This script contains the helper function for calling Lens API
library(httr)
library(tidyverse)
library(rjson)

# Calls the Lens aggregration API 
# Takes in the query string used in the Lens and aggregations_option filters (oa_color_agg, oa_colour_over_time) and returns contents of the API request as a list 
# aggregration filters can ve for OA status, OA colours or license types
aggregration_query <- function(query_string, aggregations_option, token, show_query_string = FALSE){
  url <- 'https://api-dev.api.lens.org/scholarly/aggregate'
  # license type aggregration (return single number rather than over time)
  if (aggregations_option == "license_agg") {
    aggregations_string <- '{"pubtype": {"terms": {"field": "open_access.license", "size": 30}}}'
  }
  # OA status aggregration (return single number rather than over time) - this is also used to get total pub count
  else if (aggregations_option == "oa_status_agg") {
    aggregations_string <- '{"open_access_status": {"filters": {"filters": {"open_access": {"term": {"is_open_access": "true"}},"non-oa": {"term": {"is_open_access": "false"}}}}}}'
  }
  # OA colour aggregration (return single number rather than over time)
  else if (aggregations_option == "oa_color_agg") {
    aggregations_string <-  '{"pubtype": {"terms": {"field": "open_access.colour", "size": 10}}}'
  }
  # OA colours over time
  else if (aggregations_option == "oa_color_over_time") {
    aggregations_string <- '{"date_histo": {"date_histogram": {"field": "date_published","interval": "YEAR","aggregations": {"oa-colour": {"terms": {"field": "open_access.colour","size": 20}}}}}}'
  }
  # OA status over time
  else if (aggregations_option == "oa_status_over_time") {
    aggregations_string <- '{"date_histo": {"date_histogram": {"field": "date_published","interval": "YEAR","aggregations": {"open_access_status": {"filters": {"filters": {"open_access": {"term": {"is_open_access": "true"}},"non-oa": {"term": {"is_open_access": "false"}}}}}}}}}'
  }
  # OA status aggregration for top 20 journals (return single number rather than over time)
  else if (aggregations_option == "journal_oa_status_agg") {
    aggregations_string <- '{"journal": {"terms": {"field": "source.title.exact","size": 20,"aggregations": {"open_access_status": {"filters": {"filters": {"open_access": {"term": {"is_open_access": "true"}},"non-oa": {"term": {"is_open_access": "false"}}}}}}}}}'
  }
  else {
    print("Wrong aggregations_option! Please use one of the following:license_agg, oa_status_agg, oa_color_agg, oa_color_over_time, oa_status_over_time")
  }
  
  # We want to also have the option of showing the prompt if needed
  if (show_query_string == TRUE){
    print(query_string)
  }
  
  request <- paste0('{"query": "', gsub('"', '\\\\"',query_string),'","aggregations":',aggregations_string,',"size": 0}')
  response <- httr::POST(url = url, add_headers(.headers=c('Authorization' = token, 'Content-Type' = 'application/json')), body = request)
  # Sleep for 14 seconds to avoid overloading the server
  Sys.sleep(14)
  return(fromJSON(content(response, as="text")))
}