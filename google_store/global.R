
# Libraries
library(shiny)
library(tidyverse)
library(janitor)
library(highcharter)
library(lubridate)
library(leaflet)
library(shinycssloaders)
library(sp)
library(shinymaterial)
library(highcharter)
library(plotly)
library(DT)
library(shiny)
library(googleVis)
library(ggvis)
library(RColorBrewer)
library(shinyjs)
library(nivopie)
library(ggthemes)
devtools::install_github("jienagu/nivopie")
devtools::install_github("jienagu/noteMD")
# webshot::install_phantomjs()


axis_vars <- c(
  "Transaction" = "transactions",
  "Revenue" = "revenue",
  "Hits" = "hits",
  "Page Views" = "pageviews",
  "Time on Site" = "timeOnSite",
  "Month" = "month"
)
