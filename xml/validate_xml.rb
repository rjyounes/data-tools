#!/usr/bin/ruby -w

require 'rexml/document'

def valid_xml?(xml)
 begin
   REXML::Document.new(xml)
   'valid xml'
 rescue REXML::ParseException => e
   e
 end
end

filename = ARGV[0]

file = File.open filename
xml = ""
file.each do |line|
  xml << line
end

puts valid_xml? xml

