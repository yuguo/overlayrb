require "RMagick"
require "Find"

class Avatar

  # generate
  def self.go
    back_files = []
    front_files = []
    back_dir = 'back-image'
    front_dir = 'front-image'
    back_files = self.findFiles(back_dir)
    front_files = self.findFiles(front_dir)


    i = 400000
    back_files.each do |back_image|
      front_files.each do |front_image|
         self.cover(front_image, back_image, 'tmp/'+i.to_s+'.png')
         i = i+1
         puts i
      end
    end
  end

  # get files
  def self.findFiles(dir)
    files = []
    Find.find(dir) do |path|
      # not root
      if path.size > dir.size
        if File.directory?path
          # do nothing
        elsif path.match('.png|.jpg')
          files << path
        end
      end
    end
    return files
  end


  # cover the two image
  def self.cover(front_filename, back_filename, new_filename)
    backImage = Magick::Image.read(back_filename).first
    frontImage = Magick::Image.read(front_filename).first

    new_img = backImage.composite(frontImage, Magick::CenterGravity, Magick::OverCompositeOp)
    new_img.write(new_filename)
  end
end

Avatar.go