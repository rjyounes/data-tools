#!/usr/bin/ruby -w

# Merge every 3 files into a single file

count = 0
contents = ''
filenums = []

Dir.mkdir("merged") unless File.exists?("merged")

filecount = Dir.glob("*.nt").length

Dir.glob("*.nt").each do |f|
  
  count += 1
    
  # e.g., harvard.08.990.nt
  segments = f.split(".")
  
  # 990
  filenums.push segments[2]
  
  contents += File.open(f).read
  if count % 3 == 0 or count == filecount
    # e.g., harvard.08-990-991-992.nt
    newfile = [ segments[0], segments[1], filenums.join("-"), "nt" ].join(".")
    File.open(File.join("merged", newfile), 'w') { |file| file.write(contents) }
    contents = ''
    filenums.clear
  end

end