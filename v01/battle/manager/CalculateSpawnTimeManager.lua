local CalculateSpawnTimeManager = {}


--- @param Battle Battle
--- @param dt number
--- todo: dont do this every frame ...
function CalculateSpawnTimeManager.update(Battle, dt)

  local my_checkpoints = 0
  local enemy_checkpoints = 0

  for _, chunk in ipairs(Battle.chunks) do
    if chunk.is_checkpoint then
      if chunk.current_owner == Battle.factions.player then
        my_checkpoints = my_checkpoints + 1
      end
      if chunk.current_owner == Battle.factions.enemy then
        enemy_checkpoints = enemy_checkpoints + 1
      end
    end

  end

  if my_checkpoints == 0 and enemy_checkpoints == 0 then
    Battle.player_spawn_time = 5
    Battle.enemy_spawn_time = 5
    return
  end

  local player_ratio = enemy_checkpoints / (my_checkpoints + enemy_checkpoints)

  local default_spawn_time = 5
  local player_spawn_time = default_spawn_time * player_ratio
  local enemy_spawn_time = default_spawn_time * (1 - player_ratio)

  Battle.player_spawn_time = player_spawn_time
  Battle.enemy_spawn_time = enemy_spawn_time

  Battle.player_check_points = my_checkpoints
  Battle.enemy_check_points = enemy_checkpoints

end

return CalculateSpawnTimeManager