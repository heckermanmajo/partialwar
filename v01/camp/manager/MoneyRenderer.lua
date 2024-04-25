local MoneyRenderer = {}


---@param camp Camp
function MoneyRenderer.render_money(camp)

  local enemy_income = 0
  local player_income = 0

  for _, tile in ipairs(camp.tiles) do

    if tile.owner == camp.factions.enemy then
      if tile.type == "factory" then
        enemy_income = enemy_income + camp.money_per_factory
      end
      if tile.type == "minerals" then
        enemy_income = enemy_income + camp.money_per_minerals
      end
      if tile.type == "fields" then
        enemy_income = enemy_income + camp.money_per_tile
      end
    end

    if tile.owner == camp.factions.player then
      if tile.type == "factory" then
        player_income = player_income + camp.money_per_factory
      end
      if tile.type == "minerals" then
        player_income = player_income + camp.money_per_minerals
      end
      if tile.type == "fields" then
        player_income = player_income + camp.money_per_tile
      end
    end

  end

  love.graphics.setColor(1, 1, 1)
  -- make a gray rectangle for the money
  love.graphics.rectangle("fill", 0, 0, 200, 40)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("Money: " .. camp.factions.player.money .."  / + "..player_income, 10, 10)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("Money-enemy: " .. camp.factions.enemy.money .."  / + "..enemy_income, 10, 25)

end


return MoneyRenderer