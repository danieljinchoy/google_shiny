


server = function(input, output, session) {
  
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

  
  
  
  # Part 1: Summary Statistic -------------
  
  # Page 1
  
  output$transaction = renderPlotly(
    google_transaction %>%
      ggplot(aes(x = month_char, y = total_transaction)) +
      geom_col(aes(fill = as.factor(year)), position = "dodge") +
      ggtitle("Total Transaction by Month") +
      theme_bw() +
      xlab('Months') +
      ylab('Total Transaction') +
      scale_fill_brewer(palette = 'YlGn', name = '')
    
    )
  
  output$revenue = renderPlotly(
    google_revenue %>%
      ggplot(aes(x = month_char, y = total_revenue)) +
      geom_col(aes(fill = as.factor(year)), position = "dodge") +
      ggtitle("Total Revenue by Month") +
      theme_bw() +
      xlab('Months') +
      ylab('Total Revenue') +
      scale_fill_brewer(palette = 'YlGn', name = 'Year')
  )
  
  # Page 2
  
  output$transaction_country = renderPlotly(
    google_transaction_country %>%
      ggplot(aes(x = country, y = total_transaction)) +
      geom_col(position = "dodge") +
      ggtitle("Total Transaction by Country") +
      theme_bw() +
      xlab('Months') +
      ylab('Total Transaction') +
      coord_flip()
  )
  
  
  output$revenue_country = renderPlotly(
    google_revenue_country %>%
      ggplot(aes(x = country, y = total_revenue)) +
      geom_col(position = "dodge") +
      ggtitle("Total Revenue by Country (Top 10)") +
      theme_bw() +
      xlab('Months') +
      ylab('Total Revenue') +
      coord_flip()
  )
  
  
  
  
  
  # Part 2: Analyzing Traffic Data-------
  
  # Page 3
  
  # Channel vs Transaction
  output$channelvisits = renderPlotly(
    google_channel_visits %>%
      ggplot(aes(x = channelGrouping, y = total_visits)) +
      geom_col(aes(fill = channelGrouping), position = "dodge") +
      ggtitle("Total Visits by Channel") +
      theme_bw() +
      xlab('Channels') +
      ylab('Total Number of Visits') +
      scale_fill_brewer(palette = 'YlGn', name = '') +
      coord_flip()
  )
  
  
  output$channel_transactions = renderPlotly(
    google_channel_transactions %>%
      ggplot(aes(x = channelGrouping, y = total_transactions)) +
      geom_col(aes(fill = channelGrouping), position = "dodge") +
      ggtitle("Total Transactions by Channel") +
      theme_bw() +
      ylab('Total Number of Transactions') +
      scale_fill_brewer(palette = 'YlGn', name = '') +
      coord_flip()
  )
  
  # Page 4
  
  observe({
    month_char <- unique(google %>%
                     filter(google$month_char == input$month_char) %>%
                     .$month_char)
    updateSelectizeInput(
      session, "month_char",
      choices = month_char,
      selected = month_char[1])
  })
  
  google_views <- reactive({
    google %>%
      filter(month_char == input$month_char) %>%
      group_by(channelGrouping) %>%
      summarise(avg_timeOnSite = mean(timeOnSite),
                total_hits = sum(hits),
                avg_hits = mean(hits),
                total_pageviews = sum(pageviews),
                avg_pageviews = mean(pageviews))
  })
  
  output$views <- renderPlotly(
    google_views() %>%
      gather(key = type, value = views, avg_hits, avg_pageviews) %>%
      ggplot(aes(x = channelGrouping, y = views, fill = type)) +
      geom_col(position = "dodge") +
      ggtitle("Average Hits and Page Views") +
      xlab('Channels') +
      ylab('Average Number of Hits and Page Views') +
      coord_flip()+
      theme_fivethirtyeight()
  )
  
  output$time_on_site <- renderPlotly(
    google_views() %>%
      ggplot(aes(x = channelGrouping, y = avg_timeOnSite)) +
      geom_col(fill = "green") +
      ggtitle("Average Time on Site (Sec)") +
      ylab('Average Time Spend on Site') +
      coord_flip() +
      theme_fivethirtyeight()
  )
  
  
  # Page 5: Exploring relationship
  
  
  # Only focusing on revenue under $1000
  output$plot1 <- renderPlotly({
    ggplot(google_vis_rev, aes(x = hits, y = revenue)) +
      geom_point(aes(color = newVisits), position = 'jitter') +
      guides(colour=FALSE) +
      ggtitle('Hits and Revenue') +
      xlab('Hits') +
      ylab('Revenue') +
      theme_fivethirtyeight()
  })
  
  output$plot2 <- renderPlotly({
    ggplot(google_vis_rev, aes(x = pageviews, y = revenue)) +
      geom_point(aes(color = newVisits), position = 'jitter') +
      guides(colour=FALSE) +
      ggtitle('Pageviews and Revenue') +
      xlab('Page Views') +
      ylab('Revenue') +
      theme_fivethirtyeight()
  })
  
  
  
  
  
  
 # Third page -----------
  # google_interactive = reactive({
  #   pageviews <- input$pageviews
  #   minmonth <- input$month[1]
  #   maxmonth <- input$month[2]
  #   
  #   # Apply filters
  #   m <- google %>%
  #     filter(
  #       pageviews >= pageviews,
  #       month >= minmonth,
  #       month <= maxmonth
  #     )
  #   
  #   # Optional: filter by genre
  #   if (input$channelGrouping != "All") {
  #     channelGrouping <- input$channelGrouping
  #     m <- m %>% filter(channelGrouping == channelGrouping)
  #   }
  #   
  #   m <- as.data.frame(m)
  #   
  # })
  # 
  # 
  # vis <- reactive({
  #   # Lables for axes
  #   xvar_name <- names(axis_vars)[axis_vars == input$xvar]
  #   yvar_name <- names(axis_vars)[axis_vars == input$yvar]
  #   
  #   # Normally we could do something like props(x = ~BoxOffice, y = ~Reviews),
  #   # but since the inputs are strings, we need to do a little more work.
  #   xvar <- prop("x", as.symbol(input$xvar))
  #   yvar <- prop("y", as.symbol(input$yvar))
  #   
  #   google_interactive %>%
  #     ggvis(x = xvar, y = yvar) %>%
  #     layer_points(size := 50, size.hover := 200,
  #                  fillOpacity := 0.2, fillOpacity.hover := 0.5) %>%
  #     add_axis("x", title = xvar_name) %>%
  #     add_axis("y", title = yvar_name)
  # })
  # 
  # vis %>% bind_shiny("plot1")
  
  
  
  
  
  
  
}
