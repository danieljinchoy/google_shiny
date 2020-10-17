


server = function(input, output) {
  
  # Basic Numbers Page --------------------------------------------------------------

  
  # Transaction Text ---
  n_transaction = reactive({
    google_transaction %>% 
      pull(total_transaction)
  })
  
  # Number of transactions in UI
  output$num_transaction = renderText({
    n_transaction() %>% 
      sum(na.rm = T)
  })
  
  # Revenue Text ---
  n_revenue = reactive({
    google_revenue %>% 
      pull(total_revenue)
  })
  
  # Number of Revenue in Dollars in UI
  output$total_revenue_dollars = renderText({
    google_revenue %>% 
      pull(total_revenue) %>% 
      sum(na.rm = T)
  })
  
  
  # Number of Visits ---
  
  n_visits = reactive({
    google_visit_date %>% 
      pull(total_visits) 
  })
  
  # Number of hours in UI
  output$number_of_visits = renderText({
    n_visits() %>% 
      sum()
  })

  
  
  
  # First Page -------------
  
  
  output$transaction <- renderPlotly(
    google_transaction %>%
      ggplot(aes(x = month_char, y = total_transaction)) +
      geom_col(aes(fill = as.factor(year)), position = "dodge") +
      ggtitle("Total Transaction by Month") +
      theme_bw() +
      xlab('Months') +
      ylab('Total Transaction') +
      scale_fill_brewer(palette = 'YlGn', name = '')
    
    )
  
  output$revenue <- renderPlotly(
    google_revenue %>%
      ggplot(aes(x = month_char, y = total_revenue)) +
      geom_col(aes(fill = as.factor(year)), position = "dodge") +
      ggtitle("Total Transaction by Month") +
      theme_bw() +
      xlab('Months') +
      ylab('Total Revenue') +
      scale_fill_brewer(palette = 'YlGn', name = 'Year')
  )
  
  # Second Page ------
  
  # Date vs Transaction
  google_transaction_revenue = reactive({
    google %>%
      filter(channelGrouping == input$channelGrouping, country == input$country) %>%
      group_by(., channelGrouping, country) %>%
      summarise(total_transaction = sum(transactions, na.rm = T),
                total_revenue = sum(revenue))
  })
  

  
  
}
