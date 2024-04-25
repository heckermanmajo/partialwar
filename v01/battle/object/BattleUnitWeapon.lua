--- @class BattleUnitWeapon
--- @field public name string
--- @field public image love.Image
--- @field public damage number
--- @field public range number
--- @field public speed number
--- @field public cool_down number
--- @field public is_ranged boolean
--- @field public projectile_image love.Image

BattleUnitWeapon = {}

function BattleUnitWeapon.check(obj)

end

function BattleUnitWeapon.new(
  name,
  image,
  damage,
  range_in_pixel_from_middle,
  cool_down_seconds,
  is_ranged,
  projectile_image
)
  local weapon = {
    name = name,
    image = image,
    damage = damage,
    range = range_in_pixel_from_middle,
    cool_down = cool_down_seconds,
    is_ranged = is_ranged,
    projectile_image = projectile_image,
  }

  BattleUnitWeapon.check(weapon)
  return weapon
end