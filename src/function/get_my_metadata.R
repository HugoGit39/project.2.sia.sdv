#############################################################################################################
#
# Retrieve a list of your datasets
#
# The following cell defines a function get_my_metadata(), it retrieves a list with couple of recent datasets for you. 
# By specifying a page number between the brackets, you can go back in time. The function returns a structure containing 
# an id and datetimes of when the activity happened and when it was created, details about the sport and owner and information 
#about how it was processed within the platform.
#
#
#############################################################################################################

get_my_metadata <- function(page = 1) {
  url <- sprintf('%s%s/timeline/my_metadata?page=%s', BASE_URL, API_PATH, page)
  r <- GET(url, add_headers(Authorization = AUTH_HEADER))
  response_data <- content(r, as='parsed')
  return(response_data)
}