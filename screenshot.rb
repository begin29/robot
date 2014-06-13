include Java

require 'daemons'
# here we are importing Java classes, just like you might require 'yaml' or 'date'
import java.awt.Robot
import java.awt.Toolkit
import java.awt.Rectangle
import javax.imageio.ImageIO
import java.awt.Color
import java.lang.Integer

# Taking the screenshot
# 1) Create a new instance of the Robot class
# 2) Use the Toolkit class to get the size of the screen
# 3) and pass those dimensions to the Robot instance for capture

def get_image
  robot     = Robot.new
  toolkit   = Toolkit.get_default_toolkit
  dim       = toolkit.get_screen_size
  m_width = dim.get_width
  rectangle = Rectangle.new(1300, 0, m_width-m_width*0.85, 24) #TODO: need to change val 200
  @image     = robot.create_screen_capture(rectangle)
end


def find_timer_position
  iw = @image.get_width
  ih = @image.get_height
  @i = 0
  while @i < iw  do
    temp = @image.getRGB(@i,12)
    # hex = Integer.toHexString(temp)[2..-1]
    hex = Integer.toHexString(temp)
    # c = Color.new(temp)
    # p c.getRed
    # p c.getGreen
    if hex == "ff373737"
      break
    end
    @i +=1
  end
  @i+1 < iw ? @i+1 : iw
end

get_image
@x_t = find_timer_position


  loop do
    p '-------------'
    p @image.getRGB(@x_t)
    sleep(1)
  end
# Thread.new do
#   while true
#     sleep(1)
#   end
#   # loop do
#   #   p '---------------'
#   #   p @image.getRGB(@x_t)
#   # end
# end



# check own image
  # file = java::io::File.new('test.png')
  # ImageIO::write(@image, "png", file)