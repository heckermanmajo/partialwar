local Menu = require("menu")
require("camp/data")
require("battle/Battle")
require("camp/Camp")


Camp.mode = "battle"

function love.load(arg)

  love.graphics.setFont(Menu.font)

  --- PROFILE CODE START
  --love.profiler = require('profile')
 -- love.profiler.start()
  --- PROFILE CODE END

  -- default cursor
  love.mouse.setCursor(Menu.mouse_2_cursor)

  if arg[1] then
    print("arg[1]: " .. arg[1])
    Camp.mode = arg[1]
  end

  if Camp.mode == "camp" then
    Camp.start()
    return
  elseif Camp.mode == "battle" then
    local config = BattleConfig.new(
      1000,
      1000,
      nil, -- will crash
      nil, -- will crash
      9,
      9
    )
    Battle.start(config)
    return
  end

end

--- PROFILE CODE START
-- generates a report every 100 frames
love.frame = 0
--- PROFILE CODE END


function love.mousepressed(x, y, button)
    -- Use a custom cursor when the left mouse button is pressed.
    if button == 1 then
        love.mouse.setCursor(Menu.mouse_1_cursor)
    end
end

function love.mousereleased(x, y, button)
    -- Go back to the default cursor when the left mouse button is released.
    if button == 1 then
        love.mouse.setCursor(Menu.mouse_2_cursor)
    end
end

function love.update(dt)
  if Camp.mode == "camp" then
    Camp.update(dt)
  else
    Battle.update(dt)
  end

  if love.keyboard.isDown("escape") then
    love.event.quit()
  end

  --- PROFILE CODE START
  --love.frame = love.frame + 1
 -- if love.frame%100 == 0 then
 --   love.report = love.profiler.report(20)
 --   love.profiler.reset()
--  end
  --- PROFILE CODE END

end

function love.draw()

  if Camp.mode == "camp" then
    Camp.draw()
  else
    Battle.draw()
  end


  --- PROFILE CODE START
  --love.graphics.print(love.report or "Please wait...", 0 , 300 )
  --- PROFILE CODE END

end