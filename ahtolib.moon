std = require 'std._base'

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

ahtolib.table_extend = (table1, table2, destructive=false) ->
    if not destructive
        new_table = std.table.clone table1
    else
        new_table = table1

    for i in table2
        new_table[#new_table+1] = i

    return new_table

ahtolib.element_children = (element, recursive=true) ->
    children = {}

    for child_name in *element.children_names
        children[#children+1] = element[child_name]

    if recursive
        for child in *children
            children_of_child = ahtolib.element_children(child)
            ahtolib.table_extend children, children_of_child, true

    return children

return ahtolib
