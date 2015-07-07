#!/usr/bin/ruby -w

# Delete empty files in the current directory

Dir.glob("*") do |f|
  File.delete f if ! File.size? f 
  # puts f if ! File.size? f
end
  

