local SpawnManager = require("battle/manager/SpawnManager")

local CommandPointDrawManager = {}

--- @param Battle Battle
function CommandPointDrawManager.draw(Battle)
  local player = Battle.factions.player
  local enemy = Battle.factions.enemy

  local time_til_next_command = SpawnManager.time_until_next_spawn

  -- make a gray rectangle as background
  love.graphics.setColor(255/255, 255/255, 255/255)
  love.graphics.rectangle("fill", 0, 100, 200, 60)

  love.graphics.setColor(player.color)
  love.graphics.print("Player: " .. player.command_points .. "( til next spawn: "..time_til_next_command ..")", 10, 110)

  -- make a gray rectangle as background
  love.graphics.setColor(enemy.color)
  love.graphics.print("Enemy: " .. enemy.command_points, 10, 130)


  -- set back to white
  love.graphics.setColor(255/255, 255/255, 255/255)
end

return CommandPointDrawManager