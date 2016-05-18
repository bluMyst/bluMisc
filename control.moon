std = require 'std._base'

local console_frame

command_run = (command=console_frame.command.text) ->
    result_string = std.tostring(loadstring(command)())
    result_string = ">>> #{result_string}"
    game.local_player.print(result_string)
    console_frame.command.text = ''

make_gui = ->
    game.local_player.gui.top.add
        type:     'frame'
        name:     'console-frame' -- underscores or dashes?
        caption:  'console'

    console_frame = game.local_player.gui.top.console_frame

    console_frame.add
        type:  'textfield'
        name:  'command'

    console_frame.add
        type:     'button'
        name:     'submit'
        caption:  'submit'

    console_frame.add
        type:     'button'
        name:     'close'
        caption:  'close'

    script.on_event defines.on_gui_click, (element, player_index) ->
        if element == console_frame.submit
            command_run()
        elseif element == console_frame.close
            destroy_gui()

    script.on_event defines.on_tick, ->
        command = console_frame.command.text

        if command\find '\n' != nil
            command_run()

destroy_gui = ->
    script.on_event defines.on_gui_click, nil
    script.on_event defines.on_tick, nil
    console_frame.destroy()

make_gui()
