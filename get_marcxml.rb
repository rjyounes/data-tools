#!/usr/bin/ruby -w

# Retrieve marcxml record for each line of the specified file. The file contains 
# one Cornell bib id per line.

# Arguments: 
# ARGV[0] - File where the list of bib ids is stored
# ARGV[1] - Full path to directory where the marcxml files should be written. 
# Omit to write to current working directory.


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
  marcxml = `curl -s http://search.library.cornell.edu/catalog/#{line}.marcxml`
  if (! marcxml.start_with?("<record"))
    puts "No marcxml record found for bib id #{line}."
  else 
    puts "Writing marcxml record for bib id #{line}."
    count += 1
    # Wrap in <collection> tag. Doesn't make any difference in the bibframe of 
    # a single record, but is needed to process multiple records into a single 
    # file, so just add it generally.
    marcxml = marcxml.gsub(/<record xmlns='http:\/\/www.loc.gov\/MARC21\/slim'>/,
      "<?xml version='1.0' encoding='UTF-8'?><collection xmlns='http://www.loc.gov/MARC21/slim'>\n
      <record>") 
    marcxml << '</collection>'  
    # Pretty print the unformatted marcxml for display purposes
    marcxml = `echo "#{marcxml}" | xmllint --format -`  
    File.write(File.join(dir, "#{line}.xml"), marcxml)
  end
end

puts "Wrote #{count} marcxml records."
