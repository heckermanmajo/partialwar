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
--- @field public spawn_time number
--- @field public number_of_command_groups number

BattleUnitType = {}
BattleUnitType.__index = BattleUnitType

function BattleUnitType.check(obj)

  BattleUnitWeapon.check(obj.weapon)
end

function BattleUnitType.new(name, images, cost, speed, size, weapon, shield_level, armor_level, batch_number, spawn_time, number_of_command_groups)
  local unit_type = {
    name = name,
    images = images,
    weapon = weapon,
    size = size,
    speed = speed,
    cost = cost,
    shield_level = shield_level or 0,
    armor_level = armor_level or 0,
    batch_type = batch_number,
    spawn_time = spawn_time,
    number_of_command_groups = number_of_command_groups
  }
  setmetatable(unit_type, BattleUnitType)
  BattleUnitType.check(unit_type)
  return unit_type
end

local shield_one_image = love.graphics.newImage("battle/res/round_shield.png")
local shield_two_image = love.graphics.newImage("battle/res/square_shield.png")

function BattleUnitType:draw_icon(x, y, scale, is_player)

  scale = scale -- todo: make smaller for bigger units

  local image
  if is_player then
    image = self.images["player"]
  else
    image = self.images["enemy"]
  end

  local rect_color
  if is_player then
    rect_color = { 0, 0, 1 }
  else
    rect_color = { 1, 0, 0 }
  end

  love.graphics.setColor(rect_color)
  -- draw a rectangle around the icon
  love.graphics.rectangle("line", x + self.size / 4, y + self.size / 4, self.size * scale, self.size * scale)
  love.graphics.setColor(1, 1, 1)

  love.graphics.draw(
    image, -- image
    x + self.size / 2, -- x
    y + self.size / 2, -- y
    0, -- rotation
    scale, -- scale x
    scale, -- scale y
    self.size / 2, -- origin x
    self.size / 2 -- origin y
  )

  local weapon_image = self.weapon.image
  local weapon_rotation = 0

  local weapon_width = weapon_image:getWidth()
  local weapon_height = weapon_image:getHeight()

  local pixel_to_draw_the_spear_further_x = 0
  local pixel_to_draw_the_spear_further_y = 0

  local pixel_to_draw_the_spear_further = 0

  local time_per_attack = self.weapon.cool_down

  if self.weapon.is_ranged then
    -- if the unit is a ranged unit, we draw the weapon before the unit
    -- this allows for a weapon in the front of the unit
    pixel_to_draw_the_spear_further = 14

  else

    -- if the weapon is a melee weapon, we draw the weapon on the side (done by the
    -- position of the weapon in the image file)
    -- however, we want to draw the weapon further if the unit has just attacked
    --if unit.last_attack_time > time_per_attack / 2 then
    --  pixel_to_draw_the_spear_further = 32
    --end

  end

  local rotated_rotation = 0 + math.pi / 2
  pixel_to_draw_the_spear_further_x = math.cos(rotated_rotation) * pixel_to_draw_the_spear_further
  pixel_to_draw_the_spear_further_y = math.sin(rotated_rotation) * pixel_to_draw_the_spear_further

  love.graphics.draw(
    weapon_image, -- image
    x - pixel_to_draw_the_spear_further_x + self.size / 2, -- x
    y - pixel_to_draw_the_spear_further_y + self.size / 2, -- y
    weapon_rotation, -- rotation
    scale, -- scale x
    scale, -- scale y
    weapon_width / 2, -- origin x
    weapon_height / 2 -- origin y
  )

  if self.shield_level == 0 then
    -- no shield
  elseif self.shield_level == 1 then
    love.graphics.draw(
      shield_one_image, -- image
      x + (self.size / 2) * scale, -- x
      y + (self.size / 2) * scale, -- y
      0, -- rotation
      scale, -- scale x
      scale, -- scale y
      shield_one_image:getWidth() / 2, -- origin x
      shield_one_image:getHeight() / 2 -- origin y
    )
  elseif self.shield_level == 2 then
    love.graphics.draw(
      shield_two_image, -- image
      x + self.size / 2, -- x
      y + self.size / 2, -- y
      0, -- rotation
      scale, -- scale x
      scale, -- scale y
      shield_two_image:getWidth() / 2, -- origin x
      shield_two_image:getHeight() / 2 -- origin y
    )
  end


end