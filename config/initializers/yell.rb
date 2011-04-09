# use it when you want your log messages to not be appear in regular log file
#
# yell "The value of @user is #{@user.inspect}"
#
def yell(msg)
  f = File.open("#{Rails.root}/log/yell.log","a")
  f.puts msg
  f.close
end
