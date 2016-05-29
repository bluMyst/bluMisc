local default_gui = data.raw["gui-style"].default
default_gui.no_padding_frame_style = {
  type = "frame_style",
  parent = "frame_style",
  top_padding = 0,
  right_padding = 0,
  bottom_padding = 0,
  left_padding = 0
}
default_gui.long_textfield_style = {
  type = "textfield_style",
  parent = "textfield_style",
  minimal_width = "700",
  maximal_width = "1400"
}
