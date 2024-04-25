local EffectDrawer = {}


function EffectDrawer.update(battle, dt)

  for i, effect in ipairs(battle.effects) do

    effect.duration = effect.duration - dt

    if effect.duration <= 0 then
      table.remove(battle.effects, i)
    end

  end

end

function EffectDrawer.draw(battle)

  for _, effect in ipairs(battle.effects) do

    -- todo: make origin correction better
    love.graphics.draw(
      effect.image,
      effect.x + 32,
      effect.y + 32,
      effect.rotation,
      1,
      1,
      32,
      32
    )

  end

end


return EffectDrawer