local std = require('std._base')
local ahtolib = require('ahtolib')
require('defines')
local DEBUG = true
ahtolib.DEBUG = DEBUG
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
    caption = 'console',
    direction = 'vertical'
  })
  local console_frame = player.gui.top.console_frame
  console_frame.add({
    type = 'textfield',
    name = 'command'
  })
  console_frame.add({
    type = 'flow',
    name = 'button_flow',
    direction = 'horizontal'
  })
  console_frame.button_flow.add({
    type = 'button',
    name = 'submit',
    caption = 'submit'
  })
  if debug then
    console_frame.button_flow.add({
      type = 'button',
      name = 'reset',
      caption = 'reset'
    })
  else
    console_frame.button_flow.add({
      type = 'button',
      name = 'clear',
      caption = 'clear'
    })
  end
  console_frame.button_flow.add({
    type = 'button',
    name = 'close',
    caption = 'close'
  })
  return script.on_event(defines.events.on_gui_click, function(event)
    player = game.players[event.player_index]
    console_frame = player.gui.top.console_frame
    if event.element == console_frame.button_flow.submit then
      remote.call('blumisc', 'command_run', player)
    elseif event.element == console_frame.button_flow.close then
      remote.call('blumisc', 'destroy_gui', player)
    elseif event.element == console_frame.button_flow.reset then
      remote.call('blumisc', 'destroy_gui', player)
      remote.call('blumisc', 'make_gui', player)
    elseif event.element == console_frame.button_flow.clear then
      console_frame.command.text = ''
    end
    if DEBUG then
      return player.print("click -> " .. tostring(ahtolib.gui_tostring(event.element)))
    end
  end)
end
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
return script.on_init(function()
  local _list_0 = game.players
  for _index_0 = 1, #_list_0 do
    local player = _list_0[_index_0]
    make_gui(player)
  end
end)
