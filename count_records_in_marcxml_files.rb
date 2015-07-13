#!/usr/bin/ruby -w

# Count the number of records in a directory of marcxml files. 

search_string = "<record"
count = 0
Dir.glob("*.xml") do |f|
  # puts f
  text = IO.read f
  count += text.scan(search_string).length
end
puts count
