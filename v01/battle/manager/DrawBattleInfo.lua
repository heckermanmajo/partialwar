local DrawBattleInfo = {}


---@param battle Battle
function DrawBattleInfo.draw_battle_info(battle)

  local player_units = 0
  local enemy_units = 0

  for _, unit in ipairs(battle.units) do

    if unit.faction == battle.factions.player then
      player_units = player_units + 1
    end

    if unit.faction == battle.factions.enemy then
      enemy_units = enemy_units + 1
    end


  end

  love.graphics.setColor(1, 1, 1)
  -- make a gray rectangle for the money
  love.graphics.rectangle("fill", 0, 0, 200, 80)
  love.graphics.setColor(0, 0, 0)

  love.graphics.print("Player-Units: " ..player_units, 10, 30)
  love.graphics.print("Enemy-Units: " ..enemy_units, 10, 50)
  -- draw fps here
  love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10)

  love.graphics.setColor(1, 1, 1)

end

return DrawBattleInfo