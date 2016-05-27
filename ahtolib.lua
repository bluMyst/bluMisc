local ahtolib = { }
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
