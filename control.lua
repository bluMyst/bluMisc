local std = require('std._base')
local ahto = require('ahtolib')
require('defines')
local DEBUG = false
ahto.DEBUG = DEBUG
local gui_events = { }
local element_on_click
element_on_click = function(element, on_click)
  local element_s = ahto.gui_tostring(element)
  gui_events[element_s] = {
    on_click = on_click
  }
end
local element_destroy
element_destroy = function(element)
  local element_s = ahto.gui_tostring(element)
  gui_events[element_s] = nil
  local _list_0 = ahto.element_children(element)
  for _index_0 = 1, #_list_0 do
    local i = _list_0[_index_0]
    gui_events[i] = nil
  end
  return element.destroy()
end
local gui_click
gui_click = function(event, element)
  if element == nil then
    element = event.element
  end
  local player = game.players[event.player_index]
  local element_s = ahto.gui_tostring(element)
  if DEBUG then
    player.print("click -> " .. tostring(element_s))
    if gui_events[element_s] == nil then
      ahto.debug(player, "gui_events[" .. tostring(element_s) .. "] is nil, so set to {}")
    end
  end
  gui_events[element_s] = gui_events[element_s] or { }
  if gui_events[element_s].on_click then
    gui_events[element_s].on_click(event, player)
    local event_ran = true
  else
    local event_ran = false
    ahto.debug(player, "Unable to find event for " .. tostring(element_s))
  end
  return event_ran
end
script.on_event(defines.events.on_gui_click, gui_click)
local command_run
command_run = function(player)
  local console_frame = player.gui.top.console_frame
  local command = console_frame.command.text
  player.print(">>> " .. tostring(command))
  command = loadstring("return " .. tostring(command)) or loadstring(command)
  local success, return_ = pcall(command)
  local return_s = std.tostring(return_)
  if not success then
    return_s = "ERROR: " .. tostring(return_s)
  end
  if return_ ~= nil then
    return player.print(return_s)
  end
end
local debug_toggle
debug_toggle = function(player)
  DEBUG = not DEBUG
  ahto.DEBUG = DEBUG
  return player.print("debug mode: " .. tostring((function()
    if DEBUG then
      return 'on'
    else
      return 'off'
    end
  end)()))
end
local make_console_icon
make_console_icon = function(player)
  player.gui.top.add({
    type = 'button',
    name = 'open_console',
    caption = '#'
  })
  return element_on_click(player.gui.top.open_console, function(event, player)
    remote.call('blumisc', 'close_console_icon', player)
    return remote.call('blumisc', 'make_console', player)
  end)
end
local close_console_icon
close_console_icon = function(player)
  local icon = player.gui.top.open_console
  local valid
  if icon == nil then
    valid = 'nil'
  else
    valid = std.tostring(icon.valid)
  end
  ahto.debug(player, "Destroying open_console button. Valid: " .. tostring(valid))
  return element_destroy(icon)
end
local make_console
make_console = function(player)
  player.gui.top.add({
    type = 'frame',
    name = 'console_frame',
    caption = 'console',
    direction = 'vertical'
  })
  local console_frame = player.gui.top.console_frame
  console_frame.add({
    type = 'textfield',
    name = 'command',
    style = 'long_textfield_style'
  })
  console_frame.add({
    type = 'flow',
    name = 'button_flow',
    direction = 'horizontal'
  })
  local button_flow = console_frame.button_flow
  button_flow.add({
    type = 'button',
    name = 'submit',
    caption = 'submit'
  })
  element_on_click(button_flow.submit, function(event, player)
    remote.call('blumisc', 'command_run', player)
    player.gui.top.console_frame.command.text = ''
  end)
  button_flow.add({
    type = 'button',
    name = 'clear',
    caption = 'clear'
  })
  element_on_click(button_flow.clear, function(event, player)
    player.gui.top.console_frame.command.text = ''
  end)
  button_flow.add({
    type = 'button',
    name = 'close',
    caption = 'close'
  })
  element_on_click(button_flow.close, function(event, player)
    remote.call('blumisc', 'close_console', player)
    return remote.call('blumisc', 'make_console_icon', player)
  end)
  button_flow.add({
    type = 'button',
    name = 'debug_toggle',
    caption = '!'
  })
  return element_on_click(button_flow.debug_toggle, function(event, player)
    return remote.call('blumisc', 'debug_toggle', player)
  end)
end
local close_console
close_console = function(player)
  return element_destroy(player.gui.top.console_frame)
end
remote.add_interface('blumisc', {
  make_console = make_console,
  close_console = close_console,
  make_console_icon = make_console_icon,
  close_console_icon = close_console_icon,
  make_debug_button = make_debug_button,
  debug_toggle = debug_toggle,
  command_run = command_run
})
return script.on_event(defines.events.on_player_created, function(event)
  local player = game.players[event.player_index]
  if not player.gui.top.open_console and not player.gui.top.console_frame then
    make_console_icon(player)
  end
  if DEBUG and not player.gui.left.debug_toggle then
    return make_debug_button(player)
  end
end)
