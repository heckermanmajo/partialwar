local SpawnManager = {}
local UnitTypes = require("battle/data/unit_types")

SpawnManager.time_until_next_spawn = 0


--- @param unit_type BattleUnitType
--- @param faction BattleFaction
--- @param Battle Battle
local function spawn_batch(unit_type, faction, Battle)
  local used_cost = 0
  local batch_size = unit_type.batch_type
  for i = 1, batch_size do
    used_cost = used_cost + unit_type.cost
    if faction.command_points < used_cost then
      break
    end
    local spawn_max_x = Battle.world_width / 4
    local x = math.random(0, spawn_max_x)
    local y = math.random(0, Battle.world_height)
    BattleUnit.new(x, y, unit_type, faction)
    print("Spawned " .. unit_type.name .. " at " .. x .. ", " .. y)
  end
  return used_cost

end


--- @param Battle Battle
function SpawnManager.update(Battle, dt)

  if SpawnManager.time_until_next_spawn > 0 then
    SpawnManager.time_until_next_spawn = SpawnManager.time_until_next_spawn - dt
    if SpawnManager.time_until_next_spawn < 0 then
      SpawnManager.time_until_next_spawn = 0
    end
    return
  end

  local player_faction = Battle.factions.player
  assert(player_faction, "Player faction not found")
  

  if love.keyboard.isDown("1") then

    local used_cost = spawn_batch(UnitTypes.Spearman, player_faction, Battle)

    SpawnManager.time_until_next_spawn = Battle.spawn_delay
    Battle.factions.player.command_points = Battle.factions.player.command_points - used_cost

  end

  if love.keyboard.isDown("2") and Battle.config.player_army_level >= 2 then

    local used_cost = spawn_batch(UnitTypes.Bowman, player_faction, Battle)

    SpawnManager.time_until_next_spawn = Battle.spawn_delay
    Battle.factions.player.command_points = Battle.factions.player.command_points - used_cost

  end

  if love.keyboard.isDown("3") and Battle.config.player_army_level >= 3 then

    local used_cost = spawn_batch(UnitTypes.Levy, player_faction, Battle)
    SpawnManager.time_until_next_spawn = Battle.spawn_delay
    Battle.factions.player.command_points = Battle.factions.player.command_points - used_cost

  end

  if love.keyboard.isDown("4") and Battle.config.player_army_level >= 4 then

    local used_cost = spawn_batch(UnitTypes.Swordsman, player_faction, Battle)
    SpawnManager.time_until_next_spawn = Battle.spawn_delay
    Battle.factions.player.command_points = Battle.factions.player.command_points - used_cost

  end

  if love.keyboard.isDown("5") and Battle.config.player_army_level >= 4 then

    local used_cost = spawn_batch(UnitTypes.CrossBowman, player_faction, Battle)
    SpawnManager.time_until_next_spawn = Battle.spawn_delay
    Battle.factions.player.command_points = Battle.factions.player.command_points - used_cost

  end

end

return SpawnManager