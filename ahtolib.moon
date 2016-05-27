ahtolib = {}

ahtolib.DEBUG = false

ahtolib.debug = (player, string) ->
    if ahtolib.DEBUG
        player.print string

ahtolib.gui_tostring = (top_element) ->
    elements = {}
    i = top_element

    while i != nil
        elements[#elements+1] = i.name
        i = i.parent

    s = table.concat(std.ireverse(elements), '/')

    return s

return ahtolib
