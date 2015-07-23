require 'optparse'
require 'colored'

class Transformer
  @threeX
  @twoX
  @normal

  def initialize(threeX, path)
      puts "init with #{threeX} and #{path}"
      calculateDimensions(threeX)

      if path.end_with? '.svg'
        transform(File.basename(path,File.extname(path)), path.gsub(File.basename(path), ""))
      else
        if !path.end_with? '/'
          path = "#{path}/"
        end

        Dir["#{path}*.svg"].each do |file_name|
          transform(file_name, path)
        end

      end

  end

  def calculateDimensions(threeX)
      @threeX = threeX
      @twoX = (threeX * 2)/3
      @normal = threeX - @twoX
  end

  def transform (file_name, path)
      puts " --- #{file_name} convert with max #{@threeX} --- "

      basename = File.basename(file_name,File.extname(file_name))
      src = "#{path}#{basename}.svg"
      dst = "#{path}#{basename}/#{basename}"
      dense = @threeX.to_i/16*72

      if File.directory? basename
        system( "rm -rf #{basename}")
      end

      system( "mkdir #{path}#{basename}")

      system( "convert -background none -density #{dense} -resize #{@threeX}x#{@threeX}  #{src} #{dst}" + "@3x.png" )
      system( "convert -background none -density #{dense} -resize #{@twoX}x#{@twoX}      #{src} #{dst}" + "@2x.png" )
      system( "convert -background none -density #{dense} -resize #{@normal}x#{@normal}  #{src} #{dst}" + ".png")

      puts " --- #{file_name} success --- "
  end

end

options = {}
OptionParser.new do |opts|
  opts.on('-r', '--sourcename RES'  , 'Source res')   { |v| options["threeX"] = v }
  opts.on('-p', '--sourcepath PATH' , 'Source path')  { |v| options["path"]   = v }
end.parse!

threeX = 150
if options["threeX"].to_i != 0
  threeX = options["threeX"].to_i
end

path = options["path"]
if Dir["#{path}*.svg"].count > 0 or path.end_with? '.svg'
  Transformer.new(threeX, path)
else
  puts "No .svg file to transform".red
end
