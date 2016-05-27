std     = require 'std._base'
ahtolib = require 'ahtolib'
require 'defines'

-- moonscript doesn't have "a = b = c" syntax
DEBUG = true
ahtolib.DEBUG = DEBUG

command_run = (player) ->
    console_frame = player.gui.top.console_frame
    command = console_frame.command.text
    player.print ">>> #{command}"

    -- loadstring('1+1') -> nil
    -- loadstring('return a = 1') -> nil
    -- loadstring('return 1+1') -> function
    command = loadstring("return #{command}") or loadstring(command)
    success, return_ = pcall(command)

    if success
        player.print std.tostring return_
    else
        player.print "ERROR: #{return_}"

    console_frame.command.text = ''

make_gui = (player) ->
    player.gui.top.add
        type:       'frame'
        name:       'console_frame'
        caption:    'console'
        direction:  'vertical'

    console_frame = player.gui.top.console_frame

    console_frame.add
        type:  'textfield'
        name:  'command'

    console_frame.add
        type:       'flow'
        name:       'button_flow'
        direction:  'horizontal'

    console_frame.button_flow.add
        type:     'button'
        name:     'submit'
        caption:  'submit'

    if debug
        console_frame.button_flow.add
            type:     'button'
            name:     'reset'
            caption:  'reset'
    else
        console_frame.button_flow.add
            type:     'button'
            name:     'clear'
            caption:  'clear'

    console_frame.button_flow.add
        type:     'button'
        name:     'close'
        caption:  'close'

    -- TODO: Run this on_init
    script.on_event defines.events.on_gui_click, (event) ->
        player = game.players[event.player_index]
        console_frame = player.gui.top.console_frame

        if event.element == console_frame.button_flow.submit
            -- can't just call it because of weird namespace problem
            remote.call('blumisc', 'command_run', player)
        elseif event.element == console_frame.button_flow.close
            remote.call('blumisc', 'destroy_gui', player)
        elseif event.element == console_frame.button_flow.reset
            remote.call('blumisc', 'destroy_gui', player)
            remote.call('blumisc', 'make_gui', player)
        elseif event.element == console_frame.button_flow.clear
            console_frame.command.text = ''

        if DEBUG
            player.print "click -> #{ahtolib.gui_tostring(event.element)}"

destroy_gui = (player) ->
    script.on_event defines.events.on_gui_click, nil
    player.gui.top.console_frame.destroy()

remote.add_interface 'blumisc', {
    make_gui:     make_gui,
    destroy_gui:  destroy_gui,
    command_run:  command_run}
--  get: -> {make_gui:make_gui, destroy_gui:destroy_gui}}
-- can't copy object of type function

script.on_init ->
    for player in *game.players
        make_gui player
