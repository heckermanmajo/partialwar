local DrawSelectUnitToSpawnImages = {}
local UnitTypes = require("battle/data/unit_types")

--- This function draws the infos about the different unit-types you can spawn.
--- you select the units by 1-0 keys of the keyboard.
--- @see SpawnUnitsViaNumberKeys.lua
--- @param Battle Battle
function DrawSelectUnitToSpawnImages.draw(Battle)
  if Battle.currently_selected_chunk ~= nil then
    -- rectangle for the unit info at the bottom
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle("fill", 0, love.graphics.getHeight() - 200, love.graphics.getWidth() - 400, 200)

    -- the 1 key spot
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("1", 10, love.graphics.getHeight() - 190)
    love.graphics.print("Spearman", 30, love.graphics.getHeight() - 190)
    love.graphics.print("Cost: 10", 30, love.graphics.getHeight() - 170)
    love.graphics.print("Health: 100", 30, love.graphics.getHeight() - 150)
    UnitTypes.Spearman:draw_icon(30, love.graphics.getHeight() - 130,0.5, true)

    love.graphics.setColor(1, 1, 1)
  end
end

return DrawSelectUnitToSpawnImages