local Weapons = require("battle/data/weapons")

local UnitTypes = {}

-- NOTE: if you change the armor_level, you need also to set the image to the armored version

-- TODO; NOTE: you need to write unit strength and weaknesses
--       into the unit types, so an AI can make decisions

do

  local speed = 100
  local cost = 10
  local size = 64
  local shield_level = 0
  local armor_level = 0
  local batch_size = 25
  local spawn_time = 10
  local number_of_command_groups = 4

  UnitTypes["Spearman"] = BattleUnitType.new(
    "Spearman",
    {
      player = love.graphics.newImage("battle/res/blue_marble.png"),
      enemy = love.graphics.newImage("battle/res/red_marble.png"),
    },
    cost,
    speed,
    size,
    Weapons.spear,
    shield_level,
    armor_level,
    batch_size,
    spawn_time,
    number_of_command_groups
  )

end

do

  local speed = 50
  local cost = 1
  local size = 64
  local shield_level = 1
  local armor_level = 0
  local batch_size = 20
  local spawn_time = 20
  local number_of_command_groups = 2

  UnitTypes["Levy"] = BattleUnitType.new(
    "Levy",
    {
      player = love.graphics.newImage("battle/res/blue_marble.png"),
      enemy = love.graphics.newImage("battle/res/red_marble.png"),
    },
    cost,
    speed,
    size,
    Weapons.short_sword,
    shield_level,
    armor_level,
    batch_size,
    spawn_time,
    number_of_command_groups
  )

end


do

  local speed = 50
  local cost = 5
  local size = 64
  local shield_level = 2
  local armor_level = 1
  local batch_size = 25
  local spawn_time = 30
  local number_of_command_groups = 1

  UnitTypes["Swordsman"] = BattleUnitType.new(
    "Swordsman",
    {
      player = love.graphics.newImage("battle/res/blue_marble_armor.png"),
      enemy = love.graphics.newImage("battle/res/red_marble_armor.png"),
    },
    cost,
    speed,
    size,
    Weapons.sword,
    shield_level,
    armor_level,
    batch_size,
    spawn_time,
    number_of_command_groups
  )

end



do

  local speed = 50
  local cost = 2
  local size = 64
  local shield_level = 0
  local armor_level = 0
  local batch_size = 40
  local spawn_time = 25
  local number_of_command_groups = 2

  UnitTypes["Bowman"] = BattleUnitType.new(
    "Bowman",
    {
      player = love.graphics.newImage("battle/res/blue_marble.png"),
      enemy = love.graphics.newImage("battle/res/red_marble.png"),
    },
    cost,
    speed,
    size,
    Weapons.bow,
    shield_level,
    armor_level,
    batch_size,
    spawn_time,
    number_of_command_groups
  )

end

do

  local speed = 50
  local cost = 10
  local size = 64
  local shield_level = 0
  local armor_level = 1
  local batch_size = 25
  local spawn_time = 35
  local number_of_command_groups = 1

  UnitTypes["CrossBowman"] = BattleUnitType.new(
    "CrossBowman",
    {
      player = love.graphics.newImage("battle/res/blue_marble_armor.png"),
      enemy = love.graphics.newImage("battle/res/red_marble_armor.png"),
    },
    cost,
    speed,
    size,
    Weapons.crossbow,
    shield_level,
    armor_level,
    batch_size,
    spawn_time,
    number_of_command_groups
  )

end



return UnitTypes