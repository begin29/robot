class MyRobot
  include Java
  # here we are importing Java classes, just like you might require 'yaml' or 'date'
  import java.awt.Robot
  import java.awt.Toolkit
  import java.awt.Rectangle
  import javax.imageio.ImageIO
  import java.lang.Integer
  import java.io.FileInputStream
  import java.lang.Runtime
  import java.awt.event.InputEvent
  import java.io.BufferedReader
  import java.io.InputStreamReader
  import java.lang.System


  def initialize
    @robot     = Robot.new
    @toolkit   = Toolkit.get_default_toolkit
    @dim       = @toolkit.get_screen_size
    @m_width = @dim.get_width
    @m_height = @dim.get_height
  end

  def get_image
    rectangle = Rectangle.new(@m_width*0.5, 0, @m_width-@m_width*0.75, 24) #TODO: need to change val 200
    image     = @robot.create_screen_capture(rectangle)
  end


  def find_timer_position img
    iw = img.get_width
    ih = img.get_height
    @i = 0
    while @i < iw  do
      temp = img.getRGB(@i,12)
      hex = Integer.toHexString(temp)
      break if (hex == 'ff373737' || hex == 'ffac0d0d' || hex == 'ffff9e0d' || hex == 'ff598b36' || hex == 'ff141414')
      @i +=1
    end
    @i+1 < iw ? @i+1 : nil
  end

  def start_shot
    p '-------------start'
    @x_t ||= nil
    unless @x_t.nil?
      p 'work_cycle'
      p @x_t
      work_cycle @x_t
    else
      p 'start_shot else'
      @x_t = find_position_cycle
      self.start_shot
    end
  end

  def work_cycle x_t
    loop do
      timer_color = nil
      image = get_image
      timer_color = image.getRGB(x_t, 12) unless x_t.nil?

      w_title = %w[chrome sublime].sample
      case Integer.toHexString(timer_color)
      when 'ffac0d0d'
        p '===================3'
      when 'ffff9e0d'
        p '===================2'
        self.execute('wmctrl -R'+ w_title)
      when 'ff598b36'
        p '===================1'
      when 'ff141414'
        p '===================take screen'
      end

      sleep(1)
    end
  end

  def find_position_cycle
    x_t = nil
    loop do
      image = get_image
      x_t = find_timer_position(image)
      break unless x_t.nil?
      sleep(1)
    end
    x_t
  end

  def take_image image
    file = java::io::File.new("test_#{Time.now.to_i}.png")
    ImageIO::write(image, "png", file)
  end

  def take_color name
    file = ImageIO.read( FileInputStream.new("#{name}.png") )
    p 'take color'
    p Integer.toHexString(file.getRGB(47, 12))
    # ff598b36 green 1
    # ffff9e0d orange 2
    # ffac0d0d red 3
    # ff141414 screen
  end

  def execute cmd
    Runtime.getRuntime.exec("#{cmd}")
  end

  def mouse_move
    loop do
      @robot.mouseMove(Random.new.rand(0..@m_width),Random.new.rand(0..@m_height))
      sleep(2);
      # break unless @code.nil?
    end
  end
end
