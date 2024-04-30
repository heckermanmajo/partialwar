local UnitTypes = require("battle/data/unit_types")

local ChunkSpawnerAndUnitController = {}

local currently_selected_chunk = nil

local last_spawn_cool_down = 0

--- This function spawns units into the currently selected chunk.
local function spawn_units_into_chunk()

  assert(currently_selected_chunk, "currently_selected_chunk is nil")

  if love.keyboard.isDown("1") then

    -- todo spawn a new control-group that
    --     has this chunk as its first command chunk
    --     it will by spawned at the left side of the map, so its
    --     has the shortest way

    local control_group = ControlGroup.new()

    for i = 1, 10 do
      local rand_x = math.random(0, Battle.chunk_size)
      local rand_y = math.random(0, Battle.chunk_size)
      local unit = BattleUnit.new(
        currently_selected_chunk.x + rand_x - UnitTypes.Spearman.size,
        currently_selected_chunk.y + rand_y - UnitTypes.Spearman.size,
        UnitTypes.Spearman,
        Battle.factions.player
      )
      unit.control_group = control_group
      table.insert(control_group.units, unit)
      unit.control_group = control_group
    end

    last_spawn_cool_down = 1

  end

end

--- This function draws the infos about the different unit-types you can spawn.
--- you select the units by 1-0.
local function draw_create_unit_info_ui()

  -- reactangle for the unit info at the bottom
  love.graphics.setColor(0.5, 0.5, 0.5)
  love.graphics.rectangle("fill", 0, love.graphics.getHeight() - 200, love.graphics.getWidth() - 400, 200)

  -- the 1 key spot
  love.graphics.setColor(1, 1, 1)
  love.graphics.print("1", 10, love.graphics.getHeight() - 190)
  love.graphics.print("Spearman", 30, love.graphics.getHeight() - 190)
  love.graphics.print("Cost: 10", 30, love.graphics.getHeight() - 170)
  love.graphics.print("Health: 100", 30, love.graphics.getHeight() - 150)

  -- the 2 key spot
  love.graphics.setColor(1, 1, 1)
  love.graphics.print("2", 10, love.graphics.getHeight() - 130 + 20)
  love.graphics.print("Archer", 30, love.graphics.getHeight() - 130 + 20)
  love.graphics.print("Cost: 20", 30, love.graphics.getHeight() - 110 + 20)
  love.graphics.print("Health: 50", 30, love.graphics.getHeight() - 90 + 20)

  love.graphics.setColor(1, 1, 1)

end

--- @param Battle Battle
function ChunkSpawnerAndUnitController.select_unit(Battle)

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
          print("Selected unit")
          return
        end
      end
    end
  end

end

--- @param Battle Battle
function ChunkSpawnerAndUnitController.update(Battle, dt)

  local got_left_click = love.mouse.isDown(2)

  if got_left_click then

    local x, y = love.mouse.getPosition()
    local real_x = x - Battle.camera_x_position
    local real_y = y - Battle.camera_y_position

    local over_minimap = (
      x > love.graphics.getWidth() - 400 and
        y > love.graphics.getHeight() - 400
    )
    if over_minimap then
      return
    end

    if real_x < 0 or real_y < 0 then
      currently_selected_chunk = nil
      return
    end
    if real_x > Battle.world_width or real_y > Battle.world_height then
      currently_selected_chunk = nil
      return
    end
    local real_chunk_x = math.floor(real_x / Battle.chunk_size) * Battle.chunk_size
    local real_chunk_y = math.floor(real_y / Battle.chunk_size) * Battle.chunk_size

    assert(Battle.chunk_map[real_chunk_x], "Battle.chunk_map[real_chunk_x] is nil at x: " .. real_chunk_x)
    assert(Battle.chunk_map[real_chunk_x][real_chunk_y], "Battle.chunk_map[real_chunk_x][real_chunk_y] is nil at x: " .. real_chunk_x .. " y: " .. real_chunk_y)
    local clicked_chunk = Battle.chunk_map[real_chunk_x][real_chunk_y]

    currently_selected_chunk = clicked_chunk

  end

  local got_right_click = love.mouse.isDown(1)

  if currently_selected_chunk and got_right_click then
    currently_selected_chunk = nil
  end

  if currently_selected_chunk and last_spawn_cool_down == 0 then
    spawn_units_into_chunk()
  end

  if last_spawn_cool_down > 0 then
    last_spawn_cool_down = last_spawn_cool_down - dt
    if last_spawn_cool_down < 0 then
      last_spawn_cool_down = 0
    end
  end

  ChunkSpawnerAndUnitController.select_unit(Battle)

end



function ChunkSpawnerAndUnitController.draw()

  if currently_selected_chunk then
    -- yellow rectangle around the selected chunk
    love.graphics.setColor(1, 1, 0)
    love.graphics.rectangle("line", currently_selected_chunk.x + Battle.camera_x_position, currently_selected_chunk.y + Battle.camera_y_position, currently_selected_chunk.size, currently_selected_chunk.size)


    -- make the line thicker
    love.graphics.setLineWidth(2)
    -- draw the chunk border
    love.graphics.rectangle("line", currently_selected_chunk.x + Battle.camera_x_position, currently_selected_chunk.y + Battle.camera_y_position, currently_selected_chunk.size, currently_selected_chunk.size)
    love.graphics.setLineWidth(1)

    love.graphics.setColor(1, 1, 1)

    draw_create_unit_info_ui()

  end

end



return ChunkSpawnerAndUnitController