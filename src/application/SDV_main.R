####################################################################################################
#
# R script for Sports Data Valley]
#
# Getting started: https://jupyterhub.app.sportdatavalley.nl/user/3044/lab/tree/examples/R%20-%20Getting%20started.ipynb
#
# API Endpoints: https://app.sportdatavalley.nl/developer/api-docs/index.html
#
#
####################################################################################################

# * 1.0 library ----

library('httr')
library('ggplot2')
library('lubridate')
library('rjson')
library('here')

# * 2.0 info ----

BASE_URL <- 'https://app.sportdatavalley.nl'
API_PATH <- '/api/v1'
AUTH_HEADER <- 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzMDQxIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNzM3NjM4Mzg5LCJleHAiOjE3NDAyMzAzODksImp0aSI6IjE0ZWZhMjVlLWQ3YWMtNDFhNS05MjgxLWI5NTM5NmEwY2YwOSJ9.P_TQPwZQe9OojeFjiUbUnbGIYocca1JM9fmWgG1jnYk'

# * 3.0 functions ----

# * 3.1 Retrieve a list of your datasets ----

# load get_my_metadata function
source(here('get_my_metadata.R'))

# * 3.2 Retrieve a list of your network data ----

# load get_my_metadata function
source(here('get_network_metadata.R'))

# * 3.3 Retrieve a list of datasets from a specific group

source(here('get_group_data.R'))


