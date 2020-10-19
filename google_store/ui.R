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
  
  # Revenue_date = mainPanel(
  #       fluidRow(
  #         column(1, plotlyOutput("revenue"))
  #     )
  #   ),
  # 
  # Second page:
  
  Transaction_country= mainPanel(
        fluidRow(
           column(1, plotlyOutput("transaction_country")),
      )
  ),
  
  Revenue_country= mainPanel(
    fluidRow(
      column(1, plotlyOutput("revenue_country")),
    )
  ),
  
  
  
  # Third page: 
  select_data = fluidRow(
    titlePanel('M'),
    sidebarLayout(
      sidebarPanel(
        selectizeInput(inputId = 'month_char',
                       label = 'month',
                       choices = unique(google[, 'month_char']))
      
    ),
    mainPanel(
      fluidRow(
        column(6, plotlyOutput("views"))
      )
    )
    )
  ),
  
  # Visits_channel = mainPanel(
  #   fluidRow(
  #     column(1, plotlyOutput("channelvisits")),
  #   )
  # ),
  # 
  # Transactions_channel = mainPanel(
  #   fluidRow(
  #     column(1, plotlyOutput("channel_transactions")),
  #   )
  # ),
  
  

  # 
  # Month_selection = fluidRow(
  #   sidebarPanel(
  #      selectizeInput(inputId = "month_char",
  #                     label = "Month",
  #                     choices = unique(google[, 'month_char']))
  #     )
  #   
  # ),
  
  
  # Page 4:
  
  Views_output1 = fluidRow(
    titlePanel("Traffic Data"),
    column(1, plotlyOutput("views"))
  ),
  
  
  Views_output2 = fluidRow(
    column(1, plotlyOutput("time_on_site"))
  ),
  
  # Page 5:
  
  traffic_output1 = fluidRow(
    titlePanel('Hits vs Revenue (under $1000)'),
    plotlyOutput('plot1')
  ),
  
  
  traffic_output2 = fluidRow(
    titlePanel('Page Views vs Revenue'),
    plotlyOutput('plot2')
  ),
  
  
  
  # Page 6:
  
  traffic_output3 = fluidRow(
    titlePanel('Channels vs Visits'),
    plotlyOutput('plot3')
  ),
  
  traffic_output4 = fluidRow(
    titlePanel('Channels vs AVG Hits'),
    plotlyOutput('plot3')
  ),
  
  traffic_output5 = fluidRow(
    titlePanel('Device vs Visits'),
    plotlyOutput('plot3')
  ),
  
  traffic_output6 = fluidRow(
    titlePanel('Device vs AVG Hits'),
    plotlyOutput('plot3')
  )
  

)


