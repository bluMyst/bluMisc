local std = require('std._base')
require('defines')
local command_run
command_run = function(player)
  local console_frame = player.gui.top.console_frame
  local command = console_frame.command.text
  player.print(">>> " .. tostring(command))
  command = loadstring("return " .. tostring(command)) or loadstring(command)
  local success, return_ = pcall(command)
  if success then
    player.print(std.tostring(return_))
  else
    player.print("ERROR: " .. tostring(return_))
  end
  console_frame.command.text = ''
end
local make_gui
make_gui = function(player)
  player.gui.top.add({
    type = 'frame',
    name = 'console_frame',
    caption = 'console'
  })
  local console_frame = player.gui.top.console_frame
  console_frame.add({
    type = 'textfield',
    name = 'command'
  })
  console_frame.add({
    type = 'button',
    name = 'submit',
    caption = 'submit'
  })
  return console_frame.add({
    type = 'button',
    name = 'close',
    caption = 'close'
  })
end
script.on_event(defines.events.on_gui_click, function(event)
  local player = game.players[event.player_index]
  local console_frame = player.gui.top.console_frame
  if event.element == console_frame.submit then
    return remote.call('blumisc', 'command_run', player)
  elseif event.element == console_frame.close then
    return remote.call('blumisc', 'destroy_gui', player)
  end
end)
local destroy_gui
destroy_gui = function(player)
  script.on_event(defines.events.on_gui_click, nil)
  return player.gui.top.console_frame.destroy()
end
remote.add_interface('blumisc', {
  make_gui = make_gui,
  destroy_gui = destroy_gui,
  command_run = command_run
})
return script.on_event(defines.events.on_player_created, function(event)
  local player = game.players[event.player_index]
  if player.gui.top.console_frame == nil then
    return make_gui(player)
  end
end)
