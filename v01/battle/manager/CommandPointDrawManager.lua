local SpawnManager = require("battle/manager/SpawnManager")

local CommandPointDrawManager = {}

--- @param Battle Battle
function CommandPointDrawManager.draw(Battle)
  local player = Battle.factions.player
  local enemy = Battle.factions.enemy

  local time_til_next_command = SpawnManager.time_until_next_spawn

  -- make a gray rectangle as background
  love.graphics.setColor(255/255, 255/255, 255/255)
  love.graphics.rectangle("fill", 0, 100, 200, 130)

  love.graphics.setColor(player.color)
  love.graphics.print("Player: " .. player.command_points .. "( SPAWNTIME: ".. Battle.player_spawn_time ..")", 10, 110)

  -- make a gray rectangle as background
  love.graphics.setColor(enemy.color)
  love.graphics.print("Enemy: " .. enemy.command_points .. "( SPAWNTIME: ".. Battle.enemy_spawn_time ..")", 10, 130)

  -- draw the checkpoints
  local my_checkpoints = Battle.player_check_points
  local enemy_checkpoints = Battle.enemy_check_points

  -- my number blue , enemy number red
  love.graphics.setColor(player.color)
  love.graphics.print("My Checkpoints: " .. my_checkpoints, 10, 150)
  love.graphics.setColor(enemy.color)
  love.graphics.print("Enemy Checkpoints: " .. enemy_checkpoints, 10, 170)

  -- time till next spawn
  love.graphics.setColor(player.color)
  love.graphics.print("Next spawn in : " .. Battle.player_time_since_last_spawn, 10, 190)
  love.graphics.setColor(enemy.color)
  love.graphics.print("Next spawn in :  " .. Battle.enemy_time_since_last_spawn, 10, 210)

  -- set back to white
  love.graphics.setColor(255/255, 255/255, 255/255)
end

return CommandPointDrawManager