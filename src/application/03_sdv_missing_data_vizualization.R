####################################################################################################
#
# R script for Sports Data Valley
#
# vizualize missing data 
#
####################################################################################################

# * 1.0 Flatten filtered_data into a data frame  ----

flat_df <- data.frame(
  user_id = character(),
  first_name = character(),
  last_name = character(),
  dateTime = character(),
  time_series_length = numeric(),
  versioned_data_object_id = numeric(),
  stringsAsFactors = FALSE
)

for (uid in names(filtered_data)) {
  user_records <- filtered_data[[uid]]$records
  for (rec in user_records) {
    flat_df <- rbind(flat_df, data.frame(
      user_id = uid,
      first_name = filtered_data[[uid]]$first_name,
      last_name = filtered_data[[uid]]$last_name,
      dateTime = rec$dateTime,
      time_series_length = rec$time_series_length,
      versioned_data_object_id = rec$versioned_data_object_id,
      stringsAsFactors = FALSE
    ))
  }
}

# * 2.0 create inetractive plotly plot  ----

flat_df$dateTime <- as.Date(flat_df$dateTime)
users <- unique(flat_df$user_id)

# Start empty plot
p <- plot_ly()

for (i in seq_along(users)) {
  u <- users[i]
  user_data <- flat_df[flat_df$user_id == u, ]
  
  # Build hover text vector
  hover_text <- paste0(
    "User: ", user_data$first_name, " ", user_data$last_name,
    "<br>ID: ", u,
    "<br>Date: ", user_data$dateTime,
    "<br>Samples: ", user_data$time_series_length,
    "<br>Dataset ID: ", user_data$versioned_data_object_id
  )
  
  # Add trace for this user
  p <- add_trace(
    p,
    x = user_data$dateTime,
    y = user_data$time_series_length,
    type = 'scatter',
    mode = 'markers',
    name = paste(user_data$first_name[1], user_data$last_name[1]),
    text = hover_text,
    hoverinfo = 'text',
    visible = ifelse(i == 1, TRUE, FALSE)  # Only first user visible initially
  )
}

# Create dropdown buttons
buttons <- list()
for (i in seq_along(users)) {
  vis <- rep(FALSE, length(users))
  vis[i] <- TRUE
  buttons <- append(buttons, list(
    list(method = "restyle",
         args = list("visible", vis),
         label = paste(flat_df$first_name[flat_df$user_id == users[i]][1],
                       flat_df$last_name[flat_df$user_id == users[i]][1],
                       "(ID:", users[i], ")"))
  ))
}

# Add layout with dropdown
p <- layout(
  p,
  title = "Heart Rate Time Series Completeness by User",
  xaxis = list(title = "Date"),
  yaxis = list(title = "Time Series Length"),
  updatemenus = list(
    list(
      y = 0.9,
      buttons = buttons
    )
  )
)

p
