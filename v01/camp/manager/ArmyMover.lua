local ArmyMover = {}



-- if there is a tile selected, move the army to that tile
-- if the tile above is passable
-- if an enemy start battle
-- if the tile is owned by the player, move the army
-- if there is a player army on the tile, merge them


--- Determines if the army on the current tile can move up.
--- @param camp Camp
--- @param current_tile Tile
--- @return boolean
function ArmyMover.can_move_army_up(camp, current_tile)

  if current_tile.y == 0 then
    return false
  end

  local target_tile = camp.tile_map[current_tile.y - 1][current_tile.x]

  if target_tile.is_passable then
    return true
  end

end

--- Determines if the army on the current tile can move down.
--- @param camp Camp
--- @param current_tile Tile
--- @return boolean
function ArmyMover.can_move_army_down(camp, current_tile)

  if current_tile.y == 10 then
    return false
  end

  local target_tile = camp.tile_map[current_tile.y + 1][current_tile.x]

  if target_tile.is_passable then
    return true
  end

end

--- Determines if the army on the current tile can move left.
--- @param camp Camp
--- @param current_tile Tile
--- @return boolean
function ArmyMover.can_move_army_left(camp, current_tile)

  if current_tile.x == 0 then
    return false
  end

  local target_tile = camp.tile_map[current_tile.y][current_tile.x - 1]

  if target_tile.is_passable then
    return true
  end

end

--- Determines if the army on the current tile can move right.
--- @param camp Camp
--- @param current_tile Tile
--- @return boolean
function ArmyMover.can_move_army_right(camp, current_tile)

  if current_tile.x == 10 then
    return false
  end

  local target_tile = camp.tile_map[current_tile.y][current_tile.x + 1]

  if target_tile.is_passable then
    return true
  end

end

--- Actually moving an army up on the map.
function ArmyMover.move_army_up(camp, current_tile)

  if not current_tile.army then
    return
  end

  if ArmyMover.can_move_army_up(camp, current_tile) then

    local target_tile = camp.tile_map[current_tile.y - 1][current_tile.x]

    ArmyMover.move_army_with_all_consequences(camp, current_tile, target_tile)

  end

end

function ArmyMover.move_army_down(camp, current_tile)

  if not current_tile.army then
    return
  end

  if ArmyMover.can_move_army_down(camp, current_tile) then

    local target_tile = camp.tile_map[current_tile.y + 1][current_tile.x]

    ArmyMover.move_army_with_all_consequences(camp, current_tile, target_tile)
  end

end

function ArmyMover.move_army_left(camp, current_tile)

  if not current_tile.army then
    return
  end

  if ArmyMover.can_move_army_left(camp, current_tile) then

    local target_tile = camp.tile_map[current_tile.y][current_tile.x - 1]

    ArmyMover.move_army_with_all_consequences(camp, current_tile, target_tile)

  end

end

function ArmyMover.move_army_right(camp, current_tile)

  if not current_tile.army then
    return
  end

  if ArmyMover.can_move_army_right(camp, current_tile) then

    local target_tile = camp.tile_map[current_tile.y][current_tile.x + 1]

    ArmyMover.move_army_with_all_consequences(camp, current_tile, target_tile)

  end

end

--- Starting a battle between two armies.
--- @param camp Camp
--- @param current_tile Tile
--- @param target_tile Tile
--- @return void
function ArmyMover.start_battle(camp, current_tile, target_tile)
  -- todo: start the battle and consume the result afterwards
  --       and apply the result to the tiles
  assert(current_tile.army, "There is no army on the current tile")
  assert(target_tile.army, "There is no army on the target tile")
  assert(current_tile.owner ~= target_tile.owner, "The armies are owned by the same faction")

  local config = nil

  if current_tile.owner == camp.factions.player then
    -- player attacks
    config = BattleConfig.new(
      current_tile.army.command_points,
      target_tile.army.command_points,
      current_tile, -- player
      target_tile, -- enemy
      current_tile.army.army_level,
      target_tile.army.army_level
    )
  else
    -- player defends
    config = BattleConfig.new(
      target_tile.army.command_points,
      current_tile.army.command_points,
      target_tile, -- player
      current_tile, -- enemy
      target_tile.army.army_level,
      current_tile.army.army_level
    )
  end

  Battle.start(config)
  Camp.mode = "battle"

end

--- Merging two armies to the target tile.
--- @param camp Camp
--- @param current_tile Tile
--- @param target_tile Tile
--- @return void
function ArmyMover.merge_armies(camp, current_tile, target_tile)
  -- merge two armies to the target tile
  assert(current_tile.army, "There is no army on the current tile")
  assert(target_tile.army, "There is no army on the target tile")
  assert(current_tile.owner == target_tile.owner, "The armies are not owned by the same faction")

  local highest_level = math.max(current_tile.army.army_level, target_tile.army.army_level)

  local army = current_tile.army
  local target_army = target_tile.army
  target_army.movement_this_turn = true
  target_army.command_points = target_army.command_points + army.command_points
  target_army.army_level = highest_level
  current_tile.army = nil

end

--- Moving an army to the target tile.
--- @param camp Camp
--- @param current_tile Tile
--- @param target_tile Tile
--- @return void
function ArmyMover.move_army(camp, current_tile, target_tile)
  -- move the army to the target tile
  assert(current_tile.army, "There is no army on the current tile")
  assert(not target_tile.army, "There is already an army on the target tile")
  local army = current_tile.army
  current_tile.army = nil
  target_tile.army = army
  target_tile.owner = army.faction
end

--- Moving an army to the target tile and handle all consequences.
--- @param camp Camp
--- @param current_tile Tile
--- @param target_tile Tile
---
function ArmyMover.move_army_with_all_consequences(camp, current_tile, target_tile)

  current_tile.army.movement_this_turn = true

  if target_tile.army then

    -- we need to check if the army is owned by the same faction
    if target_tile.owner == current_tile.owner then
      -- if so, merge the armies
      ArmyMover.merge_armies(camp, current_tile, target_tile)
    else
      -- if not, start a battle
      ArmyMover.start_battle(camp, current_tile, target_tile)
    end

  else
    -- if there is no army on the target tile, move the army
    ArmyMover.move_army(camp, current_tile, target_tile)
  end

end

--- Only for ai use: How likely is it that current_tile army will win the battle.
--- @param camp Camp
--- @param current_tile Tile
--- @param target_tile Tile
function ArmyMover.get_chance_of_victory(camp, current_tile, target_tile)

end

--- Only for ai use: How much value is in the given tile.
--- @param tile Tile
function ArmyMover.get_value_of_tile(tile)

end

return ArmyMover