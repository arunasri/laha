When /I visit custom reset password link$/ do
  user = User.find_by_email('john@example.com')
  user.generate_altp
  visit("/reset_passwords/#{user.altp}")
end
