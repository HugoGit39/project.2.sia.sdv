####################################################################################################
#
# R script for Sports Data Valley
#
# Pipeline to quantify missing data 
#
####################################################################################################

# * 1.0 library ----

library(tidyverse)

# * 2.0 get user group info ----

response_gr_pr <- get_group_info(GROUP_NO)

profile_list <- list()

for (i in seq_along(response_gr_pr$group_memberships)) {
  profile <- response_gr_pr$group_memberships[[i]]$profile
  profile_list[[as.character(profile$id)]] <- list(
    first_name = profile$first_name,
    last_name = profile$last_name
  )
}

# * 3.0 get all activity data  ----

response_gr_ds <- get_all_group_rec_act(GROUP_NO)

activity_data <- list()

for (i in seq_along(response_gr_ds)) {
  owner <- response_gr_ds[[i]]$owner
  sdo <- response_gr_ds[[i]]$structured_data_objects
  metadatum <- response_gr_ds[[i]]$metadatum
  
  # Default NULLs
  heart_intra_day <- NULL
  dateTime <- NULL
  
  if (length(sdo) > 0 && length(sdo[[1]]$data_rows) > 0) {
    data_row <- sdo[[1]]$data_rows[[1]]
    
    if (!is.null(data_row$heart_intra_day)) {
      heart_intra_day <- data_row$heart_intra_day
    }
    
    if (!is.null(data_row$dateTime)) {
      dateTime <- data_row$dateTime
    }
  }
  
  activity_data[[i]] <- list(
    id = owner$id,
    first_name = owner$first_name,
    last_name = owner$last_name,
    heart_intra_day = heart_intra_day,
    dateTime = dateTime,
    versioned_data_object_id = metadatum$versioned_data_object_id
  )
}

# * 4.0 combine user id & activity data plus filter out heart_intra_day = half day AND/OR = NULL  ----




