local AttackManager = {}

AttackManager.time_since_last_second = 0

--- @param battle Battle
function AttackManager.update(battle, dt)

  AttackManager.time_since_last_second = AttackManager.time_since_last_second + dt

  --- set the hits we have received to 0 this second
  --- each unit can only be hit twice per second
  if AttackManager.time_since_last_second > 2 then
    AttackManager.time_since_last_second = 0
    for _, u in ipairs(battle.units) do
      u.hits_last_second = 0
    end
  end

  for _, u in ipairs(battle.units) do

    local attack_speed = u.type.weapon.cool_down
    local damage = u.type.weapon.damage

    if type(u.last_attack_time) == "nil" then
      u.last_attack_time = 0
    end

    if u.target then

      if u.last_attack_time > 0 then

        u.last_attack_time = u.last_attack_time - dt
        u.attacking = true  -- since i have attacked not long ago

        -- rotate the units to face the target
        -- unit rotation u.rotation
        local dx = u.target.x - u.x
        local dy = u.target.y - u.y
        local rotation_to_target = math.atan2(dy, dx)
        u.rotation = rotation_to_target + math.pi / 2

      else

        local distance = math.sqrt((u.x - u.target.x) ^ 2 + (u.y - u.target.y) ^ 2)

        assert(u.type, "u.type is nil")
        assert(u.type.weapon, "u.type.weapon is nil")
        assert(type(u.type.weapon.range) == "number", "u.type.weapon.range is not a number " .. type(u.type.weapon.range))

        if distance < (u.type.weapon.range or 300) then

          u.last_attack_time = attack_speed

          if u.type.weapon.is_ranged then

            local offset = 32

            local projectile = BattleProjectile.new(
              u.x + offset,
              u.y + offset,
              u.target.x + offset,
              u.target.y + offset,
              u.type.weapon,
              u.faction
            )
            table.insert(battle.projectiles, projectile)

          else

            u.target.hp = u.target.hp - damage
            u.attacking = true

            -- apply armor and shield level
            --- @type BattleUnit
            local target = u.target

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
              if target.hits_last_second < 1 then
                target.hits_last_second = target.hits_last_second + 1
                target.hp = target.hp - damage
              end
            end

          end

        end -- unit is in range to attack target

      end -- unit is ready to attack

    end -- unit has target

  end -- for all units loop

end

return AttackManager