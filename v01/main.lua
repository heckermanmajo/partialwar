require("camp/data")
require("battle/Battle")
require("camp/Camp")


function love.load(arg)

  --- PROFILE CODE START
  --love.profiler = require('profile')
 -- love.profiler.start()
  --- PROFILE CODE END


  if arg[1] then
    print("arg[1]: " .. arg[1])
    Camp.mode = arg[1]
  end

  if Camp.mode == "camp" then
    Camp.start()
    return
  elseif Camp.mode == "battle" then
    local config = BattleConfig.new(
      100,
      100,
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