####################################################################################################
#
# R script for Sports Data Valley
#
# Pipeline to quantify missing data 
#
####################################################################################################

# * 1.0 get user group info ----

response_gr_pr <- get_group_info(GROUP_NO)

profile_list <- list()

for (i in seq_along(response_gr_pr$group_memberships)) {
  profile <- response_gr_pr$group_memberships[[i]]$profile
  profile_list[[as.character(profile$id)]] <- list(
    first_name = profile$first_name,
    last_name = profile$last_name
  )
}

# * 2.0 get all activity data  ----

response_gr_ds <- get_all_group_rec_act(GROUP_NO)

activity_data <- list()

for (i in seq_along(response_gr_ds)) {
  data_type <- response_gr_ds[[i]]$data_type$data_type
  
  # Skip if data_type is NULL or equals "fit_data_type"
  if (data_type == "fit_data_type" || "strava_type") {
    next
  }
  
  owner <- response_gr_ds[[i]]$owner
  sdo <- response_gr_ds[[i]]$structured_data_objects
  metadatum <- response_gr_ds[[i]]$metadatum
  
  # Default values
  series_data <- NULL
  dateTime <- NULL
  
  if (length(sdo) > 0 && length(sdo[[1]]$data_rows) > 0) {
    data_row <- sdo[[1]]$data_rows[[1]]
    
    # Fitbit logic
    if (!is.null(data_row$heart_intra_day)) {
      series_data <- data_row$heart_intra_day
    }
    
    # Garmin logic
    if (!is.null(data_row$time_offset_heart_rate_samples)) {
      series_data <- data_row$time_offset_heart_rate_samples
    }
    
    # dateTime is independent:
    if (!is.null(data_row$dateTime)) {
      dateTime <- data_row$dateTime
    }
    if (!is.null(data_row$calendar_date)) {
      dateTime <- data_row$calendar_date
    }
  }
  
  activity_data[[length(activity_data) + 1]] <- list(
    id = owner$id,
    first_name = owner$first_name,
    last_name = owner$last_name,
    data_type = data_type,
    hr_time_series = series_data,
    dateTime = dateTime,
    versioned_data_object_id = metadatum$versioned_data_object_id
  )
}

# * 4.0 combine user id & activity data plus filter out heart_intra_day = half day AND/OR = NULL  ----

filtered_data <- list()

for (i in seq_along(activity_data)) {
  record <- activity_data[[i]]
  
  # Skip if no user ID or no date
  if (is.null(record$id) || is.null(record$dateTime)) next
  
  ts <- record$hr_time_series
  data_type <- record$data_type
  
  # Check conditions
  include <- FALSE
  if (is.null(ts)) {
    include <- TRUE
  } else {
    ts_length <- length(ts)
    
    if (data_type == "fitbit_type" && ts_length <= (60 * 24) / 2) {
      include <- TRUE
    }
    if (data_type == "garmin_type" && ts_length <= (4 * 60 * 24) / 2) {
      include <- TRUE
    }
  }
  
  # If record meets conditions, add it under the user ID
  if (include) {
    user_id <- as.character(record$id)
    
    if (!user_id %in% names(filtered_data)) {
      filtered_data[[user_id]] <- list(
        first_name = profile_list[[user_id]]$first_name,
        last_name = profile_list[[user_id]]$last_name,
        records = list()
      )
    }
    
    filtered_data[[user_id]]$records[[length(filtered_data[[user_id]]$records) + 1]] <- list(
      dateTime = record$dateTime,
      time_series_length = ifelse(is.null(ts), 0, length(ts)),
      versioned_data_object_id = record$versioned_data_object_id
    )
  }
}

