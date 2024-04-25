--- @class BattleUnitType
--- @field public name string
--- @field public images table<string, love.Image> my, enemy, etc.
--- @field public weapon BattleUnitWeapon
--- @field public size number
--- @field public speed number
--- @field public cost number
--- @field public shield_level number
--- @field public armor_level number
--- @field public batch_type number

BattleUnitType = {}

function BattleUnitType.check(obj)

  BattleUnitWeapon.check(obj.weapon)
end

function BattleUnitType.new(name, images, cost, speed, size, weapon, shield_level, armor_level, batch_number)
  local unit_type = {
    name = name,
    images = images,
    weapon = weapon,
    size = size,
    speed = speed,
    cost = cost,
    shield_level = shield_level or 0,
    armor_level = armor_level or 0,
    batch_type = batch_number
  }
  BattleUnitType.check(unit_type)
  return unit_type
end