local TileHelper = require("camp.helper.TileHelper")
local ArmyMover = require("camp/manager/ArmyMover")

local CampAI = {}

--- This function creates all the actions an ai player
--- does in his turn.
---
--- @param camp Camp
--- @param faction Faction
---
--- @return table<function>
function CampAI.create_camp_actions(camp, faction)

  -- move each army to the next non occupied tile

  -- iterate over all tiles and check if my army is on tile
  -- if so move to a random free tile

  local actions = {}

  local number_of_armies = 0
  for _, tile in ipairs(camp.tiles) do

    if tile.army and tile.army.faction == faction then

      number_of_armies = number_of_armies + 1

      function level_up_army (army, level)
        local price = level * camp.level_cost
        if army.command_points - 500 > price and army.army_level < level then
          army.command_points = army.command_points - price
          army.army_level = army.army_level + 1
        end
      end

      level_up_army(tile.army, 2)
      level_up_army(tile.army, 3)
      level_up_army(tile.army, 4)
      level_up_army(tile.army, 5)
      level_up_army(tile.army, 6)
      level_up_army(tile.army, 7)
      level_up_army(tile.army, 8)
      level_up_army(tile.army, 9)

    end
  end


  local increase_size_actions = CampAI.increase_army_size(
    camp,
    faction,
    0,
    number_of_armies
  )
  for _, action in ipairs(increase_size_actions) do
    table.insert(actions, action)
  end

  local army_spawn_actions = CampAI.spawn_new_armies(camp, faction)

  for _, action in ipairs(army_spawn_actions) do
    table.insert(actions, action)
  end



  --- movement ...


  for _, tile in ipairs(camp.tiles) do

    local army = tile.army
    if army and army.faction == faction then

      local tiles = TileHelper.get_all_tiles_around_given_tile(camp, tile)

      -- randomize the order of the tiles
      for i = #tiles, 2, -1 do
        local j = math.random(i)
        tiles[i], tiles[j] = tiles[j], tiles[i]
      end

      for _, neighbour in ipairs(tiles) do

        -- todo: look for en enemy army and attack it
        -- todo: try to take new tiles
        -- todo: increase your army size
        -- todo: create new armies ...

        local i_should_attack = true
        if neighbour.army and neighbour.army.faction ~= faction then
          i_should_attack = false
          if tile.army.command_points > neighbour.army.command_points then
            i_should_attack = true
          end
        end

        if neighbour.is_passable and i_should_attack then

          table.insert(actions, function()

            if not neighbour.is_passable then
              return  -- ignore this action, sth. has changed in the meantime
            end

            ArmyMover.move_army_with_all_consequences(camp, tile, neighbour)

          end)

          goto break_inner_for_loop
        end

      end -- end for all neighbours of current tile

      :: break_inner_for_loop ::

    end -- end if my army is on tile

  end -- end for all tiles


  table.insert(actions, function()
    -- placeholder action -> each ai needs at least one turn
  end)

  return actions

end

--- This function spawns new armies for the given faction.
--- @param camp Camp
--- @param faction Faction
--- @return table<function>
function CampAI.spawn_new_armies(camp, faction)
  local actions = {}
  local armies_spawned = 2

  for _, t in ipairs(camp.tiles) do
    if t.owner == faction and t.type == "factory" and t.army == nil then

      if armies_spawned < 0 or faction.money < 100 then
        break
      end

      faction.money = faction.money - 100

      table.insert(actions, function()

        if t.army then
          -- refund if there is already an army moved here this turn
          -- by myself
          faction.money = faction.money - 100
          return
        end

        t.army = Army.new(faction, 100)
        t.army.movement_this_turn = true

      end)

      armies_spawned = armies_spawned - 1

    end
  end

  return actions
end

--- This function increases the size of the armies of the given faction.
--- @param camp Camp
--- @param faction Faction
--- @return table<function>
function CampAI.increase_army_size(camp, faction, money_to_keep_in_bank,
                                   number_of_armies)

  local actions = {}

  for _, t in ipairs(camp.tiles) do

    if t.owner == faction and t.type == "factory" and t.army ~= nil then

      while t.factory_actions_this_turn > 0 and faction.money > 100 do

        faction.money = faction.money - 100
        t.factory_actions_this_turn = t.factory_actions_this_turn - 1

        table.insert(actions, function()
          t.army.command_points = t.army.command_points + 100
        end)

      end

    end

  end

  return actions

end

return CampAI