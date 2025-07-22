#############################################################################################################
#
# Retrieve a datasets from a specific user (versioned_data_object_id)
#
#############################################################################################################

# Retrieve the raw data from a dataset in the platfor I
get_data <- function(data_id) {
  response <- GET(sprintf('%s%s/data/%s', BASE_URL, API_PATH, data_id),
                  add_headers(Authorization = AUTH_HEADER))
  response_data <- content(response, as='parsed')
  
  # First check if the dataset contains a csv file. If this is the case, obtain it and parse it as a table.
  if (response_data$versioned_data_object$content_type == 'text/csv') {
    download_response_data <- content(get_raw(data_id),
                                      as = 'text',
                                      encoding = "UTF-8")
    data_out <- data.table::fread(text = download_response_data)
    
    # If not, check if SDV has generated a summary or structured data object from the raw data.
    # In this case, do not get the raw data, but return the initial response.
  } else if ((length(response_data$versioned_data_object$summary) > 0) ||
             (length(response_data$versioned_data_object$structured_data_objects) > 0)) {
    data_out <- response_data
    
    # If none of the above, the dataset only has been stored raw in the platform.
    # Save this raw dataset to the Jupyter environment.
  } else {
    download_response_data <- content(get_raw(data_id), as = 'raw')
    writeBin(download_response_data, response_data$versioned_data_object$filename)
    data_out <- response_data$versioned_data_object$filename
  }
  return(data_out)
}

# Retrieve the raw data from a dataset in the platfor II
get_raw <- function(data_id) {
  response1 <- GET(sprintf('%s%s/data/%s/download', BASE_URL, API_PATH, data_id),
                   add_headers(Authorization = AUTH_HEADER),
                   config(followlocation = 0L))
  response2 <- GET(headers(response1)$Location)
  return(response2)
}