# Create a function to import data
import_data = function(x){
  read.csv(x, header = TRUE)
}

files = list.files(pattern = '.csv')
google_df = do.call(cbind, lapply(files, import_data))

# addtional data
google_bounce_pageviews = read.csv('data/google_bounce_pageviews.csv')
google_returning_visitors = read.csv('data/google_returning_visitors.csv')
google_store_visitors = read.csv('data/google_store_visitors.csv')
google_visited_pages = read.csv('data/google_visited_pages.csv')
google_category = read.csv('data/google_category')


# Selecting our interest variables
google = google_df %>%
  select(., visitId, fullVisitorId, visitNumber, visitStartTime, date,
         channelGrouping, socialEngagementType, browser, operatingSystem, deviceCategory,
         country, networkDomain, visits, hits, pageviews, timeOnSite, bounces, newVisits,
         transactions, totalTransactionRevenue, source, medium, timeOnSite)



# ------------------------------------------------------------------------------#


#####----------------------------Cleaning Data -------------------------------#####





# Convert the timestamp (expressed as POSIX time) to datetime
google$visitStartTime = as_datetime(google$visitStartTime)

# Convert date to date
google$date = parse_date_time(google$date, orders = '%Y%m%d')

# Create month and year variable
google = google %>% 
  mutate(.,month = month(date))

google = google %>% 
  mutate(., year = year(date))


# Handle NA values:
# transactions: convert NA to 0 (I did this because google analytics recorded no transactions into NA values)
google = google %>% 
  mutate(., transactions = if_else(is.na(transactions), 0, transactions))

# timeOnSite: convert NA to 0 (I did this because based on the number of hits and pageviews.
# When the hit and pageviews is recorded as 1, I assumed that the user did not view website and closed the window
# immediately)
google = google %>% 
  mutate(., timeOnSite = if_else(is.na(timeOnSite), 0, timeOnSite))

google = google %>% 
  mutate(., pageviews = if_else(is.na(pageviews), 0, pageviews))

google = google %>% 
  mutate(., revenue = totalTransactionRevenue/1000000) %>% 
  mutate(., revenue = if_else(is.na(revenue), 0, revenue))

google = google %>% 
  mutate(., month_char = case_when(
    month == 1 ~ 'Jan',
    month == 2 ~ 'Feb',
    month == 3 ~ 'Mar',
    month == 4 ~ 'Apr',
    month == 5 ~ 'May',
    month == 6 ~ 'Jun',
    month == 7 ~ 'Jul',
    month == 8 ~ 'Aug',
    month == 9 ~ 'Sep',
    month == 10 ~ 'Oct',
    month == 11 ~ 'Nov',
    month == 12 ~ 'Dec'
  ))


google$month_char = factor(google$month_char, 
                           levels = c("Aug", "Sep", "Oct", "Nov", "Dec", "Jan",
                                      "Feb", "Mar", "Apr", "May", "Jun", "Jul"
                           ))


google = google %>% 
  mutate(., newVisits = case_when(
    is.na(newVisits) ~ "Returning",
    newVisits == 1 ~ 'New'
  ))

google2 = google
google2$month_char = as.character(google2$month_char)
str(google)
# ---------------------------------------------------------------------------------#







# Google Merchandise Store Revenue by month
google_revenue = google %>% 
  select(., month_char, year, totalTransactionRevenue) %>% 
  # In order to interpret the transactionRevenue variable correctly, we need to divide the varaible by 1000000 
  mutate(., revenue = totalTransactionRevenue/1000000) %>% 
  group_by(month_char, year) %>% 
  summarise(total_revenue = sum(revenue, na.rm = T)) %>% 
  arrange(year)


# Google Merchandise Store Transaction and Revenue by month
google_transaction = google %>% 
  select(., month_char, year, transactions) %>% 
  group_by(., month_char, year) %>% 
  summarise(total_transaction = sum(transactiosns, na.rm = T)) %>% 
  arrange(year)

# Google Merchandise Store transaction by Country
google_transaction_country = google %>%
  select(., country, transactions) %>%
  group_by(country) %>% 
  summarise(total_transaction = sum(transactions, na.rm = T)) %>%
  arrange(desc(total_transaction)) %>% 
  top_n(10, total_transaction)


google_revenue_country = google %>%
  select(., country, revenue) %>%
  group_by(country) %>% 
  summarise(total_revenue = sum(revenue, na.rm = T)) %>%
  arrange(desc(total_revenue)) %>% 
  top_n(10, total_revenue)

# Total visits by date
google_visit_date = google %>% 
  select(., month, date, year, visits) %>% 
  group_by(month, year) %>% 
  summarise(total_visits = sum(visits)) %>% 
  arrange(year)

#Which channel brought the most transaction? 
google_channel_transactions = google %>% 
  select(., channelGrouping, transactions, newVisits, hits, visits) %>% 
  group_by(., channelGrouping, newVisits) %>% 
  summarise(total_transactions = sum(transactions, na.rm = T),
            total_visits = sum(visits, na.rm = T),
            average_hit_number = mean(hits, na.rm = T)) %>% 
  arrange(desc(total_transactions))

google_channel_transactions2 = google %>% 
  select(., channelGrouping, transactions) %>% 
  group_by(., channelGrouping) %>% 
  summarise(total_transactions = sum(transactions, na.rm = T)) %>% 
  arrange(desc(total_transactions))



google_category2 = google_category %>% 
  group_by(.,product_category) %>% 
  summarise(total_product_revenue = sum(product_revenue, na.rm = T),
            total_transaction = n()) %>% 
  arrange(desc(total_product_revenue)) %>% 
  top_n(7)

google_category2 %>%
  gather(key = type, value = "value", total_product_revenue, total_transaction) %>%
  ggplot(., aes(x = reorder(product_category, value), y = value, fill = type)) +
  geom_col(position = 'dodge')

#####------------------------- Part 2: Traffic Data ---------------------------#####
# Questions:
# How long does the consumer stay on the google merchandise website?
# Variables to look at: hit, bounce rate, visit, time varialbe
# What does the traffic look like?
# Where are the consumers coming from? Sources, medium, referral path, etc

# Total visits by country
google_visits_country = google %>% 
  select(., country, visits) %>%
  group_by(., country) %>% 
  summarise(total_visits = sum(visits)) %>% 
  arrange(desc(total_visits)) %>% 
  top_n(10, total_visits)


# Transaction per visits (transaction rate)
google_visits_country2 = google %>% 
  select(., country, visits) %>%
  group_by(., country) %>% 
  summarise(total_visits = sum(visits))

google_transaction_country2 = google %>%
  select(., country, transactions) %>%
  group_by(country) %>% 
  summarise(total_transaction = sum(transactions, na.rm = T))

google_rate = google_transaction_country2 %>% 
  inner_join(., google_visits_country2, by = 'country') %>% 
  mutate(transaction_rate = total_transaction/total_visits) %>% 
  arrange(desc(transaction_rate)) %>% 
  top_n(10, total_visits)


#--- Exploring ---






google_vis = google %>% 
  select(., hits, transactions, revenue, pageviews, visits, 
         newVisits, deviceCategory, country, month_char, timeOnSite, channelGrouping)

ggplot(google_vis, aes(x = timeOnSite, y = revenue)) +
  geom_point()


google_vis_rev = google_vis %>% 
  select(., timeOnSite, revenue, pageviews, newVisits, hits) %>% 
  filter(., revenue > 0 & revenue < 1000 & pageviews > 0 & hits > 1 & hits < 100)

ggplot(google_vis_rev, aes(x = timeOnSite, y = revenue)) +
  geom_point(aes(color = newVisits))


ggplot(google_vis_rev, aes(x = pageviews, y = revenue)) + 
  geom_point(aes(color = newVisits), position = 'jitter')

ggplot(google_vis_rev, aes(x = hits, y = revenue)) + 
  geom_point(aes(color = newVisits))

ggplot(google_vis_rev, aes(x = pageviews, y = revenue)) + 
  geom_jitter(alpha = 0.5, shape = 1)
# geom_point(aes(color = newVisits), position = 'jitter')



# Visits by device 
google_transactions_device = google %>% 
  select(., fullVisitorId, deviceCategory, visits, newVisits, hits) %>% 
  group_by(deviceCategory, newVisits) %>% 
  summarise(total_visit_number = sum(visits),
            average_hit_number = mean(hits))


# Where are the users landing? Where are they staying?
google_visited_pages


# Do customers purchase something on their first visit? Or more often it is their second visit?
google_fist_or_second = google %>%
  select(., fullVisitorId, visitNumber, transactions) %>% 
  mutate(visit_number = case_when(
    visitNumber == 1 ~ 'First Time Visitor',
    visitNumber >= 2 ~ 'Second Time Visitor'
  )) %>% 
  group_by(visit_number) %>% 
  summarise(total_transactions = sum(transactions, na.rm = T))


# Returning visitors by date
google_returning_visitors$date = parse_date_time(google_returning_visitors$date, orders = '%Y%m%d')
google_returning_visitors2 = google_returning_visitors %>%
  mutate(., month = month(date), year = year(date)) %>% 
  group_by(month, year) %>% 
  summarise(total_visitors_num = sum(total_visitors), total_returning_visitors = sum(returning_visitors)) %>%
  arrange(year) %>% 
  mutate(RVR = total_returning_visitors/total_visitors_num * 100)


# insight: RVR is low October and November


# Traffic Source from which the session originated.
google_bounce_rate = google %>% 
  select(., source, visits, bounces, newVisits) %>% 
  group_by(source, newVisits) %>% 
  summarise(total_visits = sum(visits), total_bounce = sum(bounces, na.rm = T)) %>% 
  arrange(desc(total_visits)) %>% 
  mutate(bounce_rate = total_bounce / total_visits * 100) %>% 
  top_n(20, total_visits)
# Bounce rate is single-page sessions divided by all sessions, or the percentage of all sessions on your site
# in which users viewed only a single page and triggered only a single request to the Analytics server.
# Basically, low bounce rate is good for Google Merchandise Store


# Bounce rate by pageviews abd count of pageviews
google_bounce_pageviews


# referral path,, medium, ChannelGrouping, time on screen
# Channel vs pageviews 
google_channel_visits = google %>% 
  select(., channelGrouping, visits) %>% 
  group_by(., channelGrouping) %>% 
  summarise(total_visits = sum(visits, na.rm = T)) %>% 
  arrange(desc(total_visits))


google_traffic_insights = google %>%
  select(., timeOnSite, newVisits, hits, pageviews) %>%
  group_by(newVisits) %>%
  summarise(total_pageviews = sum(pageviews), avg_timeOnSite = mean(timeOnSite), total_hits = sum(hits))


google_insights = google %>% 
  select(., timeOnSite, newVisits, hits, pageviews, channelGrouping)



# ---------------------------------------------------------------------------------#








#####----------------------- Part 3: Holiday Season ------------------------#####

# Holiday period: From 2016-11-14 To 2016-12-05
google_holiday = google %>% 
  filter(., date >= '2016-11-14' &  date <= '2016-12-05')






##### ----- Produce Image Graphs ----- #####



google_bounce_pageviews %>% 
  top_n(10) %>% 
  arrange(desc(bounce_rate)) %>% 
  ggplot(., aes(x = reorder(page, bounce_rate), y = bounce_rate)) +
  geom_col() +
  coord_flip() +
  theme_bw() +
  ylab('Bounce Rate') +
  xlab('Page') +
  ggtitle('Bounce Rates by Page')


google_vis %>% 
  group_by(deviceCategory) %>% 
  summarise(total_transactions = sum(transactions),
            total_visits = sum(visits) %>% 
              avg_hits = mean(hits)) %>% 
  ggplot(., aes(x = reorder(deviceCategory, avg_hits), y = avg_hits))




google = google %>% 
  mutate(hour = hour(visitStartTime))

google %>% 
  group_by(hour, newVisits) %>% 
  summarise(total_visits = sum(visits)) %>% 
  ggplot(., aes(x = hour, y = total_visits, fill = channelGrouping)) +
  geom_col(position = 'dodge')


# ----------


fit <- lm(revenue ~ hits + pageviews + timeOnSite, data=google)
summary(fit)
hits.res = residuals(fit)
plot(google$hits, hits.res)
