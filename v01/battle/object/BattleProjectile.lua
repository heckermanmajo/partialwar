
--- @class BattleProjectile A projectile is a weapon that is fired from a unit.
--- @field public x number
--- @field public y number
--- @field public target_x number
--- @field public target_y number
--- @field public dx number
--- @field public dy number
--- @field public weapon_type BattleUnitWeapon
--- @field public faction BattleFaction
--- @field public rotation number
--- @field public start_x number
--- @field public start_y number
BattleProjectile = {}

function BattleProjectile.new (
  x,
  y,
  target_x,
  target_y,
  weapon_type,
  faction
)
  return {
    x = x,
    y = y,
    target_x = target_x,
    target_y = target_y,
    dx = 0,
    dy = 0,
    start_x = x,
    start_y = y,
    weapon_type = weapon_type,
    faction = faction,
    rotation = 0
  }
end