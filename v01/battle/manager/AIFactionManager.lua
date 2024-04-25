--- The ai faction manager is responsible for managing the AI faction during a battle.
--- It will spawn unit-batches and manage the AI faction's command points.
local AIFactionManager = {}

local UnitTypes = require("battle/data/unit_types")

AIFactionManager.time_until_next_spawn = 10

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
    local x = math.random(Battle.world_width - spawn_max_x, Battle.world_width)
    local y = math.random(0, Battle.world_height)
    BattleUnit.new(x, y, unit_type, faction)
    print("Spawned " .. unit_type.name .. " at " .. x .. ", " .. y)
  end
  return used_cost

end

--- Updates the AI faction.
--- @param Battle Battle
--- @param dt number
--- @return void
function AIFactionManager.update(Battle, dt)

  assert(Battle, "Battle is nil")
  assert(dt, "dt is nil")

  if AIFactionManager.time_until_next_spawn > 0 then

    AIFactionManager.time_until_next_spawn = AIFactionManager.time_until_next_spawn - dt

    if AIFactionManager.time_until_next_spawn < 0 then
      AIFactionManager.time_until_next_spawn = 0
    end

    return

  end

  local enemy_faction = Battle.factions.enemy
  assert(enemy_faction, "enemy faction not found, ai faction manager needs an enemy faction to work.")

  if Battle.factions.enemy.command_points < UnitTypes.Spearman.cost then
    return
  end

  local used_cost = 0

  -- todo: keep track of what i have spawned and what is on the battle map
  --       so the ai spawns matching units

  -- decide what to spawn by random for now

  local random = math.ceil(math.random(0, Battle.config.enemy_army_level))
  if random == 1 then
    used_cost = spawn_batch(UnitTypes.Spearman, enemy_faction, Battle)
  elseif random == 2 then
    used_cost = spawn_batch(UnitTypes.Bowman, enemy_faction, Battle)
  elseif random == 3 then
    used_cost = spawn_batch(UnitTypes.Levy, enemy_faction, Battle)
  elseif random == 4  then
    used_cost = spawn_batch(UnitTypes.Swordsman, enemy_faction, Battle)
  end

  Battle.factions.enemy.command_points = Battle.factions.enemy.command_points - used_cost

  AIFactionManager.time_until_next_spawn = Battle.spawn_delay

end

return AIFactionManager