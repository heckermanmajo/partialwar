local IncomeDisplayManager = {}



--- @param Camp Camp
function IncomeDisplayManager.draw(Camp)

  local factory_income = 0
  local minerals_income = 0
  local fields_income = 0

  for _, tile in ipairs(Camp.tiles) do
    if tile.owner == Camp.factions.player then
      if tile.type == "factory" then
        factory_income = factory_income + Camp.money_per_factory
      end
      if tile.type == "minerals" then
        minerals_income = minerals_income + Camp.money_per_minerals
      end
      if tile.type == "fields" then
        fields_income = fields_income + Camp.money_per_tile
      end
    end
  end

  local all_income = factory_income + minerals_income + fields_income
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print("Income: " .. all_income, 10, 150)
  love.graphics.print("Factory income: " .. factory_income, 10, 170)
  love.graphics.print("Minerals income: " .. minerals_income, 10, 190)
  love.graphics.print("Fields income: " .. fields_income, 10, 210)

  local all_armies = 0
  local all_command_points = 0
  for _, tile in ipairs(Camp.tiles) do
    if tile.army and tile.owner == Camp.factions.player then
      all_armies = all_armies + 1
      all_command_points = all_command_points + tile.army.command_points
    end
  end

  love.graphics.print("Armies: " .. all_armies, 10, 230)
  love.graphics.print("Command points: " .. all_command_points, 10, 250)


end


return IncomeDisplayManager