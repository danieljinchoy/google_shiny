library(DT)
library(shiny)
library(shinydashboard)

actionLink <- function(inputId, ...) {
  tags$a(href='javascript:void',
         id=inputId,
         class='action-button',
         ...)
}

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
    ),
  
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
  
  Visits_channel = mainPanel(
    fluidRow(
      column(1, plotlyOutput("channelvisits")),
    )
  ),
  
  Transactions_channel = mainPanel(
    fluidRow(
      column(1, plotlyOutput("channel_transactions")),
    )
  ),
  
  
  # Third page:
  
  
  
  
  # Inbound = fluidRow(
  #   titlePanel("Google Merchandise Store Explorer"),
  #   fluidRow(
  #     column(3,
  #            wellPanel(
  #              h4("Filter"),
  #              sliderInput("pageviews", "Pageviews",
  #                          0, 470, 80, step = 10),
  #              sliderInput("month", "Months", 1, 12, value = c(12),
  #                          sep = ""),
  #              selectInput("channelGrouping", "Channels",
  #                          c("Organic Search", "Affiliates", "Social", "Direct", "Referral", "Paid Search",
  #                            "Display", "(Other)")
  #              )
  #            ),
  #            wellPanel(
  #              selectInput("xvar", "X-axis variable", axis_vars, selected = "Transaction"),
  #              selectInput("yvar", "Y-axis variable", axis_vars, selected = "Revenue"),
  #              tags$small(paste0(
  #                "Note: The Tomato Meter is the proportion of positive reviews",
  #                " (as judged by the Rotten Tomatoes staff), and the Numeric rating is",
  #                " a normalized 1-10 score of those reviews which have star ratings",
  #                " (for example, 3 out of 4 stars)."
  #              ))
  #            )
  #     ),
  #     column(9,
  #            ggvisOutput("plot1"),
  #            wellPanel(
  #              span("Number of movies selected:",
  #                   textOutput("n_movies")
  #              )
  #            )
  #     )
  #   )
  # )
  
  
  
  
  

  
          
          

    
    
)


