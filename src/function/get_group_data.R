#############################################################################################################
#
# Retrieve specific group info
#
#############################################################################################################

# Retrieve a list of user info I
get_group_info <- function(group_id) {
  url <- sprintf('%s%s/groups/%s', BASE_URL, API_PATH, group_id)
  r <- GET(url, add_headers(Authorization = AUTH_HEADER))
  response_data <- content(r, as = 'parsed')
  return(response_data)
}

# Retrieve a list of user info II
get_group_overview <- function(group_id) {
  url <- sprintf('%s%s/groups/%s/overview', BASE_URL, API_PATH, group_id)
  r <- GET(url, add_headers(Authorization = AUTH_HEADER))
  response_data <- content(r, as = 'parsed')
  return(response_data)
}

# Retrieve a list of datasets from a specific group for 1 page
get_group_rec_act <- function(group_id, page = 1) {
  url <- sprintf('%s%s/groups/%s/recent_activity?page=%s', BASE_URL, API_PATH, group_id, page)
  r <- GET(url, add_headers(Authorization = AUTH_HEADER))
  response_data <- content(r, as='parsed')
  return(response_data)
}

# Retrieve a list of datasets from a specific group for all pages
get_all_group_rec_act <- function(group_id) {
  page <- 1
  all_data <- list()
  
  repeat {
    url <- sprintf('%s%s/groups/%s/recent_activity?page=%s', BASE_URL, API_PATH, group_id, page)
    r <- GET(url, add_headers(Authorization = AUTH_HEADER))
    response_data <- content(r, as='parsed')
    
    if (length(response_data$data) == 0) {
      break  # No more data
    }
    
    all_data <- c(all_data, response_data$data)
    page <- page + 1
  }
  
  return(all_data)
}


