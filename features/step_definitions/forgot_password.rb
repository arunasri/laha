Then /I should see custom forgot password message/ do
  user = User.find_by_email "john@example.com"
  page.has_content? "An email has been sent to #{user.email} to reset password. Please check your email."
end
