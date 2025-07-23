[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)

<p align="center">
  <img src="[[https://info.sportdatavalley.nl/wp-content/uploads/SDV_logo-1.png](https://raw.githubusercontent.com/HugoGit39/project.2.sia.sdv/refs/heads/main/www/SiAxSDV.png)](https://raw.githubusercontent.com/HugoGit39/project.2.sia.sdv/refs/heads/main/www/SiAxSDV.png)" >
</p>

## About
<p align="justify"> This repository contains R scripts for connecting to the <strong>Sports Data Valley (SDV) API</strong> to retrieve wearable data from users (Fitbit, Garmin) in research groups, quantify <strong>missing or incomplete heart rate time series</strong>, and provide interactive visualization tools for researchers. </p> <p align="justify"> The pipeline is part of the <em>Stress in Action</em> consortium (Research Theme 2), which focuses on reliable real-time measurement of daily life stress and its impact on health using wearable technology. 
  
## How to Use This Repository
<strong>Step 1: Setup and Authentication</strong>
<p align="justify"> Create a <code>.Renviron</code> file with your API credentials and group ID: </p>

```r
BASE_URL=https://app.sportdatavalley.nl
API_PATH=/api/v1
AUTH_HEADER=Bearer your-token
GROUP_NO=your-group-id
```

<p align="justify"> Install required R packages: </p>

```r
install.packages(c("httr", "lubridate", "rjson", "here", "tidyverse", "plotly", "data.table"))
```

<strong>Step 2: Retrieve Group Information</strong>
<p align="justify"> Use the provided function <code>get_group_info()</code> to list all members in your SDV group. This step creates a <code>profile_list</code> object with user IDs and names. </p>
<strong>Step 3: Download Activity Data</strong>
<p align="justify"> Fetch all activity data for your group using the <code>get_all_group_rec_act()</code> function. This retrieves recent VDOs (Versioned Data Objects) and parses structured data for: </p> <ul> <li>User ID and name</li> <li>Data type (<em>Fitbit</em> or <em>Garmin</em>)</li> <li>Date of measurement (<code>dateTime</code> or <code>calendar_date</code>)</li> <li>Heart rate time series (<code>heart_intra_day</code> for Fitbit or <code>time_offset_heart_rate_samples</code> for Garmin)</li> <li>Versioned Data Object ID</li> </ul>
<strong>Step 4: Identify Missing or Incomplete Data</strong>
<p align="justify"> The script checks whether: </p> <ul> <li>The time series is <code>NULL</code></li> <li>The length of the series is less than 50% of expected values: <ul> <li>Fitbit: <code>(60 × 24) / 2</code> samples</li> <li>Garmin: <code>(4 × 60 × 24) / 2</code> samples</li> </ul> </li> </ul> <p align="justify"> Filtered data is saved in <code>filtered_data</code>, grouped by user ID and including: </p> <ul> <li><strong>User Info:</strong> first name, last name</li> <li><strong>Record Details:</strong> date, time series length, dataset ID</li> </ul>
<strong>Step 5: Visualize Missing Data</strong>
<p align="justify"> The <code>visualize_missing_data.R</code> script creates an interactive <strong>Plotly scatter plot</strong>: </p> <ul> <li>X-axis: Date of measurement</li> <li>Y-axis: Time series length</li> <li>Dropdown menu: Select a user to filter the view</li> <li>Hover details: User name, ID, date, samples, dataset ID</li> </ul>
<strong>Step 6: Analyze Individual Datasets</strong>
<p align="justify"> Use <code>get_data()</code> to retrieve and explore specific VDOs: </p> <ul> <li>Extract heart rate time series</li> <li>Convert to a tidy data frame</li> <li>Generate an interactive line plot of heart rate values over time using Plotly</li> </ul>
Example Visualization
<p align="justify"> An example output is an interactive scatter plot where each point represents a daily record for a user. Researchers can quickly identify: </p> <ul> <li>Days with missing time series (0 samples)</li> <li>Days with incomplete coverage</li> </ul>
(Add screenshot here after running the pipeline)

API Documentation and Resources
<ul> <li><a href="https://app.sportdatavalley.nl/developer/api-docs/index.html" target="_blank">Sports Data Valley API Docs</a></li> <li><a href="https://stress-in-action.nl" target="_blank">Stress in Action Project</a></li> </ul>
