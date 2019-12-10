#!/usr/bin/ruby



def part1(image_data, layer_width, layer_height)
  total_pixels_for_layer=layer_width*layer_height

  all_layers=image_data.each_slice(total_pixels_for_layer).to_a.select { |ary| ary.length == total_pixels_for_layer }
  layer_with_zeros=all_layers.min { |a, b| a.count(0) <=> b.count(0) }
  layer_with_zeros.count(1) * layer_with_zeros.count(2)
end

def part2(image_data, layer_width, layer_height)
  total_pixels_for_layer=layer_width*layer_height

  all_layers=image_data.each_slice(total_pixels_for_layer).to_a.select { |ary| ary.length == total_pixels_for_layer }.reverse
  picture=Array.new(total_pixels_for_layer, 2)

  all_layers.each { |layer|
    layer.each_with_index { |layer_color, index|
      picture_color=picture[index]
      if picture_color == 2 # transparent
        picture[index]=layer_color
      elsif layer_color != 2 # new color is not transparent
        picture[index]=layer_color
      end
    }
  }

  # draw picture
  # puts picture
  (0..layer_height-1).each { |y|
    (0..layer_width-1).each { |x|
      color=picture[layer_width*y+x]
      if color == 0 # white
        print " "
      else
        print color
      end
      print " "

    }
    puts #add newline
  }
end

image_data = File.open("../input/day8.txt").read.split("").map(&:to_i)

puts part1(image_data, 25, 6)
part2(image_data, 25, 6)

