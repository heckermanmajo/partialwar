local MoveToTargetManager = {}

--- @param Battle Battle
function MoveToTargetManager.update(Battle, dt)

  -- do not use velocity, just add the speed
  for _, _u in ipairs(Battle.units) do

    -- todo: if my command group is on DEFEND, then i only
    --       move towards an enemy if the enemy is very near
    --       otherwise i stay put
    --       and this only if i am a non-ranged unit

    --- @type BattleUnit
    local u = _u

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
        u.rotation = u.rotation + math.pi/2


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

  end


  
end




return MoveToTargetManager