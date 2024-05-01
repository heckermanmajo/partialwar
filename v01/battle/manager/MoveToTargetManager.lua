local MoveToTargetManager = {}

--- Update the units to move towards their target - the target is an enemy unit
--- @param Battle Battle
--- @param dt number
function MoveToTargetManager.update(Battle, dt)

  -- do not use velocity, just add the speed
  for _, _u in ipairs(Battle.units) do

    --- @type BattleUnit
    local u = _u

    -- if this unit is part of a control group and the control_group
    -- is not engaged in battle, we dont move the unit to a "target"
    -- since this unit should not have a target
    if u.control_group and u.control_group.mode ~= "engaged" then

      -- if the unit has a target, we remove it, since the control group
      -- is not engaged in battle
      if u.target then
        u.target = nil
      end

      goto continue

    end

    if u.target then
      local target_x = u.target.x
      local target_y = u.target.y

      local dx = target_x - u.x
      local dy = target_y - u.y

      local distance = math.sqrt(dx * dx + dy * dy)

      -- running towards the target

      local cond = distance > u.type.weapon.range and not u.attacking
      if u.type.weapon.is_ranged then
        cond = distance > u.type.weapon.range - 200
      end

      if cond then

        -- rotate the units to face the target
        -- unit rotation u.rotation
        -- target
        local rotation_to_target = math.atan2(dy, dx)
        u.rotation = rotation_to_target
        u.rotation = u.rotation + math.pi / 2

        local speed = u.type.speed
        if dx < 0 then
          u.x = u.x - speed * dt
        elseif dx > 0 then
          u.x = u.x + speed * dt
        end

        if dy < 0 then
          u.y = u.y - speed * dt
        elseif dy > 0 then
          u.y = u.y + speed * dt
        end

      end
    end

    :: continue ::

  end


end

return MoveToTargetManager