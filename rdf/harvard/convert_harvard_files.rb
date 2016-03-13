#!/usr/bin/ruby -w

# Harvard input data conversions:
# - Shorten filenames and add .rdf file extension
# - ab.bib.08.20151120.full.mrc.20151201_103145.xml.orig.utf8.20151202.093817.sub_file_993 =>
# harvard.08.993.rdf
# - Convert rdfxml to ntriples into subdirectory ntriples
# - Combine files of 100 records/file into files of 300 records/file
# Run from directory containing files

require 'fileutils'

# Use for logging
# datetime_format = '%Y-%m-%d %H:%M:%S'

jar=ARGV[0]
Dir.mkdir("rdfxml") unless File.exist?("rdfxml")
Dir.mkdir("ntriples") unless File.exist?("ntriples")

Dir.glob("ab.*").each do |f|

  # Simplify filename and add .rdf extension
  basename = f.sub("ab.bib", "harvard").sub(/2015.*_(\d+)/, "\\1")
  rdffile = basename + ".rdf"
  # puts "Renaming file #{f} to #{rdffile}."
  File.rename(f, rdffile)

  # Fix namespace
  text = File.read(rdffile)
  text.gsub!("http://ld4l.harvard.edu/", "http://draft.ld4l.org/harvard/")
  File.open(rdffile, "w") { |file| file.puts text }
    
  # Convert to ntriples
  ntfile = basename + ".nt"
  cmd = "java -jar #{jar} #{rdffile} #{ntfile}"
  `#{cmd}`
  
  # Copy files to subdirectories
  # puts "Moving #{rdffile} and #{ntfile} to subdirectories."
  # May skip this if space is an issue
  FileUtils.mv(rdffile, "rdfxml")
  FileUtils.mv(ntfile, "ntriples")

end


# Merge every 3 files into a single file.
# No sense merging into above loop, because the rdf converter has to write to 
# a file anyway, so we wouldn't save file writes.

count = 0
contents = ''
filenums = []

merged = "merged"
Dir.mkdir(merged) unless File.exists?(merged)

filecount = Dir.glob("ntriples/*.nt").length

puts filecount

Dir.glob("ntriples/*.nt").each do |f|

  count += 1
    
  # e.g., harvard.08.990.nt
  segments = f.split(".")
  
  # 990
  filenums.push segments[2]
  
  contents += File.open(f).read
  
  # If this is the third file since the last write, or the last file, write out
  # contents to the merge file
  if count % 3 == 0 or count == filecount
    # e.g., harvard.08.990-991-992.nt
    newfile = [ File.basename(segments[0]), segments[1], filenums.join("-"), "nt" ].join(".")
    #  puts newfile
    File.open(File.join(merged, newfile), 'w') { |file| file.write(contents) }
    contents = ''
    filenums.clear
  end

end    
