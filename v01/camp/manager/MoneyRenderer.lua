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

  --set color white-gray
  love.graphics.setColor(0.9, 0.9, 0.9, 1)
  love.graphics.print("Money: " .. camp.factions.player.money .."  / + "..player_income, 10, 10)
  love.graphics.print("Money-enemy: " .. camp.factions.enemy.money .."  / + "..enemy_income, 10, 25)
  -- set fot color to white
  love.graphics.setColor(1, 1, 1, 1)

end


return MoneyRenderer