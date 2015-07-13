#!/usr/bin/ruby -w

# Split a directory of marcxml files into files of the specified number of
# records. Write to the directory specified.

require 'optparse'

# TODO Use optionsparserls 

# Parse options
records = 20
destination = nil
saxon = nil
OptionParser.new do |opts|

  opts.banner = 'Usage: split_marcxml_files.rb [options]'

  opts.on('--records', '=[OPTIONAL]', String, 'Number of records to split files into. Defaults to 20.') do |arg|
    records = arg
  end 

  opts.on('--destination', '=[OPTIONAL]', String, 'Absolute or relative path to write files to. The directory is assumed to exist. Defaults to ./marcxml-split-#{records}.') do |arg|
    destination = arg
  end 
  
  opts.on('--saxon', '=[MANDATORY]', String, 'Path to saxon processor.') do |arg|
    saxon = File.expand_path arg
  end
    
  opts.on_tail('-h', '--help', 'Show this message') do
    puts opts
    exit
  end
  
end.parse!

# Script directory
script_dir = File.expand_path(File.dirname(__FILE__))

# The xsl file must reside in the current script's directory
xsl = File.join(script_dir, 'split_marcxml_records.xsl')

# Defaults
# TODO create directory if it doesn't exist
destination = "marcxml-split-#{records}" if destination.nil?
# Oddly, in the reverse order the final slash gets removed by File.expand_path
destination = File.expand_path destination
destination = File.join destination, ''

Dir.glob("*.xml") do |file|
  cmd = "java -jar #{saxon} #{file} #{xsl} pRecords=#{records} pDestination=#{destination}"
  puts "Executing: #{cmd}"
  `#{cmd}`
end
