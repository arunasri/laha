Then /^I should see custom message regarding email has been sent$/ do
  page.has_content?("An email has been sent to john@example.com to reset the password. Please check your email .")
  emailtb = Emailtb.last
  emailtb.data['tempate'] == 'reset_password'
  emailtb.data['subject'] == 'Reset password'
end

