local SpawnQueueSpawner = {}


local function spawn_unit_type(
  unit_type,
  faction,
  currently_selected_chunk,
  is_enemy
)


  local control_group = ControlGroup.new()

  local batch_size = unit_type.batch_type

  for i = 1, batch_size do

    local rand_x = math.random(0, Battle.chunk_size)
    local rand_y = math.random(0, Battle.chunk_size)

    local start_position = rand_x - unit_type.size
    if is_enemy then
      start_position = Battle.world_width - rand_x - unit_type.size
    end

    local unit = BattleUnit.new(
      start_position,
      currently_selected_chunk.y + rand_y + unit_type.size,
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

end


--- @param Battle Battle
function SpawnQueueSpawner.update(Battle, dt)

  local player_has_batch_to_spawn = #Battle.player_spawn_queue > 0

  if player_has_batch_to_spawn then

    local entry = Battle.player_spawn_queue[1]

    local spawn_time_needed = entry.unit_type.spawn_time

    if Battle.player_time_since_last_spawn > spawn_time_needed then
      Battle.player_time_since_last_spawn = 0
      local target_chunk = entry.target_chunk
      local unit_type = entry.unit_type
      for i = 1, unit_type.number_of_command_groups do
        local is_enemy = false
        spawn_unit_type(unit_type, Battle.factions.player, target_chunk, is_enemy)
      end
      table.remove(Battle.player_spawn_queue, 1)
    end

  end

  local enemy_has_batch_to_spawn = #Battle.enemy_spawn_queue > 0

  if enemy_has_batch_to_spawn then

    local entry = Battle.enemy_spawn_queue[1]

    local spawn_time_needed = entry.unit_type.spawn_time

    if Battle.enemy_time_since_last_spawn > spawn_time_needed then
      Battle.enemy_time_since_last_spawn = 0
      local target_chunk = entry.target_chunk
      local unit_type = entry.unit_type
      for i = 1, unit_type.number_of_command_groups do
        local is_enemy = true
        spawn_unit_type(unit_type, Battle.factions.enemy, target_chunk, is_enemy)
      end
      table.remove(Battle.enemy_spawn_queue, 1)
    end

  end

  Battle.player_time_since_last_spawn = Battle.player_time_since_last_spawn + dt *( 1 + Battle.player_check_points)
  Battle.enemy_time_since_last_spawn = Battle.enemy_time_since_last_spawn + dt *( 1 + Battle.enemy_check_points)

end

return SpawnQueueSpawner