local ArmySpawner = {}

---@param camp Camp
function ArmySpawner.spawn_armies(camp)

  -- algo: spawn one army on a factory
  -- looking for a factory by random

  local player_placed = false
  local enemy_placed = false

  local enemy_start_armies = 6

  while (not enemy_placed) or (not player_placed) do

    local rand_x = love.math.random(0, 10)
    local rand_y = love.math.random(0, 10)

    local tile = camp.tile_map[rand_y][rand_x]

    if tile.type == "factory" and tile.owner == nil then

      if not player_placed then
        local command_points = 100
        local army = Army.new(camp.factions.player, command_points)
        tile.army = army
        tile.owner = camp.factions.player
        player_placed = true
        print("Spawned player army with " .. command_points .. " command points")
      else
        local command_points = 100
        local army = Army.new(camp.factions.enemy, command_points)
        tile.army = army
        tile.owner = camp.factions.enemy
        enemy_start_armies = enemy_start_armies - 1
        if enemy_start_armies == 0 then
          enemy_placed = true
        end
        print("Spawned enemy army with " .. command_points .. " command points")
      end

    end

  end

  goto end_of_function


  for _, tile in ipairs(camp.tiles) do

    local player_faction = camp.factions.player
    local enemy_faction = camp.factions.enemy

    --print("Spawning army:" .. tile.x .. " " .. tile.y)
    if tile.is_passable then

      local command_points = math.floor(love.math.random(1, 40)) * 100
      local army = Army.new(player_faction, command_points)
      tile.army = army
      tile.owner = player_faction

      print("Spawned army with " .. command_points .. " command points")

    end

  end


  ::end_of_function::

end

return ArmySpawner

