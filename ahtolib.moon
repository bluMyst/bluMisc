ahtolib = {}

ahtolib.gui_tostring = (top_element) ->
    elements = {}
    i = top_element

    while i != nil
        elements[#elements+1] = i.name
        i = i.parent

    s = table.concat(std.ireverse(elements), '/')

    return s

return ahtolib
