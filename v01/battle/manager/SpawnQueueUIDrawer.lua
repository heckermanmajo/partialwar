--- SpawnQueueUIDrawer draws the spawn queue of the player and the enemy
--- at the top of the screen.
local SpawnQueueUIDrawer = {}

--- @param queue table
--- @param ypos number
--- @param isPlayer boolean
local function drawIcons(queue, ypos, isPlayer)
  for i, entry in ipairs(queue) do
    local unit_type = entry.unit_type
    assert(unit_type, "unit_type is nil")
    local scale = 0.5
    local x_pos = 200 + i * 40
    local y_pos = ypos
    unit_type:draw_icon(x_pos, y_pos, scale, isPlayer)
  end
end

--- draw the icon for each spawn queue entry
--- from left to right
--- @param Battle Battle
function SpawnQueueUIDrawer.draw(Battle)
  drawIcons(Battle.player_spawn_queue, 20, true)
  drawIcons(Battle.enemy_spawn_queue, 60, false)
end

return SpawnQueueUIDrawer
