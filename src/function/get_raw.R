#############################################################################################################
#
# Retrieve a list of datasets from a specific group
#
# The previous examples showed how to get a list of data, but sometimes you may need only one dataset. And maybe 
# you want to download the original raw file, instead of all the metadata from the platform. This is all possible: 
# The /data/<id> endpoint will return all the information on that specific dataset, and /data/<id>/download will 
# return the raw file.
#
# Function get_raw(<id>) makes a request to the /data/<id>/download endpoint and returns the response. The automatic 
# redirect does not work properly in R, so it follows the location manually.
#
#
#############################################################################################################

# Retrieve the raw data from a dataset in the platform.
get_raw <- function(data_id) {
  response1 <- GET(sprintf('%s%s/data/%s/download', BASE_URL, API_PATH, data_id),
                   add_headers(Authorization = AUTH_HEADER),
                   config(followlocation = 0L))
  response2 <- GET(headers(response1)$Location)
  return(response_2)
}
