local Weapons = {}

do

  local name = "Spear"
  local image = love.graphics.newImage("battle/res/spear.png")
  local damage = 4
  local range = 90
  local cool_down = 5
  local is_ranged = false
  local projectile_image = nil

  local spear = BattleUnitWeapon.new(
    name,
    image,
    damage,
    range,
    cool_down,
    is_ranged,
    projectile_image
  )

  Weapons.spear = spear

end

do

  local name = "ShortSword"
  local image = love.graphics.newImage("battle/res/short_sword.png")
  local damage = 10
  local range = 80
  local cool_down = 2
  local is_ranged = false
  local projectile_image = nil

  local short_sword = BattleUnitWeapon.new(
    name,
    image,
    damage,
    range,
    cool_down,
    is_ranged,
    projectile_image
  )

  Weapons.short_sword = short_sword

end

do

  local name = "Sword"
  local image = love.graphics.newImage("battle/res/sword.png")
  local damage = 30
  local range = 90
  local cool_down = 0.8
  local is_ranged = false
  local projectile_image = nil

  local sword = BattleUnitWeapon.new(
    name,
    image,
    damage,
    range,
    cool_down,
    is_ranged,
    projectile_image
  )

  Weapons.sword = sword

end


do

  local name = "Bow"
  local image = love.graphics.newImage("battle/res/bow.png")
  local damage = 20
  local range = 800
  local cool_down = 3
  local is_ranged = true
  local projectile_image = love.graphics.newImage("battle/res/arrow.png")

  local bow = BattleUnitWeapon.new(
    name,
    image,
    damage,
    range,
    cool_down,
    is_ranged,
    projectile_image
  )

  Weapons.bow = bow

end

do

  local name = "CrossBow"
  local image = love.graphics.newImage("battle/res/crossbow.png")
  local damage = 100
  local range = 1000
  local cool_down = 5
  local is_ranged = true
  local projectile_image = love.graphics.newImage("battle/res/bolt.png")

  local crossbow = BattleUnitWeapon.new(
    name,
    image,
    damage,
    range,
    cool_down,
    is_ranged,
    projectile_image
  )

  Weapons.crossbow = crossbow

end

return Weapons