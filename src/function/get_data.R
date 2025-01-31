#############################################################################################################
#
# Retrieve a list of datasets from a specific group
#
# The previous examples showed how to get a list of data, but sometimes you may need only one dataset. And maybe 
# you want to download the original raw file, instead of all the metadata from the platform. This is all possible: 
# The /data/<id> endpoint will return all the information on that specific dataset, and /data/<id>/download will 
# return the raw file.
#
# Function get_data(<id>) either gives you the response from /data/<id> or uses function get_raw(<id>), based on a 
# couple of assumptions:
#  
# If the original file was a CSV, you want to load the contents as a table (pandas dataframe).
# If not, but it does contain a summary or a structured data object, you want data representation used by SDV.
# If that is neither the case, your data is most likely of a type that you need to process with custom code, so 
# save the original file to JupyterLab.
#
#
#############################################################################################################

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