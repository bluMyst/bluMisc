std  = require 'std._base'
ahto = require 'ahtolib'
require 'defines'

-- moonscript doesn't have "a = b = c" syntax
DEBUG = true
ahto.DEBUG = DEBUG

-- {gui_element: {on_click:f, on_asdf:g}}
gui_events = {}

element_on_click = (element, on_click) ->
    element_s = ahto.gui_tostring element
    gui_events[element_s] = on_click: on_click

element_destroy = (element) ->
    element_s = ahto.gui_tostring element
    gui_events[element_s] = nil

    for i in *ahto.element_children element
        gui_events[i] = nil
        -- don't destroy the children because destroying the parent element will
        -- automatically do this for us.

    element.destroy()

gui_click = (event, element=event.element) ->
    -- on_click(event, player)
    player = game.players[event.player_index]
    element_s = ahto.gui_tostring element

    if DEBUG
        player.print "click -> #{element_s}"

        if gui_events[element_s] == nil
            ahto.debug player, "gui_events[#{element_s}] is nil, so set to {}"

    gui_events[element_s] or= {}

    if gui_events[element_s].on_click
        gui_events[element_s].on_click(event, player)
        event_ran = true
    else
        event_ran = false
        ahto.debug player, "Unable to find event for #{element_s}"

    return event_ran

script.on_event defines.events.on_gui_click, gui_click

command_run = (player) ->
    console_frame = player.gui.top.console_frame
    command = console_frame.command.text
    player.print ">>> #{command}"

    -- loadstring('1+1') -> nil
    -- loadstring('return a = 1') -> nil
    -- loadstring('return 1+1') -> function
    command = loadstring("return #{command}") or loadstring(command)
    success, return_ = pcall(command)

    return_s = std.tostring return_
    if not success then return_s = "ERROR: #{return_s}"
    player.print return_s if return_ != nil

make_console_icon = (player) ->
    -- won't look like an icon at first, but should be after styling it to be
    -- tiny
    player.gui.top.add
        type: 'button'
        name: 'open_console'
        caption: '#'
    element_on_click player.gui.top.open_console, (event, player) ->
        remote.call 'blumisc', 'close_console_icon', player
        remote.call 'blumisc', 'make_console', player

close_console_icon = (player) ->
    icon = player.gui.top.open_console
    valid = if icon == nil then 'nil' else std.tostring(icon.valid)
    ahto.debug player, "Destroying open_console button. Valid: #{valid}"
    element_destroy icon

make_console = (player) ->
    -- I checked; it's not possible to add a custom key to a GuiElement.
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

    button_flow = console_frame.button_flow

    button_flow.add
        type:     'button'
        name:     'submit'
        caption:  'submit'
    element_on_click button_flow.submit, (event, player) ->
        -- can't just call it because of weird namespace problem
        remote.call 'blumisc', 'command_run', player
        player.gui.top.console_frame.command.text = ''

    button_flow.add
        type:     'button'
        name:     'clear'
        caption:  'clear'
    element_on_click button_flow.clear, (event, player) ->
        player.gui.top.console_frame.command.text = ''

    button_flow.add
        type:     'button'
        name:     'close'
        caption:  'close'
    element_on_click button_flow.close, (event, player) ->
        remote.call 'blumisc', 'close_console', player
        remote.call 'blumisc', 'make_console_icon' ,player

close_console = (player) ->
    element_destroy player.gui.top.console_frame

remote.add_interface 'blumisc', {
    make_console:        make_console,
    close_console:       close_console,
    make_console_icon:   make_console_icon,
    close_console_icon:  close_console_icon,
    command_run:         command_run}

--script.on_init ->
script.on_event defines.events.on_player_created, (event) ->
    player = game.players[event.player_index]
    if not player.gui.top.open_console and not player.gui.top.console_frame
        make_console_icon player
