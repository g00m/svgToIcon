require 'optparse'
options = {}

OptionParser.new do |opts|
  opts.on('-r', '--sourcename RES', 'Source res') { |v| options["threeX"] = v }
  opts.on('-p', '--sourcepath PATH', 'Source path') { |v| options["path"] = v }
end.parse!

threeX = 150
if options["threeX"].to_i != 0
  threeX = options["threeX"].to_i
end
twoX = (threeX * 2)/3
normal = threeX - twoX

path = ""
if options["path"] != ""
  path = options["path"]
end

if !path.end_with? '/'
    path = "#{path}/"
end

if Dir["#{path}*.svg"].count > 0

  Dir["#{path}*.svg"].each do |file_name|

    puts " --- " + file_name + " convert with max #{threeX}" + " --- "

    basename = File.basename(file_name,File.extname(file_name))
    src = "#{path}#{basename}.svg"
    dst = "#{path}#{basename}/#{basename}"
    dense = threeX.to_i/16*72

    if File.directory? basename
      system( "rm -rf #{basename}")
    end

    system( "mkdir #{path}#{basename}")

    system( "convert -background none -density #{dense} -resize #{threeX}x#{threeX}  #{src} #{dst}" + "@3x.png" )
    system( "convert -background none -density #{dense} -resize #{twoX}x#{twoX}      #{src} #{dst}" + "@2x.png" )
    system( "convert -background none -density #{dense} -resize #{normal}x#{normal}  #{src} #{dst}" + ".png")

    puts " --- " + file_name + " success " + " --- "

  end

else
  puts "No .svg file to transform"
end
