--- Spawn groups of units based on the clicked number keys, if a chunk is selected.
local SpawnUnitsViaNumberKeys = {}
local UnitTypes = require("battle/data/unit_types")
local last_spawn_cool_down = 0
local mapping = {
  ["1"] = UnitTypes.Spearman,
  ["2"] = UnitTypes.Levy,
  ["3"] = UnitTypes.Bowman,
  ["4"] = UnitTypes.Swordsman,
  ["5"] = UnitTypes.CrossBowman
-- todo: add more mappings
}

--- Spawn groups of units based on the clicked number keys, if a chunk is selected.
--- @param Battle Battle
--- @param unit_type BattleUnitType
--- @param target_chunk Chunk
local function add_spawn_queue_entry(Battle, unit_type, target_chunk)

  -- only spawn units if enough resources are available
  local enough_command_points = Battle.factions.player.command_points >= unit_type.cost
  if not enough_command_points then goto end_of_function end
  -- subtract the cost of the unit from the player resources
  Battle.factions.player.command_points = Battle.factions.player.command_points - unit_type.cost

  if #Battle.player_spawn_queue == 0 then
    Battle.player_time_since_last_spawn = unit_type.spawn_time
  end

  table.insert(
    Battle.player_spawn_queue,
    SpawnQueueEntry.new(
      unit_type,
      target_chunk
    )
  )

  last_spawn_cool_down = 0.3

  ::end_of_function::

end

--- @param Battle Battle
--- @param dt number
function SpawnUnitsViaNumberKeys.update(Battle, dt)

  if Battle.currently_selected_chunk ~= nil then
    if last_spawn_cool_down < 0 then
      for key, unit_type in pairs(mapping) do
        if love.keyboard.isDown(key) then
          add_spawn_queue_entry(Battle, unit_type, Battle.currently_selected_chunk)
        end
      end
    end
  end

  last_spawn_cool_down = last_spawn_cool_down - dt

end

return SpawnUnitsViaNumberKeys