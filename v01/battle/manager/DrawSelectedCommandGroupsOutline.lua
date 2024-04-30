local DrawSelectedCommandGroupsOutline = {}

--- Draw the outline of the selected command groups.
--- @param Battle Battle
function DrawSelectedCommandGroupsOutline.draw(Battle)

  if Battle.currently_selected_control_groups == nil then
    return
  end

  if #Battle.currently_selected_control_groups == 0 then
    return
  end

  for i, command_group in ipairs(Battle.currently_selected_control_groups) do
    love.graphics.setColor(1, 1, 0)
    for _, unit in ipairs(command_group.units) do
      love.graphics.rectangle(
        "line",
        unit.x + Battle.camera_x_position,
        unit.y + Battle.camera_y_position,
        unit.type.size,
        unit.type.size
      )
    end
    love.graphics.setColor(1, 1, 1)
  end

end

return DrawSelectedCommandGroupsOutline