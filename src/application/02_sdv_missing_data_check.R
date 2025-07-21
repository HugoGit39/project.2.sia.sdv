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

# EXTRA - get detailed info per user

response_gr_ds <- get_group_data(GROUP_NO)

id_list <- list()

for (i in seq_along(response_gr_ds$data)) {
  id_list[[i]] <- c(
    id = response_gr_ds$data[[i]]$owner$id,
    date = response_gr_ds$data[[i]]$updated_at,
    first_name = response_gr_ds$data[[i]]$owner$first_name,
    last_name = response_gr_ds$data[[i]]$owner$last_name
  )
}

# * 2.0 loop per user over daily date  ----

response <- get_data(1306091)



