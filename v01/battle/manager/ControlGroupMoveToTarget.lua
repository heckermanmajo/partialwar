--local get_chunk_by_position = require("v01/battle/composition/get_chunk_by_position")
--local get_chunks_around_me = require("v01/battle/composition/get_chunks_around_me")
--- A control group can have a move target.
--- The group as a whole will move towards the target.
--- If there is an enemy between the group and the target,
--- the group will engage the enemy: this means that all units
--- will use their "attack and follow the nearest enemy" AI.
--- with and max-distance, after which the group will re-order
--- itself into formation, by calculating the center of the group
--- and arranging the units around it.


local ControlGroupMoveToTarget = {}

local function has_enemies_in_reach(control_group, Battle)

  -- todo: update this for ranged units, so they attack from a distance
  -- todo: make this work via chunks, not loop over all units
  -- todo: only use 3 random units of the control group to check for enemies

  for _, unit in ipairs(control_group.units) do

    for _, enemy_unit in ipairs(Battle.units) do

      assert(enemy_unit.faction, "enemy_unit.faction is nil")
      assert(control_group.faction, "control_group.faction is nil")

      if enemy_unit.faction ~= control_group.faction then

        local distance_to_enemy = math.sqrt(
          (unit.x - enemy_unit.x) ^ 2 +
            (unit.y - enemy_unit.y) ^ 2
        )

        if distance_to_enemy < 600 then
          return true
        end

      end

    end

  end

  return false

end

--- @param Battle Battle
--- @param dt number
function ControlGroupMoveToTarget.update(Battle, dt)

  -- for each control group
  -- check in what state the group is
  -- then act on the units in the group

  for _, control_group in ipairs(Battle.control_groups) do

    -- fighting does not need to be done every frame for all control groups
    -- so we can randomize the next update time
    if control_group.__next_move_to_target_update == nil then
      control_group.__next_move_to_target_update = love.math.random(0, 400) / 100
    end

    if control_group.__next_move_to_target_update > 0 then
      control_group.__next_move_to_target_update = control_group.__next_move_to_target_update - dt
      goto before_on_the_way -- jump to the movement part of the loop
    end

    -- calculate the center of the control group
    control_group:calculate_center()

    -- calculate the slowest unit speed
    control_group.slowest_unit_speed = 999999999
    for _, unit in ipairs(control_group.units) do
      if unit.type.speed < control_group.slowest_unit_speed then
        control_group.slowest_unit_speed = unit.type.speed
      end
    end


    -----------------------------------------------------------------------------------------------
    -- ENGAGED MODE : The control group is in a fight
    if control_group.mode == "engaged" then
      -- check if units are still engaged ...

      local some_unit_is_engaged = false

      for _, unit in ipairs(control_group.units) do

        if unit.target then

          local distance_to_target = math.sqrt(
            (unit.x - unit.target.x) ^ 2 +
              (unit.y - unit.target.y) ^ 2
          )

          local max_distance
          if unit.type.weapon.is_ranged then
            max_distance = unit.type.weapon.range
          else
            max_distance = 600
          end

          if distance_to_target < max_distance then
            some_unit_is_engaged = true
          end

          break

        end

      end

      if not some_unit_is_engaged then
        control_group.mode = control_group.last_mode
      end

    end

    -----------------------------------------------------------------------------------------------
    -- SEARCHING MODE : The control group is looking for the next checkpoint on the map to conquer
    if control_group.mode == "searching" then
      -- check if we are near to a check point that does not
      -- belong to us, if so set this as target
      local next_target = nil
      local smallest_distance = 999999999

      for _, chunk in ipairs(Battle.chunks) do

        local distance_to_chunk = math.sqrt(
          (control_group.center_x - chunk.x) ^ 2 +
            (control_group.center_y - chunk.y) ^ 2
        )

        if (
          chunk.is_checkpoint
            and chunk.current_owner ~= control_group.faction
            and distance_to_chunk < smallest_distance
        ) then
          next_target = chunk
          smallest_distance = distance_to_chunk
        end

      end

      if next_target then
        control_group.last_mode = "searching"
        control_group.target_chunk = next_target
        control_group.mode = "on_the_way"
      end

    end


    -----------------------------------------------------------------------------------------------
    -- IDLE MODE : The control group is not in a fight and not moving to a target
    if control_group.mode == "idle" then
      -- we are on the lookout for enemy units
      if has_enemies_in_reach(control_group, Battle) then
        control_group.last_mode = "idle"
        control_group.mode = "engaged"
      end
    end

    control_group.__next_move_to_target_update = love.math.random(0, 400) / 100

    :: before_on_the_way ::

    -----------------------------------------------------------------------------------------------
    if control_group.mode == "on_the_way" then

      if control_group.__last_checked == nil then control_group.__last_checked = 0 end

      -- group continues to move towards the walk target if engagement has ended
      if control_group.__last_checked < 0 then
        if has_enemies_in_reach(control_group, Battle) then
          control_group.last_mode = "on_the_way"
          control_group.mode = "engaged"
        end
        control_group.__last_checked = love.math.random(2, 7)
      end
      control_group.__last_checked = control_group.__last_checked - dt

      assert(type(control_group.slowest_unit_speed) == "number", "control_group.slowest_unit_speed is not a number")

      if control_group.slowest_unit_speed > 1000 then
        -- this happens in the first few seconds after spawn
        -- since the slowest unit speed is not yet calculated
        control_group.slowest_unit_speed = 100
      end

      local distance_to_target = math.sqrt(
        (control_group.center_x - control_group.walk_target_x) ^ 2 +
          (control_group.center_y - control_group.walk_target_y) ^ 2
      )

      if distance_to_target > 40 then -- todo: do we need this ??

        local rotation = math.atan2(
          control_group.walk_target_y - control_group.center_y,
          control_group.walk_target_x - control_group.center_x
        )

        local x_direction
        local y_direction

        if control_group.center_x < control_group.walk_target_x then x_direction = 1
        else x_direction = -1 end

        if control_group.center_y < control_group.walk_target_y then y_direction = 1
        else y_direction = -1 end

        local delta_x = x_direction * control_group.slowest_unit_speed * dt
        local delta_y = y_direction * control_group.slowest_unit_speed * dt

        if delta_x < -100 then
          print("delta_x is too small" .. delta_x)
          print("control_group.slowest_unit_speed" .. control_group.slowest_unit_speed)
        end

        if delta_x > 100 then
          print("delta_y is too big")
        end

        control_group.center_x = control_group.center_x + delta_x
        control_group.center_y = control_group.center_y + delta_y

        -- move each unit
        -- all units try to keep the same distance to the center point
        for _, unit in ipairs(control_group.units) do
          unit.rotation = rotation + math.pi / 2
          unit.x = unit.x + delta_x
          unit.y = unit.y + delta_y
        end

        -- move the center point to towards the target
        -- check if we have reached the target-destination
        -- then switch back to last_mode
        -- move the center point to towards the target
        -- all units will follow the center point
        -- all units get the same delta applied
        -- but the units themself manage to keep a good distance
        -- to the center point and other units
        -- problem is the different speed of units

      else
        -- we have reached the target !
        control_group.mode = control_group.last_mode
      end

    end -- on_the_way

  end -- for each control group


end

return ControlGroupMoveToTarget