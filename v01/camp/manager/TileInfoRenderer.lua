local TileInfoRenderer = {}

TileInfoRenderer.button_cool_down = 0

---@param camp Camp
---@param tile Tile
function TileInfoRenderer.draw(camp, tile)

  -- draw a side bar to tzhe right
  love.graphics.setColor(0.4, 0.4, 0.4)
  love.graphics.rectangle("fill", 1280 + 200, 0, 640, 720 + 200)

  if tile.owner then
    love.graphics.setColor(tile.owner.color)
    love.graphics.print("Owner: " .. tile.owner.name, 1300 + 200, 50)
  end

  if tile.type == "grass" then
    love.graphics.setColor(0.1, 0.8, 0.1)
    love.graphics.print("Type: Grass", 1300 + 200, 100)
  elseif tile.type == "water" then
    love.graphics.setColor(0.1, 0.1, 0.8)
    love.graphics.print("Type: Water", 1300 + 200, 100)
  elseif tile.type == "minerals" then
    love.graphics.setColor(0.8, 0.8, 0.1)
    love.graphics.print("Type: Minerals", 1300 + 200, 100)
  elseif tile.type == "factory" then
    love.graphics.setColor(0.8, 0.8, 0.1)
    love.graphics.print("Type: Factory", 1300 + 200, 100)
  end

  if tile.army then
    love.graphics.setColor(tile.army.faction.color)
    local string = "Army: " .. tile.army.command_points .. " || Lv. " .. tile.army.army_level
    love.graphics.print(string, 1300 + 200, 150)
  end

  local i_can_improve_my_army = false
  if tile.type == "factory" and tile.owner == camp.factions.player and tile.army ~= nil then
    i_can_improve_my_army = true
  end

  local i_can_create_an_army = false
  if tile.type == "factory" and tile.owner == camp.factions.player and tile.army == nil then
    i_can_create_an_army = true
  end

  local i_can_level_up_army = false
  if (
    tile.type == "factory"
      and tile.owner == camp.factions.player
      and tile.army ~= nil
      and tile.army.army_level < 9 -- todo: max level as variable in battle
      and tile.army.command_points > tile.army.army_level * 400
  ) then
    i_can_level_up_army = true
  end

  local enough_actions_left = tile.factory_actions_this_turn > 0

  -- create and improve army buttons

  if i_can_improve_my_army and enough_actions_left then
    love.graphics.setColor(0.1, 0.8, 0.1)
    love.graphics.rectangle("fill", 1300 + 200, 200, 200, 50)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Improve Army", 1300 + 200, 200)
  end

  -- button next to the improve army button
  if i_can_level_up_army and enough_actions_left then
    love.graphics.setColor(0.1, 0.8, 0.1)
    love.graphics.rectangle("fill", 1300 + 200, 300, 200, 50)
    love.graphics.setColor(0, 0, 0)
    local cost = tile.army.army_level * 300
    love.graphics.print("Level Up Army ( - "..cost..")", 1300 + 200, 300)
  end

  if i_can_create_an_army and enough_actions_left then
    love.graphics.setColor(0.1, 0.8, 0.1)
    love.graphics.rectangle("fill", 1300 + 200, 200, 200, 50)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Create Army", 1300 + 200, 200)
  end


end

---@param camp Camp
---@param tile Tile
---@param dt number
function TileInfoRenderer.update(camp, tile, dt)

  local enough_actions_left = tile.factory_actions_this_turn > 0

  -- set mouseclick to consumed if the mouse is over the tile info
  local mouse_x, mouse_y = love.mouse.getPosition()
  if mouse_x > 1300 + 200 and mouse_x < 1300 + 200 + 200 and mouse_y > 200 and mouse_y < 200 + 50 then
    camp.click_consumed_by_ui = true
  end

  if mouse_x > 1300 + 200 and mouse_x < 1300 + 200 + 200 and mouse_y > 300 and mouse_y < 300 + 50 then
    camp.click_consumed_by_ui = true
  end

  local i_can_improve_my_army = false
  if tile.type == "factory" and tile.owner == camp.factions.player and tile.army ~= nil then
    i_can_improve_my_army = true
  end

  local i_can_create_an_army = false
  if tile.type == "factory" and tile.owner == camp.factions.player and tile.army == nil then
    i_can_create_an_army = true
  end

  local i_can_level_up_army = false
  if (
    tile.type == "factory"
      and tile.owner == camp.factions.player
      and tile.army ~= nil
      and tile.army.army_level < 9 -- todo: max level as variable in battle
      and tile.army.command_points > tile.army.army_level * 300
  ) then
    i_can_level_up_army = true
  end

  TileInfoRenderer.button_cool_down = TileInfoRenderer.button_cool_down - dt

  if TileInfoRenderer.button_cool_down > 0 then
    return
  end

  -- remove this from the global gold
  local mouse_x, mouse_y = love.mouse.getPosition()

  if mouse_x > 1300 + 200 and mouse_x < 1300 + 200 + 200 and mouse_y > 200 and mouse_y < 200 + 50 then

    if love.mouse.isDown(1) == false then
      return
    end

    if camp.factions.player.money < 100 then
      return
    end

    if i_can_create_an_army and enough_actions_left then
      tile.factory_actions_this_turn = tile.factory_actions_this_turn - 1
      tile.army = Army.new(camp.factions.player, 100)
      tile.army.movement_this_turn = true
      camp.factions.player.money = camp.factions.player.money - 100
    end

    if i_can_improve_my_army and enough_actions_left then
      tile.factory_actions_this_turn = tile.factory_actions_this_turn - 1
      tile.army.command_points = tile.army.command_points + 100
      camp.factions.player.money = camp.factions.player.money - 100
    end

    TileInfoRenderer.button_cool_down = 0.2

  end

  if mouse_x > 1300 + 200 and mouse_x < 1300 + 200 + 200 and mouse_y > 300 and mouse_y < 300 + 50 then

    if love.mouse.isDown(1) == false then
      return
    end

    if camp.factions.player.money < tile.army.army_level * 300 then
      return
    end

    if i_can_level_up_army and enough_actions_left then
      tile.factory_actions_this_turn = tile.factory_actions_this_turn - 3
      camp.factions.player.money = camp.factions.player.money - tile.army.army_level * 300
      tile.army.army_level = tile.army.army_level + 1
    end

    TileInfoRenderer.button_cool_down = 0.2

  end

end

return TileInfoRenderer