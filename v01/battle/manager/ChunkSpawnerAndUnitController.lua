--- spawning units and selecting a target for a control group
--- is done with the same clicks, so it makes sense to have these
--- controls in one manager.

local UnitTypes = require("battle/data/unit_types")

local ChunkSpawnerAndUnitController = {}

local currently_selected_chunk = nil

local last_spawn_cool_down = 0

local function spawn_unit_type(
  unit_type,
  faction,
  spawn_time
)


  local control_group = ControlGroup.new()

  local batch_size = unit_type.batch_type

  for i = 1, batch_size do

    local rand_x = math.random(0, Battle.chunk_size)
    local rand_y = math.random(0, Battle.chunk_size)

    local unit = BattleUnit.new(
      rand_x - unit_type.size,
      currently_selected_chunk.y + rand_y - unit_type.size,
      unit_type,
      faction
    )
    unit.control_group = control_group
    table.insert(control_group.units, unit)
    unit.control_group = control_group

  end

  local average_x = 0
  local average_y = 0
  for _, u in ipairs(control_group.units) do
    average_x = average_x + u.x
    average_y = average_y + u.y
  end

  control_group.center_x = average_x / #control_group.units
  control_group.center_y = average_y / #control_group.units

  control_group.target_chunk = currently_selected_chunk
  control_group.mode = "on_the_way"
  control_group.faction = faction

  last_spawn_cool_down = spawn_time

end

--- This function spawns units into the currently selected chunk.
local function spawn_units_into_chunk()

  assert(currently_selected_chunk, "currently_selected_chunk is nil")

  if love.keyboard.isDown("1") then

    if last_spawn_cool_down == 0 then

      -- todo only do this if enough resources are available
      -- todo subtract the cost of the unit from the player resources

      table.insert(
        Battle.player_spawn_queue,
        SpawnQueueEntry.new(
          UnitTypes.Spearman,
          currently_selected_chunk
        )
      )

      last_spawn_cool_down = 0.3

    end

  end

  --[[]if love.keyboard.isDown("2") then

    spawn_unit_type(
      UnitTypes.Bowman,
      Battle.factions.player,
      Battle.player_spawn_time
    )

  end

  if love.keyboard.isDown("3") then

    spawn_unit_type(
      UnitTypes.Levy,
      Battle.factions.player,
      Battle.player_spawn_time
    )

  end

  if love.keyboard.isDown("4") then

    spawn_unit_type(
      UnitTypes.Swordsman,
      Battle.factions.player,
      Battle.player_spawn_time
    )

  end

  if love.keyboard.isDown("5") then

    spawn_unit_type(
      UnitTypes.CrossBowman,
      Battle.factions.player,
      Battle.player_spawn_time
    )

  end
  -]]

  -- we need a fast unit
  -- we need mages
  -- we need a giant
  -- horse warriors

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
  UnitTypes.Spearman:draw_icon(30, love.graphics.getHeight() - 130,0.5, true)

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

end

--- @param Battle Battle
function ChunkSpawnerAndUnitController.update(Battle, dt)

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

  if got_left_click then

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

    if (
      Battle.currently_selected_control_groups ~= nil
        and #Battle.currently_selected_control_groups > 0
    ) then

      for _, control_group in ipairs(Battle.currently_selected_control_groups) do

        control_group.target_chunk = clicked_chunk
        control_group.mode = "on_the_way"
        control_group.last_mode = "idle"

      end

    else

      currently_selected_chunk = clicked_chunk

    end


  end -- end of got_left_click

  local got_right_click = love.mouse.isDown(1)

  -- delete the selected chunk
  if currently_selected_chunk and got_right_click then
    currently_selected_chunk = nil
  end

  -- if a chunk is selected and the spawn cool down is 0
  -- then spawn units into the chunk -> checks for the 1-0 keys and
  -- spawns the units
  if currently_selected_chunk and last_spawn_cool_down == 0 then
    spawn_units_into_chunk()
  end

  -- update the spawn cool down
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