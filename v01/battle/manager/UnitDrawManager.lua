local UnitDrawManager = {}

local shield_one_image = love.graphics.newImage("battle/res/round_shield.png")
local shield_two_image = love.graphics.newImage("battle/res/square_shield.png")

--- @param Battle Battle
function UnitDrawManager.draw(Battle)

  for _, _unit in ipairs(Battle.units) do
    --- @type BattleUnit
    local unit = _unit

    local image = unit.type.images[unit.faction.name]
    local rotation = unit.rotation
    local unit_size = unit.type.size
    local origin_correction = unit_size / 2
    love.graphics.draw(
      image, -- image
      unit.x + origin_correction, -- x
      unit.y + origin_correction, -- y
      rotation, -- rotation
      1, -- scale x
      1, -- scale y
      unit_size / 2, -- origin x
      unit_size / 2 -- origin y
    )
    -- rotation, etc.

    -- draw a weapon on the unit

    local weapon_image = unit.type.weapon.image
    local weapon_rotation = unit.rotation

    local weapon_width = weapon_image:getWidth()
    local weapon_height = weapon_image:getHeight()

    local pixel_to_draw_the_spear_further_x = 0
    local pixel_to_draw_the_spear_further_y = 0

    local pixel_to_draw_the_spear_further = 0

    local time_per_attack = unit.type.weapon.cool_down

    if unit.type.weapon.is_ranged then
      -- if the unit is a ranged unit, we draw the weapon before the unit
      -- this allows for a weapon in the front of the unit
      pixel_to_draw_the_spear_further = 14

    else

      -- if the weapon is a melee weapon, we draw the weapon on the side (done by the
      -- position of the weapon in the image file)
      -- however, we want to draw the weapon further if the unit has just attacked
      if unit.last_attack_time > time_per_attack / 2 then
        pixel_to_draw_the_spear_further = 32
      end

    end

    local rotated_rotation = unit.rotation + math.pi / 2
    pixel_to_draw_the_spear_further_x = math.cos(rotated_rotation) * pixel_to_draw_the_spear_further
    pixel_to_draw_the_spear_further_y = math.sin(rotated_rotation) * pixel_to_draw_the_spear_further

    love.graphics.draw(
      weapon_image, -- image
      unit.x - pixel_to_draw_the_spear_further_x + origin_correction, -- x
      unit.y - pixel_to_draw_the_spear_further_y + origin_correction, -- y
      weapon_rotation, -- rotation
      1, -- scale x
      1, -- scale y
      weapon_width / 2, -- origin x
      weapon_height / 2 -- origin y
    )

    if unit.type.shield_level == 0 then
      -- no shield
    elseif unit.type.shield_level == 1 then
      love.graphics.draw(
        shield_one_image, -- image
        unit.x + origin_correction, -- x
        unit.y + origin_correction, -- y
        rotation, -- rotation
        1, -- scale x
        1, -- scale y
        shield_one_image:getWidth() / 2, -- origin x
        shield_one_image:getHeight() / 2 -- origin y
      )
    elseif unit.type.shield_level == 2 then
      love.graphics.draw(
        shield_two_image, -- image
        unit.x + origin_correction, -- x
        unit.y + origin_correction, -- y
        rotation, -- rotation
        1, -- scale x
        1, -- scale y
        shield_two_image:getWidth() / 2, -- origin x
        shield_two_image:getHeight() / 2 -- origin y
      )
    end

    --- draw a health bar above the unit
    local health_bar_width = unit_size
    local health_bar_height = 5
    local health_bar_x = unit.x
    local health_bar_y = unit.y - health_bar_height - 2
    local health_bar_fill_width = health_bar_width * (unit.hp / 100)

    if unit.hp < 100 then
      love.graphics.setColor(0, 0, 0)
      love.graphics.rectangle("fill", health_bar_x, health_bar_y, health_bar_width, health_bar_height)
      love.graphics.setColor(0, 1, 0)
      love.graphics.rectangle("fill", health_bar_x, health_bar_y, health_bar_fill_width, health_bar_height)
      love.graphics.setColor(1, 1, 1)
    end

    -- draw collision outline of unit
    if Battle.debug then

      --love.graphics.setColor(unit.faction.color)
      --love.graphics.rectangle("line", unit.x, unit.y, image:getWidth(), image:getHeight())
      --love.graphics.setColor(255 / 255, 255 / 255, 255 / 255)

    end

  end

end

return UnitDrawManager