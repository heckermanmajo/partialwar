local UnitTypes = require("battle/data/unit_types")
local UnitGroupController = {}
local mouse_down = false
local start_x = 0
local start_y = 0

--- @param Battle Battle
function UnitGroupController.select_unit(Battle)

  local x, y = love.mouse.getPosition()
  local real_x = x - Battle.camera_x_position
  local real_y = y - Battle.camera_y_position

  local left_click = love.mouse.isDown(1)

  if left_click and not mouse_down  and not Battle.mouse_on_minimap() then
    start_x, start_y = real_x, real_y
    mouse_down = true
  elseif not left_click and mouse_down and not Battle.mouse_on_minimap() then
    mouse_down = false
    local end_x, end_y = real_x, real_y
    local selected_units = {}

    local left = math.min(start_x, end_x)
    local right = math.max(start_x, end_x)
    local top = math.min(start_y, end_y)
    local bottom = math.max(start_y, end_y)

    -- Iterate over all units to check if they are in the selection rectangle
    for _, unit in pairs(Battle.units) do
      if unit.faction == Battle.factions.player then
        if unit.x + unit.type.size > left and unit.x < right and unit.y + unit.type.size > top and unit.y < bottom then
          table.insert(selected_units, unit)
        end
      end
    end

    if #selected_units > 0 then
      Battle.currently_selected_control_groups = {}
      for _, unit in ipairs(selected_units) do
        assert(unit.control_group, "u.control_group is nil")
        table.insert(Battle.currently_selected_control_groups, unit.control_group)
      end
    else
      Battle.currently_selected_control_groups = nil
    end

  end

end

--[[
local mouse_down = false
local start_x = 0
local start_y = 0

--- @param Battle Battle
function UnitGroupController.select_unit(Battle)

  local left_click = love.mouse.isDown(1)
  local x, y = love.mouse.getPosition()
  local real_x = x - Battle.camera_x_position
  local real_y = y - Battle.camera_y_position

  if real_x < 0 or real_y < 0 then
    Battle.currently_selected_control_groups = nil
    return
  end
  if real_x > Battle.world_width or real_y > Battle.world_height then
    Battle.currently_selected_control_groups = nil
    return
  end

  local real_chunk_x = math.floor(real_x / Battle.chunk_size) * Battle.chunk_size
  local real_chunk_y = math.floor(real_y / Battle.chunk_size) * Battle.chunk_size

  local chunk = Battle.chunk_map[real_chunk_x][real_chunk_y]

  if left_click then
    local selected_some_unit = false
    for _, u in ipairs(chunk.units) do
      if u.faction == Battle.factions.player then
        -- todo: add a better select ...
        local unit_clicked = (
          real_x > u.x and
            real_x < u.x + u.type.size and
            real_y > u.y and
            real_y < u.y + u.type.size
        )
        if unit_clicked then
          assert(u.control_group, "u.control_group is nil")
          Battle.currently_selected_control_groups = { u.control_group }
          --print("Selected unit")
          selected_some_unit = true
          return
        end
      end
    end

    if not selected_some_unit then
      Battle.currently_selected_control_groups = nil
    end

  end

  if not left_click then
    mouse_down = false
  end

end
]]--
--- @param Battle Battle
function UnitGroupController.update(Battle, dt)

  -- start map control mode on keypress on some selected and t pressed
  do

    local t_pressed = love.keyboard.isDown("t")

    local some_control_group_selected = Battle.currently_selected_control_groups ~= nil

    if t_pressed and some_control_group_selected then
      for _, control_group in ipairs(Battle.currently_selected_control_groups) do
        control_group.mode = "searching"
      end
    end

  end

  local got_left_click = love.mouse.isDown(2)

  if got_left_click and not Battle.mouse_on_minimap() then

    local x, y = love.mouse.getPosition()
    local real_x = x - Battle.camera_x_position
    local real_y = y - Battle.camera_y_position


    -- check if we are over the minimap
    -- if so we dont select a chunk
    do

      local over_minimap = (
        x > love.graphics.getWidth() - 400 and
          y > love.graphics.getHeight() - 400
      )

      if over_minimap then
        return
      end

    end

    if real_x < 0 or real_y < 0 then
      Battle.currently_selected_chunk = nil
      return
    end

    if real_x > Battle.world_width or real_y > Battle.world_height then
      Battle.currently_selected_chunk = nil
      return
    end

    local real_chunk_x = math.floor(real_x / Battle.chunk_size) * Battle.chunk_size
    local real_chunk_y = math.floor(real_y / Battle.chunk_size) * Battle.chunk_size

    assert(Battle.chunk_map[real_chunk_x], "Battle.chunk_map[real_chunk_x] is nil at x: " .. real_chunk_x)
    assert(Battle.chunk_map[real_chunk_x][real_chunk_y], "Battle.chunk_map[real_chunk_x][real_chunk_y] is nil at x: " .. real_chunk_x .. " y: " .. real_chunk_y)
    local clicked_chunk = Battle.chunk_map[real_chunk_x][real_chunk_y]

    -- todo: update, so that groups move in formation ....

    if (
      Battle.currently_selected_control_groups ~= nil
        and #Battle.currently_selected_control_groups > 0
    ) then

      for _, control_group in ipairs(Battle.currently_selected_control_groups) do

        control_group.target_chunk = clicked_chunk
        control_group.walk_target_x = real_x
        control_group.walk_target_y = real_y
        control_group.mode = "on_the_way"
        control_group.last_mode = "idle"

      end

    else

      Battle.currently_selected_chunk = clicked_chunk

    end


  end -- end of got_left_click

  local got_right_click = love.mouse.isDown(1)

  -- delete the selected chunk
  if Battle.currently_selected_chunk and got_right_click then
    Battle.currently_selected_chunk = nil
  end

  UnitGroupController.select_unit(Battle)

end

function UnitGroupController.draw()

  if Battle.currently_selected_chunk then
    -- yellow rectangle around the selected chunk
    love.graphics.setColor(1, 1, 0)
    love.graphics.rectangle("line", Battle.currently_selected_chunk.x + Battle.camera_x_position, Battle.currently_selected_chunk.y + Battle.camera_y_position, Battle.currently_selected_chunk.size, Battle.currently_selected_chunk.size)


    -- make the line thicker
    love.graphics.setLineWidth(2)
    -- draw the chunk border
    love.graphics.rectangle("line", Battle.currently_selected_chunk.x + Battle.camera_x_position, Battle.currently_selected_chunk.y + Battle.camera_y_position, Battle.currently_selected_chunk.size, Battle.currently_selected_chunk.size)
    love.graphics.setLineWidth(1)

    love.graphics.setColor(1, 1, 1)

  end

  -- draw the selection rectangle
  if mouse_down and not Battle.mouse_on_minimap() then
    love.graphics.setColor(1, 1, 1)
    local width = love.mouse.getX() - (start_x + Battle.camera_x_position)
    local height = love.mouse.getY() - (start_y + Battle.camera_y_position)
    love.graphics.rectangle("line",
      start_x + Battle.camera_x_position,
      start_y + Battle.camera_y_position,
      width,
      height
    )
  end

end

return UnitGroupController