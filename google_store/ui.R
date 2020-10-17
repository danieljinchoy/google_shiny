library(DT)
library(shiny)
library(shinydashboard)

ui = shiny::htmlTemplate(
  # Index Page
  "www/index.html",
  
  # Introduction Page ---------
  
  # Number of transactions
  number_of_transactions = textOutput(
    "num_transaction",
    inline = T
  ),
  
  # total revenue in dollars
  revenue_dollars = textOutput(
    "total_revenue_dollars",
    inline = T
  ),
  
  # Number of visits
  number_of_visits = textOutput(
    "number_of_visits",
    inline = T
  ),

  
  

  

  # First page: Google Store Transaction and Revenue by date ---------
 
  Transaction_date = mainPanel(
        fluidRow(
          column(1, plotlyOutput("transaction")),
        )
    ),
  Revenue_date = mainPanel(
        fluidRow(
          column(1, plotlyOutput("revenue"))
      )
    )
          
          

    
    
)


