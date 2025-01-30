#############################################################################################################
#
# Retrieve a list of datasets from a specific group
#
# Get the datasets that are shared with you via a group. For example, you want to make a report on the competition 
# readiness of your team. For this, the request should be sent to endpoint /groups/\<id>/recent_activity, with the 
# group id specified.
#
#
#############################################################################################################

get_group_data <- function(group_id, page = 1) {
  url <- sprintf('%s%s/groups/%s/recent_activity?page=%s', BASE_URL, API_PATH, group_id, page)
  r <- GET(url, add_headers(Authorization = AUTH_HEADER))
  response_data <- content(r, as='parsed')
  return(response_data)
}