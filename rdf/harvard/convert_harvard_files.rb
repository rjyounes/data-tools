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

Dir.glob("ab.*").each do |f|

  basename = f.sub("ab.bib", "harvard").sub(/2015.*_(\d+)/, "\\1")
  rdffile = basename + ".rdf"
  puts "Renaming file #{f} to #{rdffile}."
  File.rename(f, rdffile)
  ntfile = basename + ".nt"
  cmd = "java -jar #{jar} #{rdffile} #{ntfile}"
  `#{cmd}`
  puts "Moving #{rdffile} and #{ntfile} to subdirectories."
  FileUtils.mv(rdffile, "rdfxml")
  FileUtils.mv(ntfile, "ntriples")
  
end


# Merge every 3 files into a single file
# TODO combine with loop above

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
  if count % 3 == 0 or count == filecount
    # e.g., harvard.08.990-991-992.nt
    newfile = [ File.basename(segments[0]), segments[1], filenums.join("-"), "nt" ].join(".")
    puts newfile
    File.open(File.join(merged, newfile), 'w') { |file| file.write(contents) }
    contents = ''
    filenums.clear
  end

end    
