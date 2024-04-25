--- Manages the physical collision of units in the battle and applies the collision forces as velocities.
--- This manager does not move the units, it only applies the collision forces to te velocity values of the units.
local CollisionManager = {}


--- @param Battle Battle
function CollisionManager.collide(Battle)

  for _, _c in ipairs(Battle.chunks) do

    --- @type Chunk
    local c = _c

    for _, _u in ipairs(c.units) do
      _u.x_velocity = 0
      _u.y_velocity = 0
    end

    for _, _u1 in ipairs(c.units) do

      for _, _u2 in ipairs(c.units) do

        --- @type BattleUnit
        local u1 = _u1
        --- @type BattleUnit
        local u2 = _u2

        if u1 ~= u2 then

          local x_collision = false
          local y_collision = false

          local size_u1 = u1.type.size
          local size_u2 = u2.type.size

          if u1.x < u2.x then
            if u1.x + size_u1 >= u2.x then
              x_collision = true
            end
          else
            if u2.x + size_u2 >= u1.x then
              x_collision = true
            end
          end

          if u1.y < u2.y then
            if u1.y + size_u1 >= u2.y then
              y_collision = true
            end
          else
            if u2.y + size_u2 >= u1.y then
              y_collision = true
            end
          end

          if x_collision and y_collision then
            -- collision
            local x_collision_depth = 0
            local y_collision_depth = 0

            if u1.x < u2.x then
              x_collision_depth = u1.x + size_u1 - u2.x
            else
              x_collision_depth = u2.x + size_u2 - u1.x
            end

            if u1.y < u2.y then
              y_collision_depth = u1.y + size_u1 - u2.y
            else
              y_collision_depth = u2.y + size_u2 - u1.y
            end

            -- apply velocity out of collision 1/4 of collision-depth for each unit
            local x_velocity = x_collision_depth * 4
            local y_velocity = y_collision_depth * 4

            if u1.x < u2.x then
              u1.x_velocity = u1.x_velocity - x_velocity
              u2.x_velocity = u2.x_velocity + x_velocity
            else
              u1.x_velocity = u1.x_velocity + x_velocity
              u2.x_velocity = u2.x_velocity - x_velocity
            end

            if u1.y < u2.y then
              u1.y_velocity = u1.y_velocity - y_velocity
              u2.y_velocity = u2.y_velocity + y_velocity
            else
              u1.y_velocity = u1.y_velocity + y_velocity
              u2.y_velocity = u2.y_velocity - y_velocity
            end

          end


        end


      end

    end


  end


end


return CollisionManager