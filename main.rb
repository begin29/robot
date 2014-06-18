require 'tray_app'
require 'my_robot'
require 'awesome_print'

# include Java

app = TrayApplication.new("Robot")
app.icon_filename = 'robot.png'
app.item('Start tracker mag')  { $t1 = Thread.new{ MyRobot.new.start_shot } }
app.item('Stop tracker mag')  do if $t1 && $t1.alive? then $t1.kill; p'---------------tracker shot stopped'; end  end
app.item('Start mouse moving') { Thread.new{ MyRobot.new.mouse_move } }
app.item('Exit')           { java.lang.System::exit(0) }
app.run