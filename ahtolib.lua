local std = require('std._base')
local ahtolib = { }
ahtolib.DEBUG = false
ahtolib.debug = function(player, string)
  if ahtolib.DEBUG then
    return player.print(string)
  end
end
ahtolib.gui_tostring = function(top_element)
  local elements = { }
  local i = top_element
  while i ~= nil do
    elements[#elements + 1] = i.name
    i = i.parent
  end
  local s = table.concat(std.ireverse(elements), '/')
  return s
end
ahtolib.table_extend = function(table1, table2, destructive)
  if destructive == nil then
    destructive = false
  end
  if not destructive then
    local new_table = std.table.clone(table1)
  else
    local new_table = table1
  end
  for i in table2 do
    new_table[#new_table + 1] = i
  end
  return new_table
end
ahtolib.element_children = function(element, recursive)
  if recursive == nil then
    recursive = true
  end
  local children = { }
  local _list_0 = element.children_names
  for _index_0 = 1, #_list_0 do
    local child_name = _list_0[_index_0]
    children[#children + 1] = element[child_name]
  end
  if not recursive then
    return children
  end
  for _index_0 = 1, #children do
    local child = children[_index_0]
    local children_of_child = ahtolib.element_children(child)
    ahtolib.table_extend(children, children_of_child, true)
  end
end
return ahtolib
