class TrayApplication

  include Java
  import java.awt.TrayIcon
  import java.awt.Toolkit
  # import java.io.InputStreamReader
  # import java.io.BufferedReader
  # import java.lang.System

  attr_accessor :icon_filename, :menu_items

  def initialize(name = 'Tray Application')
    @menu_items = []
    @name       = name
  end

  def item(label, &block)
    item = java.awt.MenuItem.new(label)
    item.add_action_listener(block)
    @menu_items << item
  end

  def run
    popup = java.awt.PopupMenu.new
    @menu_items.each{|i| popup.add(i)}

    # Give the tray an icon and attach the popup menu to it
    image    = java.awt.Toolkit::default_toolkit.get_image(@icon_filename)
    tray_icon = TrayIcon.new(image, @name, popup)
    # TODO: need to clear tray
    p '-------------------------run'
    tray_icon.image_auto_size = true

    # Finally add the tray icon to the tray
    tray = java.awt.SystemTray::system_tray
    tray.add(tray_icon)
  end

end