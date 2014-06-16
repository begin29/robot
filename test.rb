class Test

  include Java
  import java.awt.SystemTray

  # def run_cycle
  #   loop do
  #     p '===================='
  #     sleep(2)
  #   end
  # end
  p '--------------------'
  ti = SystemTray.getTrayIcons
  p ti
  # ti.each do |tray|
  #   SystemTray.remove( tray )
  # end
end