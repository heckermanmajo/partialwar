local CampAIManager = require("v01/camp/manager/CampAIManager")

--[[

  How do rounds work?
  -> each faction has a turn, with moves you can see

  A not_player_turn - boolean to prevent from player actions

]]

local NextRoundManager = {}

NextRoundManager.current_actions = {}
NextRoundManager.time_to_next_action = 0
NextRoundManager.done_with_current_faction = false

--- @param camp Camp
function NextRoundManager.draw(camp)
  -- background for the faction turn
  love.graphics.print("Factions-turn: " .. camp.current_faction_turn.name, 10, 130)

  -- draw next round button at the top left corner 100 px from the left

  if camp.current_faction_turn ~= camp.factions.player then
    love.graphics.setColor(1, 0.2, 0.2)
  else
    love.graphics.setColor(0.2, 1, 0.2)
  end

  love.graphics.rectangle("fill", 0, 50, 200, 50)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("Next Round", 10, 50)

end

--- @param camp Camp
function NextRoundManager.handle_click(camp)
  local x, y = love.mouse.getPosition()

  local enter_is_pressed = love.keyboard.isDown("return")
  local button_is_pressed = x > 10 and x < 210 and y > 50 and y < 100 and love.mouse.isDown(1)

  if enter_is_pressed or button_is_pressed then

    NextRoundManager.done_with_current_faction = false
    NextRoundManager.current_actions = {}
    NextRoundManager.time_to_next_action = 0
    camp.current_faction_turn = camp.factions.enemy

    -- logics needed to be done at the start of a new round
    NextRoundManager.apply_income_to_all_factions(camp)
    NextRoundManager.reset_all_army_moves(camp)
    NextRoundManager.reset_all_factory_interactions(camp)

    camp.round_counter = camp.round_counter + 1

  end
end

--- @param camp Camp
function NextRoundManager.reset_all_army_moves(camp)

  for _, tile in ipairs(camp.tiles) do
    if tile.army then
      tile.army.movement_this_turn = false
    end
  end
end

--- @param camp Camp
function NextRoundManager.reset_all_factory_interactions(camp)

  for _, tile in ipairs(camp.tiles) do
    tile.factory_actions_this_turn = 3
  end

end


--- @param camp Camp
function NextRoundManager.apply_income_to_all_factions(camp)

  for _, tile in ipairs(camp.tiles) do

    if tile.owner then

      if tile.type == "factory" then
        tile.owner.money = tile.owner.money + camp.money_per_factory
      end

      if tile.type == "minerals" then
        tile.owner.money = tile.owner.money + camp.money_per_minerals
      end

      if tile.type == "fields" then
        tile.owner.money = tile.owner.money + camp.money_per_tile
      end

    end
  end


end


-- This function checks if an ai faction has a turn
-- if so it progresses the ai faction and schedules all moves
-- then over the next seconds it executes the moves
-- after all are done the next faction is scheduled
-- until the player is scheduled
-- if the player is scheduled the player can make moves
-- and also a button "next round" is displayed
--- @param camp Camp
function NextRoundManager.update(camp, dt)

  -- is the players turn?
  if camp.current_faction_turn == camp.factions.player then

    -- check for next round button click
    NextRoundManager.handle_click(camp)

    return -- the normal user interface handles the player turn

  else
    -- if not players turn

    if NextRoundManager.done_with_current_faction == false then
      -- are we not done with all actions?

      if #NextRoundManager.current_actions == 0 then
        -- if we have no actions scheduled
        -- schedule the actions for the current faction
        NextRoundManager.current_actions = CampAIManager.create_camp_actions(camp, camp.current_faction_turn)

      end

      -- if we have actions scheduled, execute them one by one after a delay
      if NextRoundManager.time_to_next_action > 0 then

        NextRoundManager.time_to_next_action = NextRoundManager.time_to_next_action - dt

      else

        if #NextRoundManager.current_actions > 0 then

          local action = NextRoundManager.current_actions[1]
          action()
          table.remove(NextRoundManager.current_actions, 1)
          NextRoundManager.time_to_next_action = 0.05

          if #NextRoundManager.current_actions == 0 then
            NextRoundManager.done_with_current_faction = true
          end

        else

          NextRoundManager.done_with_current_faction = true

        end

      end

    else

      -- todo: progress to the next faction in line
      -- until then just set the turn to the player ...
      camp.current_faction_turn = camp.factions.player

    end

  end

end

return NextRoundManager