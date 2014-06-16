require 'tray_app';
require 'screenshot';
require 'test'

include Java

app = TrayApplication.new("Robot")
app.icon_filename = 'robot.png'
app.item('Start tracker mag')  {t = Thread.new(Screenshot.new.start_shot); t.start;}
app.item('Test Thread')  {t2 = Thread.new(); t2.start(Test.new.run_cycle);}
app.item('Exit')              {java.lang.System::exit(0)}
app.run