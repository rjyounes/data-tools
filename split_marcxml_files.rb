#!/usr/bin/ruby -w

# Split a directory of marcxml files into files of the specified number of
# records. Write to the directory specified.

require 'optparse'

# TODO Use optionsparserls 

# Parse options
pRecords = 20
pDestination = nil
saxon = nil
OptionParser.new do |opts|

  opts.banner = 'Usage: split_marcxml_files.rb [options]'

  opts.on('--pRecords', '=[OPTIONAL]', String, 'Number of records to split files into. Defaults to 20.') do |arg|
    pRecords = arg
  end 

  opts.on('--pDestination', '=[OPTIONAL]', String, 'Absolute or relative path to write files to. Defaults to ./marcxml-split-#{pRecords}.') do |arg|
    pDestination = arg
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
pDestination = "marcxml-split-#{pRecords}" if pDestination.nil?
pDestination = File.expand_path pDestination

Dir.glob("*.xml").each do |file|
  cmd = "java -jar #{saxon} #{file} #{xsl} pRecords=#{pRecords} pDestination=#{pDestination}"
  puts "Executing: #{cmd}"
  `#{cmd}`
end
