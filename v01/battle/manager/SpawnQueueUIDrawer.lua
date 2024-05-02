local SpawnQueueUIDrawer = {}


--- @param Battle Battle
function SpawnQueueUIDrawer.draw(Battle)


  --- draw the icon for each spawn queue entry
  --- from left to right

  for i, entry in ipairs(Battle.player_spawn_queue) do
    local unit_type = entry.unit_type
    assert(unit_type, "unit_type is nil")
    local scale = 0.5
    local x_pos = 200 + i * 40
    local y_pos = 20
    local is_player = true
    unit_type:draw_icon(x_pos, y_pos, scale, is_player)
  end

  for i, entry in ipairs(Battle.enemy_spawn_queue) do
    local unit_type = entry.unit_type
    assert(unit_type, "unit_type is nil")
    local scale = 0.5
    local x_pos = 200 + i * 40
    local y_pos = 60
    local is_player = false
    unit_type:draw_icon(x_pos, y_pos, scale, is_player)
  end


end

return SpawnQueueUIDrawer
