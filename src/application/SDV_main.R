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
library('lubridate')
library('rjson')
library('here')

# * 2.0 info ----

BASE_URL <- Sys.getenv("BASE_URL")
API_PATH <- Sys.getenv("API_PATH")
AUTH_HEADER <- Sys.getenv("AUTH_HEADER")

# * 3.0 functions ----

# * 3.1 Retrieve a list of your datasets ----

# load get_my_metadata function
source(here('get_my_metadata.R'))

# * 3.2 Retrieve a list of your network data ----

# load get_my_metadata function
source(here('get_network_metadata.R'))

# * 3.3 Retrieve a list of datasets from a specific group

source(here('get_group_data.R'))


