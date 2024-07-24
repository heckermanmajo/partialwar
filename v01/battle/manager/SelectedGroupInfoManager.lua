local SelectedGroupInfoManager = {}

--- @param Battle Battle
function SelectedGroupInfoManager.draw(Battle)

  if Battle.currently_selected_control_groups == nil then return end
  if #Battle.currently_selected_control_groups == 0 then return end

  local first_group = Battle.currently_selected_control_groups[1]

  -- draw this info at the left middle
  local start_Y = 400
  love.graphics.print("Selected Group Info", 10, start_Y)
  love.graphics.print("Units: " .. #first_group.units, 10, start_Y + 20)
  love.graphics.print("Center: " .. first_group.center_x .. ", " .. first_group.center_y, 10, start_Y + 40)
  love.graphics.print("Mode: " .. first_group.mode, 10, start_Y + 60)
  love.graphics.print("Target: " .. (first_group.target_chunk and first_group.target_chunk.x or "nil") .. ", " .. (first_group.target_chunk and first_group.target_chunk.y or "nil"), 10, start_Y + 80)

end

return SelectedGroupInfoManager