#!/usr/bin/ruby -w

# Convert a directory of MARCXML files to Bibframe RDF

require 'optparse'
require 'fileutils'

# Assign default options
format = 'rdfxml'
baseuri = source = targetdir = ''

# Parse options
OptionParser.new do |opts|

  opts.banner = 'Usage: marc2bibframe.rb [options]'
 
  opts.on('--baseuri', '=[MANDATORY]', String, 'Namespace for minting URIs') do |b|
    baseuri = b
  end 
  
  opts.on('--source', '=[MANDATORY]', String, 'File or directory path') do |sd|
    source = sd
  end  
  
  opts.on('--targetdir', '=[MANDATORY]', String, 'Directory to write RDF files to') do |td|
    targetdir = td
  end  

  opts.on('--format', '=[OPTIONAL]', String, 'RDF serialization; defaults to rdfxml') do |f|
    format = f
  end   
      
  opts.on_tail('-h', '--help', 'Show this message') do
    puts opts
    exit
  end
  
end.parse!

datetime = Time.now.strftime('%Y%m%d-%H%M%S')
targetdir = File.join(targetdir, datetime)  
FileUtils.makedirs targetdir
# logfile = targetdir + '.log'

rdfdir = File.join(targetdir, 'bibframe', format)
FileUtils.makedirs rdfdir

# Set bibframe file extension based on serialization
ext = case format
  when 'rdfxml', 'rdfxml-raw'
    'rdf'
  when 'json', 'extendedJSON'
    'json'
  when 'ntriples'
    'nt'
end

method = (ext == 'nt' || ext == 'json') ? "'!method=text'" : ''

count = 0

if File.file? source
  sourcefiles = [ source ]
elsif File.directory? source
  sourcefiles = Dir.glob(File.join(source, "*.xml"))
end

if ! sourcefiles
  puts "File or directory " + source + " not found."
elsif File.directory? source and sourcefiles.empty?
  puts "No files found in directory " + source + "."
else
  sourcefiles.each do |xmlfile|
    count += 1
    puts "Converting marcxml file #{xmlfile} to bibframe rdf (#{format})."
    basename  = File.basename(xmlfile, ".xml")
    rdffile = File.join(rdfdir, "#{basename}.#{ext}")
    command = "java -cp /Users/rjy7/Workspace/saxon/saxon9he.jar net.sf.saxon.Query #{method} /Users/rjy7/Workspace/marc2bibframe/xbin/saxon.xqy marcxmluri=#{xmlfile} baseuri=#{baseuri} serialization=#{format} > #{rdffile}"
    system(command)
  end

  puts "Converted #{count} files from marcxml to bibframe rdf." 
end

