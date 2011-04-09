Given /^I am logged in$/ do
  user = Factory(:user, :email => 'john@example.com', :name => 'John Vanderbilt')
  visit('/logout')
  visit('/login')
  When %{I fill in "email" with "#{user.email}"}
  When %{I fill in "password" with "welcome"}
  When %{I press "Login"}
end
