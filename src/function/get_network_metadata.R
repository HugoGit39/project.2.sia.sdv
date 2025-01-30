#############################################################################################################
#
# Retrieve a list of your datasets
#
# If you would like to obtain a list of what datasets are shared with you by your network, you can do a GET 
# request to the /timeline/network_metadata endpoint of the SDV API. This works very similar to retrieving a 
# list of your own data:
#
#
#############################################################################################################

get_network_metadata <- function(page = 1) {
  url <- sprintf('%s%s/timeline/network_metadata?page=%s', BASE_URL, API_PATH, page)
  r <- GET(url, add_headers(Authorization = AUTH_HEADER))
  response_data <- content(r, as='parsed')
  return(response_data)
}