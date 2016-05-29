local std = require('std._base')
local ahto = { }
ahto.DEBUG = false
ahto.debug = function(player, string)
  if player == nil then
    player = game.player
  end
  if ahto.DEBUG then
    return player.print(string)
  end
end
ahto.gui_tostring = function(top_element)
  local elements = { }
  if top_element == nil then
    return '[nil-value "element"]'
  elseif not top_element.valid then
    return '[invalid element]'
  end
  local i = top_element
  while i ~= nil do
    if i.name ~= '' then
      elements[#elements + 1] = i.name
    else
      elements[#elements + 1] = '[root]'
    end
    i = i.parent
  end
  do
    local _accum_0 = { }
    local _len_0 = 1
    local _max_0 = 1
    for _index_0 = #elements, _max_0 < 0 and #elements + _max_0 or _max_0, -1 do
      i = elements[_index_0]
      _accum_0[_len_0] = std.tostring(i)
      _len_0 = _len_0 + 1
    end
    elements = _accum_0
  end
  local string_ = table.concat(elements, '/')
  return string_
end
ahto.table_extend = function(table1, table2, destructive)
  if destructive == nil then
    destructive = false
  end
  local new_table = table1
  if not destructive then
    new_table = std.table.clone(table1)
  end
  for _index_0 = 1, #table2 do
    local i = table2[_index_0]
    new_table[#new_table + 1] = i
  end
  return new_table
end
ahto.element_children = function(element, recursive)
  if recursive == nil then
    recursive = true
  end
  local children = { }
  local _list_0 = element.children_names
  for _index_0 = 1, #_list_0 do
    local child_name = _list_0[_index_0]
    children[#children + 1] = element[child_name]
  end
  if recursive then
    for _index_0 = 1, #children do
      local child = children[_index_0]
      local children_of_child = ahto.element_children(child)
      ahto.table_extend(children, children_of_child, true)
    end
  end
  return children
end
return ahto
