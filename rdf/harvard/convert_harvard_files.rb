#!/usr/bin/ruby -w

# Harvard input data conversions:
# - Shorten filenames and add .rdf file extension
# - ab.bib.08.20151120.full.mrc.20151201_103145.xml.orig.utf8.20151202.093817.sub_file_993 =>
# harvard.08.993.rdf
# - Convert rdfxml to ntriples into subdirectory ntriples
# Run from directory containing files

require 'fileutils'

jar=ARGV[0]
Dir.mkdir("rdfxml") unless File.exists?("rdfxml")
Dir.mkdir("ntriples") unless File.exists?("ntriples")
Dir.mkdir("originals") unless File.exists?("originals")

Dir.glob("ab.*").each do |f|

  basename = f.sub("ab.bib", "harvard").sub(/2015.*_(\d+)/, "\\1")
  rdffile = basename + ".rdf"
  FileUtils.cp(f, "originals")
  File.rename(f, rdffile)
  ntfile = basename + ".nt"
  cmd = "java -jar #{jar} #{rdffile} #{ntfile}"
  `#{cmd}`
  FileUtils.mv(rdffile, "rdfxml")
  FileUtils.mv(ntfile, "ntriples")
  
end

    
