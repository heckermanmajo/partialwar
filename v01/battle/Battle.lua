require("battle/object/BattleFaction")
require("battle/object/Chunk")
require("battle/object/BattleUnit")
require("battle/object/BattleUnitType")
require("battle/object/BattleUnitWeapon")
require("battle/object/BattleProjectile")
require("battle/object/Effect")
require("battle/object/Commander")

local AttackManager = require("battle/manager/AttackManager")
local ChunkManager = require("battle/manager/ChunkManager")
local DebugViewManager = require("battle/manager/DebugViewManager")
local SpawnManager = require("battle/manager/SpawnManager")
local UnitDrawManager = require("battle/manager/UnitDrawManager")
local CommandPointDrawManager = require("battle/manager/CommandPointDrawManager")
local AIFactionManager = require("battle/manager/AIFactionManager")
local CollisionManager = require("battle/manager/CollisionManager")
local MovingManager = require("battle/manager/MovingManager")
local TargetManager = require("battle/manager/TargetManager")
local MoveToTargetManager = require("battle/manager/MoveToTargetManager")
local DeadUnitRemover = require("battle/manager/DeadUnitRemover")
local EffectDrawer = require("battle/manager/EffectDrawer")
local ProjectileManager = require("battle/manager/ProjectileManager")
local DrawBattleInfo = require("battle/manager/DrawBattleInfo")
local MinimapDrawer = require("battle/manager/MinimapDrawer")

--- @class Battle
--- @field config BattleConfig
--- @field units table<number, BattleUnit>
--- @field chunks table<number, Chunk>
--- @field chunk_map table<number, table<number, Chunk>>
--- @field world_width number
--- @field world_height number
--- @field chunk_size number
--- @field camera_x_position number
--- @field camera_y_position number
--- @field spawn_delay number
--- @field factions table<string, BattleFaction>
--- @field player_commander Commander
Battle = {
  config = nil,
  debug = true,
  units = {},
  chunks = {},
  chunk_map = {},
  effects = {},
  projectiles = {},
  player_commander = Commander.new(100,600, 300),
  world_width = 256 * 30,
  world_height = 256 * 30,
  chunk_size = 256,
  camera_x_position = 0,
  camera_y_position = 0,
  spawn_delay = 3,
  factions = {
    player = BattleFaction.new("player", { 0, 0, 255 / 255 }, true, 500),
    enemy = BattleFaction.new("enemy", { 255 / 255, 0, 0 }, false, 500),
  }
}
Battle.__index = Battle

function Battle.get_x_position_in_world(x)
  if x < 0 then
    return 0
  end

  if x >= Battle.world_width then
    return Battle.world_width - 1
  end

  return x
end

function Battle.get_y_position_in_world(y)

  if y < 0 then
    return 0
  end

  if y >= Battle.world_height then
    return Battle.world_height - 1
  end

  return y
end

--- Start a new battle.
--- @param config BattleConfig
function Battle.start(config)
  Battle.config = config
  -- create the chunks
  -- delete previous chunks
  Battle.chunks = {}
  Battle.chunk_map = {}
  ChunkManager.init_chunks(Battle)

  -- delete all units since we are starting a new battle
  Battle.units = {}
  Battle.factions = {
    player = BattleFaction.new("player", { 0, 0, 255 / 255 }, true, config.player_command_points),
    enemy = BattleFaction.new("enemy", { 255 / 255, 0, 0 }, false, config.enemy_command_points),
  }
  -- load the weapons
  -- load all types of units
end

--- Called on the end of the battle.
--- @return BattleResult
function Battle.conclude()

  love.graphics.setBackgroundColor(0, 0, 0)

  --> BattleResult
  Camp.mode = "camp"
  local player_command_points = Battle.factions.player.command_points
  local enemy_command_points = Battle.factions.enemy.command_points

  print("Player command points out of battle: " .. player_command_points)
  print("Enemy command points out of battle: " .. enemy_command_points)

  local units_survived_player = 0
  local units_survived_enemy = 0

  for i, unit in ipairs(Battle.units) do

    if unit.faction == Battle.factions.player then
      if unit.hp > 0 then
        if unit.hp < 100 then
          player_command_points = player_command_points + unit.type.cost / 2
        else
          player_command_points = player_command_points + unit.type.cost
        end
        units_survived_player = units_survived_player + 1
      end
    end

    if unit.faction == Battle.factions.enemy then
      if unit.hp > 0 then
        if unit.hp < 100 then
          enemy_command_points = enemy_command_points + unit.type.cost / 2
        else
          enemy_command_points = enemy_command_points + unit.type.cost
        end
        units_survived_enemy = units_survived_enemy + 1
      end
    end

  end

  print("Player units survived: " .. units_survived_player)
  print("Enemy units survived: " .. units_survived_enemy)

  print("Units in battle: " .. #Battle.units)

  print("Player command points after battle: " .. player_command_points)
  print("Enemy command points after battle: " .. enemy_command_points)

  local result = BattleResult.new(
    enemy_command_points,
    player_command_points,
    Battle.config.player_tile,
    Battle.config.enemy_tile
  )
  -- add up living units back into command points
  -- put the cost into type
  -- put the start tile and the end tile into the result

  -- clear the battle
  Battle.units = {} -- clear all units
  Battle.effects = {} -- clear all effects
  Battle.projectiles = {} -- clear all projectiles

  Camp.consume_battle_result(result)
end

-- Update and draw functions
function Battle.update(dt)

  -- change the view with the arrow keys
  if love.keyboard.isDown("w") then
    Battle.camera_y_position = Battle.camera_y_position + 600 * dt
  end
  if love.keyboard.isDown("s") then
    Battle.camera_y_position = Battle.camera_y_position - 600 * dt
  end
  if love.keyboard.isDown("a") then
    Battle.camera_x_position = Battle.camera_x_position + 600 * dt
  end
  if love.keyboard.isDown("d") then
    Battle.camera_x_position = Battle.camera_x_position - 600 * dt
  end



  --AttackManager.update(Battle, dt)
  SpawnManager.update(Battle, dt)
  AIFactionManager.update(Battle, dt)
  CollisionManager.collide(Battle, dt)
  MovingManager.move(Battle, dt)
  ChunkManager.update_all_unit_positions(Battle, dt)
  TargetManager.update(Battle, dt)
  MoveToTargetManager.update(Battle, dt)
  DeadUnitRemover.update(Battle, dt)
  AttackManager.update(Battle, dt)
  EffectDrawer.update(Battle, dt)
  --CommanderManager.update(Battle, dt)
  ProjectileManager.update(Battle, dt)

  local unit_num = 0
  for _, c in ipairs(Battle.chunks) do
    unit_num = unit_num + #c.units
  end
  assert(#Battle.units == unit_num, "Unit count mismatch " .. #Battle.units .. " vs " .. unit_num)

  local no_player_units = true
  local no_enemy_units = true

  for _, u in ipairs(Battle.units) do
    u.x = Battle.get_x_position_in_world(u.x)
    u.y = Battle.get_y_position_in_world(u.y)

    if u.faction == Battle.factions.player then
      no_player_units = false
    end

    if u.faction == Battle.factions.enemy then
      no_enemy_units = false
    end

  end

  if (
    (no_player_units and Battle.factions.player.command_points <= 0)
      or
      (no_enemy_units and Battle.factions.enemy.command_points <= 0)
  )
  then
    Battle.conclude()
  end


end

function Battle.draw()

  -- set background color to an gray
  love.graphics.setBackgroundColor(70 / 255, 116 / 255, 93 / 255)


  ChunkManager.draw(Battle)

  EffectDrawer.draw(Battle)

  DebugViewManager.draw_meta_info()
  UnitDrawManager.draw(Battle)

  ProjectileManager.draw(Battle)

  --CommanderManager.draw(Battle)

  CommandPointDrawManager.draw(Battle)

  DrawBattleInfo.draw_battle_info(Battle)

  MinimapDrawer.draw(Battle)

end