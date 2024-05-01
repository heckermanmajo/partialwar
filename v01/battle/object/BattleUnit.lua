--- @class BattleUnit
--- @field public x number the x position of the unit on the map
--- @field public y number the y position of the unit on the map
--- @field public type BattleUnitType the type of the unit
--- @field public faction BattleFaction the faction of the unit
--- @field public hp number the current hit points of the unit
--- @field public target BattleUnit the unit that this unit is attacking or following
--- @field public time_since_attack number the time since the last attack
--- @field public time_until_next_attack_update number the time since the last attack update
--- @field public current_chunk Chunk the chunk that the unit is currently in
--- @field public x_velocity number the x velocity of the unit
--- @field public y_velocity number the y velocity of the unit
--- @field public rotation number the rotation of the unit
--- @field public attacking boolean if the unit is currently attacking
--- @field public hits_last_second number the number of hits that the unit has done in the last second
--- @field public control_group number the control group that the unit is in. If a unit has no control group
---               it cannot receive any commands from the player or ai. If a unit has lost its control group
---               it will just try to attack the nearest unit or if there are too many enemies, it will flee.

BattleUnit = {}

function BattleUnit.check(obj)

end

--- @param x number
--- @param y number
--- @param type BattleUnitType
--- @param faction BattleFaction
--- @return BattleUnit
function BattleUnit.new(x, y, type, faction)
  local unit = {
    x = x,
    y = y,
    type = type,
    faction = faction,
    hp = 100,
    target = nil,
    time_since_attack = 0,
    x_velocity = 0,
    y_velocity = 0,
    rotation = 0,
    attacking = false,
    hits_last_second = 0,
    control_group = nil,
  }
  --AttackManager.init(unit)
  BattleUnit.check(unit)
  table.insert(Battle.units, unit)

  return unit
end
