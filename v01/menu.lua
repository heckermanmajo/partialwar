-- Menu: allows to draw menu stuff in the game
local Menu = {}

Menu.tileset = love.graphics.newImage("res/menu.png")
Menu.background = love.graphics.newImage("res/background.png")
Menu.button = love.graphics.newImage("res/button.png")
Menu.mouse_1 = love.image.newImageData("res/m1.png")
Menu.mouse_2 = love.image.newImageData("res/m2.png")
Menu.mouse_1_cursor = love.mouse.newCursor(Menu.mouse_1, 0, 0)
Menu.mouse_2_cursor = love.mouse.newCursor(Menu.mouse_2, 0, 0)
Menu.font = love.graphics.newFont("res/font.ttf", 22)
Menu.menu_sound = love.audio.newSource("res/sound_1.ogg", "stream")
Menu.menu_sound:setVolume(0.3)
Menu.march_sound = love.audio.newSource("res/march.ogg", "stream")
-- make march sound quieter
Menu.march_sound:setVolume(0.5)
Menu.bell_sound = love.audio.newSource("res/bell.wav", "stream")
Menu.bell_sound:setVolume(0.2)
Menu.get_burg_sound = love.audio.newSource("res/get_burg.mp3", "stream")
Menu.get_ore_sound = love.audio.newSource("res/get_ore.mp3", "stream")
Menu.get_ore_sound:setVolume(1.5)

Menu.draw_background_brown = function(x,y,w,h)
  -- color white
  love.graphics.setColor(255 / 255, 255 / 255, 255 / 255)
  local quad = love.graphics.newQuad(73, 81, 200-73, 209-81, Menu.tileset:getDimensions())
  love.graphics.draw(Menu.tileset, quad, x, y, 0, w/200, h/209)
end

Menu.draw_background_gray = function(x,y,w,h)
  -- color white
  love.graphics.setColor(255 / 255, 255 / 255, 255 / 255)
  local quad = love.graphics.newQuad(208, 81, 332, 209, Menu.tileset:getDimensions())
  love.graphics.draw(Menu.background, quad, x, y, 0, w/332, h/209)
end

Menu.draw_button = function(x, y, width, height, text)
  -- Calculate center position for text
  local font = Menu.font
  local text_width = font:getWidth(text)
  local text_height = font:getHeight(text)

  local image_height = Menu.button:getHeight()
  local image_width = Menu.button:getWidth()

  -- Position to draw text
  local text_x = x + (width - text_width) / 2
  local text_y = y + (height - text_height) / 2 - 5

  -- Sensitivity for button hover
  local mouseX, mouseY = love.mouse.getX(), love.mouse.getY()
  local hovering = mouseX >= x and mouseX <= x + width and mouseY >= y and mouseY <= y + height

  -- If the mouse cursor is hovering over the button, set transparency.
  if hovering then
    love.graphics.setColor(255 / 255, 255 / 255, 255 / 255, 0.8) -- 80% opacity
  else
    love.graphics.setColor(255 / 255, 255 / 255, 255 / 255, 1) -- Full opacity
  end

  --love.graphics.draw(Menu.button, x, y, 0, width / 200, height / 50)
  -- draw the image so that the whole button is covered
  love.graphics.draw(Menu.button, x, y, 0, width / image_width, height / image_height)
  love.graphics.setColor(0, 0, 0, 1) -- Set color for the text
  if hovering then-- color white
    love.graphics.setColor(255 / 255, 255 / 255, 255 / 255)
  end
  love.graphics.print(text, text_x, text_y)
end

return Menu

