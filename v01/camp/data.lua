BattleConfig = {}
--- @class BattleConfig
--- @field public enemy_command_points number
--- @field public player_command_points number
--- @field public player_tile Tile
--- @field public enemy_tile Tile
--- @field public player_army_level number
--- @field public enemy_army_level number
---
--- Later we can add all kinds of campaign specific modifiers here.
---
function BattleConfig.new(
  player_command_points,
  enemy_command_points,
  player_tile,
  enemy_tile,
  player_army_level,
  enemy_army_level
)
  return {
    enemy_command_points = enemy_command_points,
    player_command_points = player_command_points,
    player_tile = player_tile,
    enemy_tile = enemy_tile,
    player_army_level = player_army_level,
    enemy_army_level = enemy_army_level
  }
end

--- @class BattleResult
--- @field public enemy_command_points number
--- @field public player_command_points number
--- @field public player_tile Tile
--- @field public enemy_tile Tile
BattleResult = {}

function BattleResult.new(
  enemy_command_points,
  player_command_points,
  player_tile,
  enemy_tile
)
  return {
    enemy_command_points = enemy_command_points,
    player_command_points = player_command_points,
    player_tile = player_tile,
    enemy_tile = enemy_tile
  }
end

--- @class Tile A tile has 32 * 4 pixels on w and h.
--- @field public x number
--- @field public y number
--- @field public type string
--- @field public is_passable boolean
--- @field public army Army
--- @field public owner Faction
--- @field public image Image
--- @field public factory_actions_this_turn number
--- @field public distance_to_next_big_player_army number
--- @field public distance_to_next_small_enemy_army number
--- @field public distance_to_next_enemy_army number
--- @field public distance_to_next_factory number
--- @field public factory_neighbours number
--- @field public blocking_tile_neighbours number
Tile = {}
function Tile.new(x, y, type, is_passable, image)
  return {
    x = x,
    y = y,
    type = type,
    army = nil,
    owner = nil,
    image = image,
    factory_actions_this_turn = 3,
    is_passable = is_passable,
  }
end


--- @class Army
--- @field public faction Faction
--- @field public command_points number The number of command points this army has (used to deploy units in the battle mode)
--- @field public movement_this_turn boolean was the army moved this turn?
--- @field public army_level number

Army = {}
function Army.new(faction, command_points)
  return {
    faction = faction,
    command_points = command_points,
    movement_this_turn = false,
    army_level = 1
  }
end

--- @class Faction
--- @field public name string
--- @field public color table<number, number>
--- @field public is_player boolean
--- @field public money number

Faction = {}

function Faction.new(name, color, is_player, money)
  return {
    name = name,
    color = color,
    is_player = is_player,
    money = money
  }
end

