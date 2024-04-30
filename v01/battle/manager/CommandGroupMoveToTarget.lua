local get_chunk_by_position = require("v01/battle/composition/get_chunk_by_position")
local get_chunks_around_me = require("v01/battle/composition/get_chunks_around_me")
--- A control group can have a move target.
--- The group as a whole will move towards the target.
--- If there is an enemy between the group and the target,
--- the group will engage the enemy: this means that all units
--- will use their "attack and follow the nearest enemy" AI.
--- with and max-distance, after which the group will re-order
--- itself into formation, by calculating the center of the group
--- and arranging the units around it.


local ControlGroupMoveToTarget = {}

--- @param Battle Battle
--- @param dt number
function ControlGroupMoveToTarget.update(Battle, dt)

  -- this does not need to be done every frame for all control groups
  -- so we can randomize the next update time

  for _, control_group in ipairs(Battle.control_groups) do

    if control_group.__next_move_to_target_update == nil then
      control_group.__next_move_to_target_update = love.math.random(0, 400) / 100
    end

    if control_group.__next_move_to_target_update > 0 then
      control_group.__next_move_to_target_update = control_group.__next_move_to_target_update - dt
      goto continue
    end

    -- calculate the slowest unit speed
    control_group.slowest_unit_speed = 999999999
    for _, unit in ipairs(control_group.units) do
      if unit.type.speed < control_group.slowest_unit_speed then
        control_group.slowest_unit_speed = unit.type.speed
      end
    end


    -- ENGAGED MODE : The control group is in a fight
    if control_group.mode == "engaged" then
      -- check if units are still engaged ...

      local some_unit_is_engaged = false

      for _, unit in ipairs(control_group.units) do

        if unit.target_unit then

          local distance_to_target = math.sqrt(
            (unit.x - unit.target_unit.x) ^ 2 +
              (unit.y - unit.target_unit.y) ^ 2
          )

          local max_distance
          if unit.type.weapon.is_ranged then
            max_distance = unit.type.weapon.range
          else
            max_distance = 300
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

        if chunk.is_checkpoint
          and chunk.faction ~= control_group.faction
          and distance_to_chunk < smallest_distance
        then
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

    if control_group.mode == "idle" then
      -- we do nothing
    end

    if control_group.mode == "on_the_way" then

      local distance_to_target = math.sqrt(
        (control_group.center_x - control_group.target_chunk.x) ^ 2 +
          (control_group.center_y - control_group.target_chunk.y) ^ 2
      )

      if distance_to_target > 100 then

        local rotation = math.atan2(
          control_group.target_chunk.y - control_group.center_y,
          control_group.target_chunk.x - control_group.center_x
        )

        local delta_x = math.cos(rotation) * control_group.slowest_unit_speed
        local delta_y = math.sin(rotation) * control_group.slowest_unit_speed

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
    end

    control_group.__next_move_to_target_update = love.math.random(0, 400) / 100

    :: continue ::

  end

end

return ControlGroupMoveToTarget