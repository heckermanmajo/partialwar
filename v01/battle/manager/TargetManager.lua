local TargetManager = {}

--- @param Battle Battle
--- @param dt number
function TargetManager.update(Battle, dt)

  for _, u in ipairs(Battle.units) do

    -- todo: only select a targte if it is not already selected by more than
    --       3 units
    -- todo: only do this all whatever 0.5 seconds per unit ...
    -- todo: if a unit self selects a targte, the unit can change the targte to
    --       a nearer one or a more valuable one...

    --- @type ControlGroup
    local my_control_group = u.control_group
    if my_control_group.mode ~= "engaged" then
      goto continue
    end


    if not u.next_target_selection then
      u.next_target_selection = 0
    end

    if not u.target and u.next_target_selection and u.next_target_selection < 0 then
      -- select nearest enemy that is not my faction
      u.attacking = false
      TargetManager.selectNearestEnemy(Battle, u)
      u.next_target_selection = love.math.random(2,7)
      goto continue
    end

    if u.next_target_selection > 0 then
      u.next_target_selection = u.next_target_selection - dt
      goto continue
    end

    -- select nearest enemy that is not my faction
    TargetManager.selectNearestEnemy(Battle, u)
    u.attacking = false
    u.next_target_selection = love.math.random(2,7)

    ::continue::
  end

end

function TargetManager.selectNearestEnemy(Battle, u)
  local nearest_enemy = nil
  local nearest_distance = 1000000

  -- todo: search via near chunks

  for _, e in ipairs(Battle.units) do
    if e.faction ~= u.faction then
      local distance = math.sqrt((u.x - e.x)^2 + (u.y - e.y)^2)
      if distance < nearest_distance then
        nearest_distance = distance

        -- check here how many units are targeting the same unit
        -- if more than 6, select another one
        -- todo: this can result in a shaking of units if a log of units run towards each other

        local count = 0

        for _, _u in ipairs(Battle.units) do
          if _u.target == e then
            count = count + 1
          end
        end

        --if count < 50 then
        --  nearest_enemy = e
        --end
        nearest_enemy = e

      end
    end
  end

  u.target = nearest_enemy
end

return TargetManager