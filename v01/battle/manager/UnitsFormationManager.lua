local UnitsFormationManager = {}


--- Moves all units near to each other if they belong to the same control group
--- @param Battle Battle
--- @param dt number
function UnitsFormationManager.update(Battle, dt)

  -- todo: if there are a lot of my fellow units in the target chunk,
  -- todo: i am fine with staying in the neighbour chunk ...

  -- check if my distance is too big to the command group
  for _, _u in ipairs(Battle.units) do

    --- @type BattleUnit
    local u = _u

    if u.control_group then

      if u.control_group.mode ~= "idle" then
        goto continue
      end

      local control_group = u.control_group

      local dx = control_group.center_x - u.x
      local dy = control_group.center_y - u.y

      local distance = math.sqrt(dx * dx + dy * dy)

      local min_distance = 100
      local max_distance = love.math.random(min_distance, #control_group.units * 50)

      if distance > max_distance then

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



return UnitsFormationManager