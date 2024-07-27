local DrawSelectedCommandGroupsOutline = {}

local blue_flag = love.graphics.newImage("battle/res/blue_flag.png")
local red_flag = love.graphics.newImage("battle/res/red_flag.png")

--- Draw the outline of the selected command groups.
--- @param Battle Battle
function DrawSelectedCommandGroupsOutline.draw(Battle)

  -- draw the flags at the center of the command groups
  for i, command_group in ipairs(Battle.control_groups) do
    if command_group.faction == Battle.factions.player then
      love.graphics.draw(
        blue_flag,
        command_group.center_x + Battle.camera_x_position,
        command_group.center_y + Battle.camera_y_position,
        0,
        1,
        1,
        16,
        16
      )
    end

    if command_group.faction == Battle.factions.enemy then
      love.graphics.draw(
        red_flag,
        command_group.center_x + Battle.camera_x_position,
        command_group.center_y + Battle.camera_y_position,
        0,
        1,
        1,
        16,
        16
      )
    end
  end

  if Battle.currently_selected_control_groups == nil then return end
  if #Battle.currently_selected_control_groups == 0 then return end

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

    -- draw a red rect around the target chunk
    if command_group.target_chunk then
      love.graphics.setColor(1, 0, 0)
      love.graphics.rectangle(
        "line",
        command_group.target_chunk.x + Battle.camera_x_position,
        command_group.target_chunk.y + Battle.camera_y_position,
        command_group.target_chunk.size,
        command_group.target_chunk.size
      )
      love.graphics.setColor(1, 1, 1)
    end

    -- draw a read rect around the center of the command group
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle(
      "fill",
      command_group.center_x + Battle.camera_x_position,
      command_group.center_y + Battle.camera_y_position,
      30,
      30
    )

    love.graphics.setColor(1, 1, 1)

  end

end

return DrawSelectedCommandGroupsOutline