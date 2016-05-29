std = require 'std._base'

ahto = {}

ahto.DEBUG = false

ahto.debug = (player=game.player, string) ->
    if ahto.DEBUG
        player.print string

ahto.gui_tostring = (top_element) ->
    elements = {}

    if top_element == nil
        return '[nil-value "element"]'
    elseif not top_element.valid
        return '[invalid element]'

    i = top_element
    while i != nil
        elements[#elements+1] = if i.name != '' then i.name else '[root]'
        i = i.parent

    -- reverse elements
    elements = [std.tostring(i) for i in *elements[#elements,1,-1]]

    string_ = table.concat(elements, '/')
    return string_

ahto.table_extend = (table1, table2, destructive=false) ->
    new_table = table1

    if not destructive
        new_table = std.table.clone table1

    for i in *table2
        new_table[#new_table+1] = i

    return new_table

ahto.element_children = (element, recursive=true) ->
    children = {}

    for child_name in *element.children_names
        children[#children+1] = element[child_name]

    if recursive
        for child in *children
            children_of_child = ahto.element_children(child)
            ahto.table_extend children, children_of_child, true

    return children

return ahto
