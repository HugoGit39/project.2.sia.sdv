####################################################################################################
#
# R script for Sports Data Valley
#
# Pipeline to analyse user's data
#
####################################################################################################

# * 1.0 library ----

library(ggplot2)
library(plotly)

response <- get_data(1306091)

#check all elements of VDO
names(meta$versioned_data_object$structured_data_objects[[1]]$data_rows[[1]])


ll <- response$versioned_data_object$structured_data_objects[[1]]$data_rows[[1]]


heart_intra_day <- response$versioned_data_object$structured_data_objects[[1]]$data_rows[[1]]$heart_intra_day


# The resulting array has for each entry the same two values. This makes it very fast and easy to transform:
data_table_fast <- as.data.frame(data.table::rbindlist(heart_intra_day))
print(summary(data_table_fast))

# If you only want to use certain fields (possibly from different levels within the data),
# you can use a for loop as alternative. 
data_table_slow <- data.frame()
for (sample in heart_intra_day) {
  data_table_slow <- rbind(data_table_slow, data.frame(sample$time, sample$value))
}
print(summary(data_table_slow))

# Plot as a line graph
# Create interactive time series plot
fig <- plot_ly(data_table_fast, x = ~time, y = ~value, 
               type = 'scatter',
               mode = 'lines',
               text = ~paste("Value:", value),
               hoverinfo = 'text+y'
) %>%
  layout(
    title = "Heart Intra Day Time Series",
    xaxis = list(title = "Time"),
    yaxis = list(title = "Value")
  )

fig
