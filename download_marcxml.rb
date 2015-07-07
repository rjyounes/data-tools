#!/usr/bin/ruby -w

first = ARGV[0]
last = ARGV[1]

# Defaults
first = 1 if first.nil?
last = 179 if last.nil?

length = last.to_s.length

(first..last).each do |n|
  s = n.to_s.rjust(length, '0')
  filename = "bib.#{s}.xml"
  `curl http://da-data.library.cornell.edu/bibdata/#{filename} > #{filename}`
  # puts filename  
end
