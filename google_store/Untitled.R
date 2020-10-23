ggplot(google, aes(x = timeOnSite, y = transactions)) +
  geom_point()


google_vis = google %>% 
  select(., hits, transactions, revenue, pageviews, visits, 
         newVisits, deviceCategory, country, month_char, timeOnSite, channelGrouping)

ggplot(google_vis, aes(x = timeOnSite, y = revenue)) +
  geom_point()



google_vis_rev = google_vis %>% 
  select(., timeOnSite, revenue, pageviews, newVisits, hits) %>% 
  filter(., revenue > 0 & revenue < 1000 & pageviews > 0 & hits > 1 & hits < 100)


google_vis_rev2 = google_vis %>% 
  select(., channelGrouping, revenue, pageviews, newVisits, hits)




ggplot(google_vis_erev, aes(x = timeOnSite, y = revenue)) +
  geom_point(aes(color = newVisits))


ggplot(google_vis_rev, aes(x = pageviews, y = revenue)) + 
  geom_point(aes(color = newVisits), position = 'jitter')

ggplot(google_vis_rev, aes(x = hits, y = revenue)) + 
  geom_point(aes(color = newVisits))

ggplot(google_vis_rev, aes(x = pageviews, y = revenue)) + 
  geom_jitter(alpha = 0.5, shape = 1)
  # geom_point(aes(color = newVisits), position = 'jitter')


