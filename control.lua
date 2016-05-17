game.local_player.gui.top.add({
  type = 'frame',
  name = 'console',
  caption = 'console'
})
game.local_player.gui.top.console.add({
  type = 'textfield',
  name = 'console'
})
return game.local_player.gui.top.console.add({
  type = 'button',
  name = 'console-submit',
  caption = 'submit'
})
