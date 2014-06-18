class KeyHook
  require 'java'
  require 'JNativeHook.jar'

  import org.jnativehook.NativeHookException
  import org.jnativehook.keyboard.NativeKeyEvent
  import org.jnativehook.keyboard.NativeKeyListener

  include NativeKeyListener

  def nativeKeyPressed(e)
    # p '------------keypressed'
    # puts NativeKeyEvent.getKeyText e.getKeyCode
  end

  def nativeKeyTyped(e)
    # p '------------keytyped'
    # puts NativeKeyEvent.getKeyText e.getKeyCode
  end

  def nativeKeyReleased(e)
    $global_key =  NativeKeyEvent.getKeyText e.getKeyCode
  end


end