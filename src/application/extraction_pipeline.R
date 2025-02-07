####################################################################################################
#
# R script for Sports Data Valley
#
#  Pipeline to extract data from a singel participant
#
####################################################################################################

# * 1.0 group datasets info SiA = #5937 ---- 

response_gr_ds <- get_group_data(5937)

id_list <- list()

for (i in seq_along(response_gr_ds$data)) {
  id_list[[i]] <- c(
    id = response_gr_ds$data[[i]]$owner$id,
    date = response_gr_ds$data[[i]]$updated_at,
    first_name = response_gr_ds$data[[i]]$owner$first_name,
    last_name = response_gr_ds$data[[i]]$owner$last_name
  )
}

#make a loop inside response_gr_ds$data[[i]]$id to create a list with id''s


response <- get_data(1148746)

response_2 <- get_raw(1148746)



ll <- response$versioned_data_object$structured_data_objects[[1]]$data_rows[[1]]


heart_intra_day <- response$versioned_data_object$structured_data_objects[[1]]$data_rows[[1]]$heart_intra_day

# If you only want to use certain fields (possibly from different levels within the data),
# you can use a for loop as alternative. 
data_table_slow <- data.frame()
for (sample in heart_intra_day) {
  data_table_slow <- rbind(data_table_slow, data.frame(sample$time, sample$value))
}
print(summary(data_table_slow))