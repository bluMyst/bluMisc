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
return ahtolib
