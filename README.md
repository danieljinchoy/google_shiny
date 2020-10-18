# Shiny Project on Google Merchandise Store


Google Analytics Team has shared an open dataset on Google Merchandise Store through BigQuery. The variables in the data is what you can find in a typical ecommerce website. Basd on the data, I created a scenario where Google Merchandise Store team wants to expand its online store in terms of transaction number and revenue through brand merchandising.

In the project folder, you can find the following:

- Python Jupitor notebook on querying data. Because R cant communicate with BigQuery, I had to use the python kernel to query the data. Most of the data can be found inside the folder. Due to github's size limit, some dataset are not included. 
- Inisde google_store folder, you can find my r codes (server.R, us.R, global.R, and project.R). project.R has all the data importing, data cleaning, and data visualization. 
- Inside google_store/www, you can find my index.html file, css and js files under css folder and js folder. The skeleton of the html file was desgined by Glint. I mostly modified to make it work with R Shiny. 
- Data from 2016.08.01 to 2017.07.31 is only available at the moment.


## Problem Statement ##

Google Marketing Team is planning to expand its online merchandise store as part of its [Brand Merchandising] project. Prior to expansion, the team wants to understand how its online store is functioning by analyzing consumer's experience with the website by looking into the website's traffic data and how well Google Merchandise store in terms of transaction number andr revenue. 

## Findings ##

### Summary 