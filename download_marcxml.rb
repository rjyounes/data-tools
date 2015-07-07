#!/usr/bin/ruby -w

# (1..179).each do |n|
(101..179).each do |n|
  s = n.to_s.rjust(3, '0')
  filename = "bib.#{s}.xml"
  `curl http://da-data.library.cornell.edu/bibdata/#{filename} > #{filename}`  
end
