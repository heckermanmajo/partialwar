local ChunkManager = require("battle/manager/ChunkManager")

local ProjectileManager = {}

function ProjectileManager.draw(Battle)

  for _, _projectile in ipairs(Battle.projectiles) do

    --- @type BattleProjectile
    local projectile = _projectile

    love.graphics.draw(
      projectile.weapon_type.projectile_image,
      projectile.x,
      projectile.y,
      projectile.rotation + math.pi / 2,
      1,
      1,
      projectile.weapon_type.projectile_image:getWidth() / 2,
      projectile.weapon_type.projectile_image:getHeight() / 2
    )


  end

end

--- @param Battle Battle
--- @param dt number
function ProjectileManager.update(Battle, dt)

  -- update the chunk of the projectile

  -- check for collision with some enemy unit

  -- check if it has reached the end of its range

  local projectiles_to_remove = {}

  for projectile_index, _projectile in ipairs(Battle.projectiles) do

    --- @type BattleProjectile
    local projectile = _projectile

    -- set the dx and dy if they are not set
    -- this is the case when the projectile is newly created
    if projectile.dx == 0 and projectile.dy then

      local dx = projectile.target_x - projectile.x
      local dy = projectile.target_y - projectile.y
      local distance = math.sqrt(dx * dx + dy * dy)
      local rotation = math.atan2(dy, dx)
      local dx_change_normalized = dx / distance
      local dy_change_normalized = dy / distance

      projectile.dx = dx_change_normalized
      projectile.dy = dy_change_normalized
      projectile.rotation = rotation

    end

    projectile.x = projectile.x + projectile.dx * 100 * dt
    projectile.y = projectile.y + projectile.dy * 100 * dt

    -- destroy the projectile if it has reached the end of its range
    local start_x = projectile.start_x
    local start_y = projectile.start_y
    local distance = math.sqrt((projectile.x - start_x) ^ 2 + (projectile.y - start_y) ^ 2)
    if distance > projectile.weapon_type.range then
      projectile.dead = true
      goto continue
    end

    -- check if projectile is outside of the map
    local map_width = Battle.world_width
    local map_height = Battle.world_height

    if projectile.x < 0 or projectile.x > map_width or projectile.y < 0 or projectile.y > map_height then
      projectile.dead = true
      goto continue
    end

    -- check if it hits sth.

    -- we dont want to crash, because we are outside the map ...
    projectile.x = Battle.get_x_position_in_world(projectile.x)
    projectile.y = Battle.get_y_position_in_world(projectile.y)

    local my_current_chunk = ChunkManager.get_chunk_by_position(projectile.x, projectile.y, Battle)
    local all_units_to_check = {}

    for _, u in ipairs(my_current_chunk.units) do
      table.insert(all_units_to_check, u)
    end

    local all_neighbour_chunks = ChunkManager.get_neighbour_chunks(my_current_chunk, Battle)

    for _, c in ipairs(all_neighbour_chunks) do
      for _, u in ipairs(c.units) do
        table.insert(all_units_to_check, u)
      end
    end

    for _, u in ipairs(all_units_to_check) do

      if u.faction ~= projectile.faction then

        local projectile_collision_box = {
          x = projectile.x + 25,
          y = projectile.y + 25,
          width = 10,
          height = 10
        }

        local unit_collision_box = {
          x = u.x,
          y = u.y,
          width = 64,
          height = 64
        }

        local collision = false

        if projectile_collision_box.x < unit_collision_box.x + unit_collision_box.width and
          projectile_collision_box.x + projectile_collision_box.width > unit_collision_box.x and
          projectile_collision_box.y < unit_collision_box.y + unit_collision_box.height and
          projectile_collision_box.y + projectile_collision_box.height > unit_collision_box.y then
          collision = true
        end

        if collision then

          -- apply armor and shield level
          --- @type BattleUnit
          local target = u
          local damage = projectile.weapon_type.damage

          if target.hp < 0 then
            goto continue
          end

          local we_have_a_hit = false

          if target.type.shield_level == 1 then

            local rand = math.random(0, 100)
            -- 40% chance to block the attack
            if rand < 40 then
              we_have_a_hit = true
            end

          elseif target.type.shield_level == 2 then

            local rand = math.random(0, 100)
            -- 80% chance to block the attack
            if rand < 20 then
              we_have_a_hit = true
            end

          else

            we_have_a_hit = true

          end

          -- check if armor level, if so reduce damage by 60%
          if we_have_a_hit and target.type.armor_level == 1 then
            damage = damage * 0.6
          end

          if we_have_a_hit then
            target.hp = target.hp - damage
            projectile.dead = true
          end

          goto continue

        end

      end --- end of faction check

    end -- end of loop over units in chunk

    :: continue :: -- continue with the next projectile
  end

  local projectiles_to_delete = {}
  for _, _projectile in ipairs(Battle.projectiles) do
    if _projectile.dead then
      table.insert(projectiles_to_delete, _projectile)
    end
  end

  for _, _projectile in ipairs(projectiles_to_delete) do
    for i, _p in ipairs(Battle.projectiles) do
      if _p == _projectile then
        table.remove(Battle.projectiles, i)
      end
    end
  end


end

return ProjectileManager