require 'tray_app'
require 'my_robot'
require 'awesome_print'

# include Java

app = TrayApplication.new("Robot")
app.icon_filename = 'robot.png'
app.item('Start tracker mag')  { @t1 = Thread.new{ MyRobot.new.start_shot } }
app.item('Start mouse moving') { @t2 = Thread.new{ MyRobot.new.mouse_move } }
# app.item('Start mouse moving') { MyRobot.new.mouse_move }
app.item('Exit')           { java.lang.System::exit(0) }
app.run