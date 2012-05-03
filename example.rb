require 'RbGTrends'
email = "your email"
passwd = "your passwd"
r = RbGTrends.new(email, passwd)
p r.csv
p r.csv('Region')

