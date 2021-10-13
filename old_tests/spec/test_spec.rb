require 'command_line/global'

p res = command_line('echo', 'hello')
puts res.exitstatus
puts res.stdout
p command = "my_help edit"
res = command_line(command)
puts res.exitstatus
