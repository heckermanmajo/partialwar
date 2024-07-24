local AiUnitSpawnManager = {}
local UnitTypes = require("battle/data/unit_types")

--- @type BattleUnitType[] list of unit types sorted by cost
local types_as_list = {}
for _, unit_type in pairs(UnitTypes) do table.insert(types_as_list, unit_type) end
table.sort(types_as_list, function(a, b) return a.cost < b.cost end)

--- @type BattleUnitType
local cheapest_unit = types_as_list[1]
local smallest_cost = cheapest_unit.cost

local time_to_next_spawn = 0

--- @param Battle Battle
--- @param dt number
function AiUnitSpawnManager.update(Battle, dt)

  if time_to_next_spawn > 0 then
    time_to_next_spawn = time_to_next_spawn - dt
    return
  end

  --TODO this value can be part of a difficulty setting
  time_to_next_spawn = 5

  -- just spawn until command points are empty
  -- or until 10 batches are in spawn queue

  local units_in_spawn_queue = #Battle.enemy_spawn_queue
  local command_points = Battle.factions.enemy.command_points

  if units_in_spawn_queue >= 10 then return end

  if command_points < smallest_cost then
    Battle.factions.enemy.command_points = 0
    return
  end

  -- todo: we can later apply some composition/counter calculations here
  local spawn_try = math.random(1, #types_as_list)
  local unit_batch_to_spawn = types_as_list[spawn_try]

  -- check if we can spawn the selected (random)
  if command_points >= unit_batch_to_spawn.cost then

    -- todo: improve this, since going to a random position makes no sense
    local target_chunk = Battle.chunks[love.math.random(1, #Battle.chunks)]

    local entry = SpawnQueueEntry.new(unit_batch_to_spawn, target_chunk)
    if #Battle.enemy_spawn_queue == 0 then
      Battle.enemy_time_since_last_spawn = unit_batch_to_spawn.spawn_time
    end
    table.insert(Battle.enemy_spawn_queue, entry)

    Battle.factions.enemy.command_points = Battle.factions.enemy.command_points - unit_batch_to_spawn.cost

  else

    -- spawn the cheapest unit if we can afford it
    if command_points >= cheapest_unit.cost then

      local target_chunk = Battle.chunks[love.math.random(1, #Battle.chunks)]

      local entry = SpawnQueueEntry.new(cheapest_unit, target_chunk)

      if #Battle.enemy_spawn_queue == 0 then
        Battle.enemy_time_since_last_spawn = cheapest_unit.spawn_time
      end

      table.insert(Battle.enemy_spawn_queue, entry)

      Battle.factions.enemy.command_points = Battle.factions.enemy.command_points - cheapest_unit.cost
    else
      -- if we dont do this, the ai cannot lose ...
      Battle.factions.enemy.command_points = 0
    end

  end -- end of if command_points >= unit_batch_to_spawn.cost

end

return AiUnitSpawnManager