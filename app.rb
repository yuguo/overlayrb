#!/usr/bin/ruby

require "RMagick"
require "Find"

class Avatar

  # generate
  def self.go
    back_txt = 'back-color.txt'
    front_txt = 'front-color.txt'
    front_dir = 'front-image'
    front_files = self.findFiles(front_dir)


    i = 400000

    File.open(back_txt, 'r').each_line do |back_color|
      File.open(front_txt, 'r').each_line do |front_color|
        next if back_color == front_color
        front_files.each do |front_image|
          self.cover(front_image,front_color, back_color, 'tmp/'+i.to_s+'.png')
          i = i+1
          puts i
        end
      end
    end

    puts "#{i - 400000} images has been generated!"
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
  def self.cover(front_filename, front_color, back_color, new_filename)
    backImage = Magick::Image.new(60, 60) {self.background_color = 'transparent'}
    Magick::Draw.new.stroke('none').stroke_width(0).fill(back_color).roundrectangle(0,0, 60,60, 8, 8).draw(backImage)
    front_image = Magick::Image.read(front_filename).first
    front_image.alpha(Magick::ExtractAlphaChannel)
    front_image.background_color = front_color
    front_image.alpha(Magick::ShapeAlphaChannel)
    # matrix = [[1, 0, 0],
    #           [0, 1, 0],
    #           [0, 0, 1]]
    # new_front_image = front_image.recolor(matrix)

    new_image = backImage.composite(front_image, Magick::CenterGravity, Magick::OverCompositeOp)
    new_image.write(new_filename)
  end

end

Avatar.go