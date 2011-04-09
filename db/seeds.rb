require 'active_record/fixtures'
User.create(:name => 'Neeraj', :email => 'neeraj.cmu@gmail.com', :password => 'welcome', :password_confirmation => 'welcome')
Fixtures.create_fixtures("#{Rails.root}/spec/fixtures", "channels")
WikiPage.load
Rake::Task["shows:hindi"].invoke
Rake::Task["shows:telugu"].invoke

#Feed.create(:name => 'shemarootelugu', :channel => telugu_movies).latest
#Video.create(:query_url => "http://www.youtube.com/watch?v=evpjZ3wJwB0")
#Video.create(:query_url => "http://www.youtube.com/watch?v=AcR_Wyv1Pmk")
#Video.create(:query_url => "http://www.youtube.com/watch?v=c3IH6BmLrs8")


#Rake::Task["cron"].invoke
