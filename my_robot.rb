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
    @monitor_count = self.execute "xrandr -d :0 -q | grep ' connected' | wc -l"
  end

  def start_shot
    @x_t ||= nil
    unless @x_t.nil?
      p '-------------tracker shot working'
      work_cycle @x_t
    else
      p '--------------searching tracker...'
      @x_t = find_position_cycle
      self.start_shot
    end
  end

  def take_image
    image = get_image
    file = java::io::File.new("test_#{Time.now.to_i}.png")
    ImageIO::write(image, "png", file)
  end

  def take_color name, x_t, y_t
    file = ImageIO.read( FileInputStream.new("#{name}.png") )
    p 'take color'
    p Integer.toHexString( file.getRGB(x_t, y_t) )
    # ff598b36 green 1
    # ffff9e0d orange 2
    # ffac0d0d red 3
    # ff141414 screen
  end

  def mouse_move
    p '---------------start mouse move'
    loop do
      @robot.mouseMove(Random.new.rand(0..@m_width),Random.new.rand(0..@m_height))
      break_cycle 'Escape', 'mouse move'
      sleep(3)
    end
  end

  def execute cmd
    Runtime.getRuntime.exec("#{cmd}")
  end

  def show_notification
    self.execute('notify-send --expire-time=2000 Robot_say: Hello!!! -i face-tired')
  end

  private
    def get_image
      rectangle = Rectangle.new(0, 0, @m_width, 24) #TODO: need to change val 200
      image     = @robot.create_screen_capture(rectangle)
    end

    def open_image name
      file = ImageIO.read( FileInputStream.new("#{name}.png") )
    end

    def work_cycle x_t
      loop do
        timer_color = nil
        image = get_image
        timer_color = image.getRGB(x_t, 12) unless x_t.nil?
        w_title = %w[chrome sublime].sample
        case Integer.toHexString(timer_color)
        when 'ffac0d0d'
          show_notification
          p '===================3'
        when 'ffff9e0d'
          p '===================2'
          if @monitor_count == 1
            self.execute('wmctrl -R'+ w_title)
            self.execute("xdotool key Ctrl+#{[1,2].sample}") if w_title == 'chrome'
          else
            self.execute('wmctrl -R sublime')
            self.execute('wmctrl -R chrome')
            self.execute("xdotool key Ctrl+#{[1,2].sample}")
          end
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
        unless x_t.nil?
          p '-----------------searching done'
          break
        end
        sleep(1)
      end
      x_t
    end

    def break_cycle key_name, process_name
      if $global_key && $global_key == key_name
        $global_key = nil
        p "--------------#{process_name} stopped"
        break
      end
    end

    def find_timer_position img
      iw = img.get_width
      ih = img.get_height
      @i = 0
      while @i < iw  do
        hex = Integer.toHexString( img.getRGB(@i,12) )
        hex9 = Integer.toHexString( img.getRGB(@i,9) )
        hex15 = Integer.toHexString( img.getRGB(@i,15) )
        break if ( (hex == 'ff373737' && hex9 == 'ff525252' && hex15 == 'ff313131') ) # TODO: add for not working and screen process timer   || hex == 'ffac0d0d' || hex == 'ffff9e0d' || hex == 'ff598b36' || hex == 'ff141414')
        @i +=1
      end
      @i+1 < iw ? @i+1 : nil
    end
end
