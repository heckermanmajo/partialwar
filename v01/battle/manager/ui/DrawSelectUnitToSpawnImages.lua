local DrawSelectUnitToSpawnImages = {}
local UnitTypes = require("battle/data/unit_types")

--- This function draws the icon of a unit at a specific position.
--- @param x number
--- @param y number
--- @param unitType BattleUnitType
function draw_unit_icon(x,y, unitType, name)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("1",            x, y)
    love.graphics.print(name,     x, y)
    love.graphics.print("Cost: "..unitType.cost,     x, y+20)
    love.graphics.print("Batch: "..unitType.batch_type,  x, y+40)
    unitType:draw_icon(    x, y+60,0.5, true)
end

--- This function draws the infos about the different unit-types you can spawn.
--- you select the units by 1-0 keys of the keyboard.
--- @see SpawnUnitsViaNumberKeys.lua
--- @param Battle Battle
function DrawSelectUnitToSpawnImages.draw(Battle)
  if Battle.currently_selected_chunk ~= nil then
    -- rectangle for the unit info at the bottom
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle("fill", 0, love.graphics.getHeight() - 200, love.graphics.getWidth() - 400, 200)


    local y = love.graphics.getHeight() - 190
    local x = 30

    for name, unitType in pairs(UnitTypes) do
      draw_unit_icon(x, y, unitType, name)
      x = x + 120
    end


    love.graphics.setColor(1, 1, 1)
  end
end

return DrawSelectUnitToSpawnImages