local MovingManager = {}

--- @param Battle Battle
function MovingManager.move(Battle, dt)

  for _, _u in ipairs(Battle.units) do

    --- @type BattleUnit
    local u = _u

    if type(u.last_push) == "nil" then
      u.last_push = 0
    end

    if u.last_push > 0 then
      u.last_push = u.last_push - dt
      goto continue
    end

    u.x = u.x + u.x_velocity / 60
    u.y = u.y + u.y_velocity / 60

    u.last_push = love.math.random(1, 100) / 100

    ::continue::

  end

end

return MovingManager