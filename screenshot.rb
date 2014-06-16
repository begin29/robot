class Screenshot
  include Java
  # here we are importing Java classes, just like you might require 'yaml' or 'date'
  import java.awt.Robot
  import java.awt.Toolkit
  import java.awt.Rectangle
  import javax.imageio.ImageIO
  import java.awt.Color
  import java.lang.Integer
  import java.io.FileInputStream

    def get_image
      robot     = Robot.new
      toolkit   = Toolkit.get_default_toolkit
      dim       = toolkit.get_screen_size
      m_width = dim.get_width
      rectangle = Rectangle.new(1300, 0, m_width-m_width*0.85, 24) #TODO: need to change val 200
      image     = robot.create_screen_capture(rectangle)
    end


    def find_timer_position img
      iw = img.get_width
      ih = img.get_height
      @i = 0
      while @i < iw  do
        temp = img.getRGB(@i,12)
        # hex = Integer.toHexString(temp)[2..-1]
        hex = Integer.toHexString(temp)
        # c = Color.new(temp)
        # p c.getRed
        # p c.getGreen
        # p '/////////////////////'
        # p hex
        # TODO: add color for disable state
        break if (hex == 'ff373737' || hex == 'ffac0d0d' || hex == 'ffff9e0d' || hex == 'ff598b36' || hex == 'ff141414')
        @i +=1
      end
      @i+1 < iw ? @i+1 : nil
    end

    def record_in_file
      file = java::io::File.new('test.png')
      ImageIO::write(@image, "png", file)
    end

    def start_shot
      p '-------------start'
      x_t ||= nil
      image = get_image
      # p "".blank?
      unless x_t.nil?
        p 'work_cycle'
        p x_t
        work_cycle x_t, image
      else
        p 'start_shot else'
        x_t = find_position_cycle image
        self.start_shot
      end
    end

    def work_cycle x_t
      loop do
        timer_color = nil
        timer_color = image.getRGB(x_t, 12) unless x_t.nil?
        # take_image
        case Integer.toHexString(timer_color)
        when 'ffac0d0d'
          p '===================3'
        when 'ffff9e0d'
          p '===================2'
        when 'ff598b36'
          p '===================1'
        when 'ff141414'
          p '===================take screen'
        end
        sleep(1)
      end
    end

    def find_position_cycle image
      x_t = nil
      loop do
        p 'find_position_cycle'
        p image
        x_t = find_timer_position(image)
        p x_t
        break unless x_t.nil?
        sleep(1)
      end
      x_t
    end

    def take_image
      file = java::io::File.new("test.png_#{Time.now.to_i}")
      ImageIO::write(@image, "png", file)
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
end
