require 'spoon'

pid = Spoon.spawn('screenshot.rb')

p Process.waitpid(pid)

# SpoonDaemon::Runner.new('screenshot.rb', "start")