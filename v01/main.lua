require("camp/data")
require("battle/Battle")
require("camp/Camp")


function love.load(arg)

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

function love.update(dt)

  if Camp.mode == "camp" then
    Camp.update(dt)
  else
    Battle.update(dt)
  end

  if love.keyboard.isDown("escape") then
    love.event.quit()
  end

end

function love.draw()

  if Camp.mode == "camp" then
    Camp.draw()
  else
    Battle.draw()
  end

end