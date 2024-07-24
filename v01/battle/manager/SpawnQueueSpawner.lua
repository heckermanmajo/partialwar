--- SpawnQueueSpawner module
--- Spawns units from the spawn queue into the battle-field.
--- Both: for the player and the enemy faction.
local SpawnQueueSpawner = {}

--- Spawns units from the spawn queue or a unit based on the given parameters.
--- @param spawn_queue table - the spawn queue
--- @param time_until_next_spawn number - the time since the last spawn
--- @param faction BattleFaction - the faction
--- @param is_enemy boolean - is the faction the enemy?
local function spawn_from_queue(spawn_queue, time_until_next_spawn, faction, is_enemy, dt)
  local has_batch_to_spawn = #spawn_queue > 0

  if has_batch_to_spawn then
    local entry = spawn_queue[1]
    --local spawn_time_needed = entry.unit_type.spawn_time

    if time_until_next_spawn <= 0 then

      local target_chunk = entry.target_chunk
      local unit_type = entry.unit_type

      for j = 1, unit_type.number_of_command_groups do
        local control_group = ControlGroup.new()
        local batch_size = unit_type.batch_type

        for i = 1, batch_size do
          local rand_x = math.random(0, Battle.chunk_size)
          local rand_y = math.random(0, Battle.chunk_size)

          local start_position = rand_x - unit_type.size
          if is_enemy then
            start_position = Battle.world_width - rand_x - unit_type.size
          end

          local unit = BattleUnit.new( start_position, target_chunk.y + rand_y + unit_type.size, unit_type, faction )
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
        control_group.target_chunk = target_chunk
        control_group.mode = "on_the_way"
        control_group.faction = faction

      end

      table.remove(spawn_queue, 1)

      if #spawn_queue > 0 then
        local spawn_time_needed = spawn_queue[1].unit_type.spawn_time
        time_until_next_spawn = spawn_time_needed
      end

    end -- we have spawned a unit

  end

  if time_until_next_spawn > 0 then time_until_next_spawn = time_until_next_spawn - dt end
  if time_until_next_spawn < 0 then time_until_next_spawn = 0 end
  return time_until_next_spawn

end

--- @param Battle Battle
--- @param dt number
function SpawnQueueSpawner.update(Battle, dt)
  Battle.player_time_since_last_spawn = spawn_from_queue(Battle.player_spawn_queue, Battle.player_time_since_last_spawn, Battle.factions.player, false, dt)
  Battle.enemy_time_since_last_spawn = spawn_from_queue(Battle.enemy_spawn_queue, Battle.enemy_time_since_last_spawn, Battle.factions.enemy, true, dt)
end

return SpawnQueueSpawner