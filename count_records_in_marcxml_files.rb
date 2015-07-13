#!/usr/bin/ruby -w

# Count the number of records in a directory of marcxml files. 

search_string = "<record"
total = 0
Dir.glob("*.xml") do |f|
  text = IO.read f
  count = text.scan(search_string).length
  puts "Number of records in file #{f}: #{count}"
  total += count
end
puts "Total number of records in all files: " + total
