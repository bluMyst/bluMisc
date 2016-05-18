return script.on_load(function()
  local std = require('std._base')
  local console_frame
  local command_run
  command_run = function(command)
    if command == nil then
      command = console_frame.command.text
    end
    local result_string = std.tostring(loadstring(command)())
    result_string = ">>> " .. tostring(result_string)
    game.local_player.print(result_string)
    console_frame.command.text = ''
  end
  local make_gui
  make_gui = function()
    game.local_player.gui.top.add({
      type = 'frame',
      name = 'console-frame',
      caption = 'console'
    })
    console_frame = game.local_player.gui.top.console_frame
    console_frame.add({
      type = 'textfield',
      name = 'command'
    })
    console_frame.add({
      type = 'button',
      name = 'submit',
      caption = 'submit'
    })
    console_frame.add({
      type = 'button',
      name = 'close',
      caption = 'close'
    })
    script.on_event(defines.on_gui_click, function(element, player_index)
      if element == console_frame.submit then
        return command_run()
      elseif element == console_frame.close then
        return destroy_gui()
      end
    end)
    return script.on_event(defines.on_tick, function()
      local command = console_frame.command.text
      if command:find('\n' ~= nil) then
        return command_run()
      end
    end)
  end
  local destroy_gui
  destroy_gui = function()
    script.on_event(defines.on_gui_click, nil)
    script.on_event(defines.on_tick, nil)
    return console_frame.destroy()
  end
  return make_gui()
end)
