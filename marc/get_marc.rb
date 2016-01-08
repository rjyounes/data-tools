#!/usr/bin/ruby -w

# Retrieve marc record for each line of the specified file. The file contains 
# one Cornell bib id per line. We are retrieving marc and converting to marcxml
# because the marcxml that is retrieved directly from the catalog is not
# formatted. 

# Arguments: 
# ARGV[0] - File where the list of bib ids is stored
# ARGV[1] - Full path to directory where the marc files should be written. Omit
# to write to current working directory.


file = ARGV[0]
dir = ARGV[1]

if (dir.nil?)
  dir = Dir.pwd
elsif (! File.directory?(dir))
  puts "Creating directory #{dir}."
  Dir.mkdir("#{dir}")
end

count = 0

File.readlines(file).each do |line|
  line.chomp!.strip!
  marc = `curl -s http://newcatalog.library.cornell.edu/catalog/#{line}.marc`
  if (marc.start_with?("<"))
    puts "No marc record found for bib id #{line}."
  else 
    puts "Writing marc record for bib id #{line}."
    count += 1
    File.write(File.join(dir, "#{line}.mrc"), marc)
  end
end

puts "Wrote #{count} marc records"
