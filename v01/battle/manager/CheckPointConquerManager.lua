--- Checkpoint can be conquered by units on the chunk
--- changes in the checkpoint ratio of player and enemy
--- will change the spawn time of units
---> value for spawn time per faction needed ...

local CheckPointConquerManager = {}


--- @param Battle Battle
--- @param dt number
function CheckPointConquerManager.update(Battle, dt)

  -- todo: dont do this every frame ...
  for _, chunk in ipairs(Battle.chunks) do
    if chunk.is_checkpoint then
      local player_units = 0
      local enemy_units = 0
      for _, unit in ipairs(chunk.units) do
        if unit.faction == Battle.factions.player then
          player_units = player_units + 1
        end
        if unit.faction == Battle.factions.enemy then
          enemy_units = enemy_units + 1
        end
      end

      if chunk.current_owner == Battle.factions.player then
        local any_player_unit = player_units > 0
        local any_enemy_unit = enemy_units > 0
        if not any_player_unit and any_enemy_unit then
          chunk.current_owner = Battle.factions.enemy
        end

      end

      if chunk.current_owner == Battle.factions.enemy then
        local any_player_unit = player_units > 0
        local any_enemy_unit = enemy_units > 0
        if not any_enemy_unit and any_player_unit then
          chunk.current_owner = Battle.factions.player
        end
      end

      if chunk.current_owner == nil then
        if player_units > enemy_units then
          chunk.current_owner = Battle.factions.player
        end
        if enemy_units > player_units then
          chunk.current_owner = Battle.factions.enemy
        end
      end

    end

  end


end



return CheckPointConquerManager