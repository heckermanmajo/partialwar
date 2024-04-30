local DeadBodyRemover = {}

local dead_unit_image = love.graphics.newImage("battle/res/dead.png")

--- @param Battle Battle
function DeadBodyRemover.update(Battle, dt)

  -- remove all dead units from the chunks
  for j = #Battle.chunks, 1, -1 do
    local c = Battle.chunks[j]
    for k = #c.units, 1, -1 do
      local u = c.units[k]
      if u.hp <= 0 then
        table.remove(c.units, k)
      end
    end
  end

  -- remove all dead units from the targets
  for i = #Battle.units, 1, -1 do

    local u = Battle.units[i]

    if u.target_unit and u.target_unit.hp <= 0 then
      u.target_unit = nil
    end

  end


  -- remove all dead units from the units-table in the battle
  -- and also remove the unit from its command group
  for i = #Battle.units, 1, -1 do

    local u = Battle.units[i]

    if u.hp <= 0 then

      -- remove the unit from its command group
      if u.control_group then
        for j = #u.control_group.units, 1, -1 do
          if u.control_group.units[j] == u then
            table.remove(u.control_group.units, j)
          end
        end
        u.control_group = nil
      end


      table.remove(Battle.units, i)

      -- create the dead unit effect
      table.insert(Battle.effects, Effect.new(
        dead_unit_image,
        u.x,
        u.y,
        u.rotation,
        200
      ))


    end

  end






end





return DeadBodyRemover