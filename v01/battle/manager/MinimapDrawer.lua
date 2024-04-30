local MinimapDrawer = {}

---@param battle Battle
function MinimapDrawer.draw(battle)

  -- draw one pixel for each chunk
  -- each chunk contains units
  -- draw red if only enemy units are in this chunk
  -- draw blue if only player units are in this chunk
  -- draw purple if both are in this chunk

  local width = battle.world_width / battle.chunk_size
  local height = battle.world_height / battle.chunk_size
  local scale = battle.chunk_size / 25
  width = width * scale
  height = height * scale
  local display_size = scale

  local screen_x = love.graphics.getWidth() - width - 30
  local screen_y = love.graphics.getHeight() - height - 30

  for _, chunk in ipairs(battle.chunks) do

    local x = chunk.x / chunk.size
    local y = chunk.y / chunk.size

    local color = { 0, 0, 0 }

    local player_units = 0
    local enemy_units = 0

    for _, unit in ipairs(chunk.units) do

      if unit.faction == battle.factions.player then
        player_units = player_units + 1
      end

      if unit.faction == battle.factions.enemy then
        enemy_units = enemy_units + 1
      end

    end

    if player_units > 0 and enemy_units > 0 then
      local rand = love.math.random(0, 100)
      if rand < 70 then
        color = { 0.4, 0, 0.4 }
      else
        color = { 1, 1, 0 }
      end
      --color = { 0.4, 0, 0.4 }
    elseif player_units > 0 then
      color = { 0.2, 0.7, 1 }
    elseif enemy_units > 0 then
      color = { 1, 0, 0 }
    end

    if chunk.is_checkpoint then
      -- draw a yellow line around the checkpoint
      love.graphics.setColor(1, 1, 0)
      love.graphics.rectangle("line", x * display_size + screen_x-1, y * display_size + screen_y-1, 4+2, 4+2)

      -- todo

    end


    love.graphics.setColor(color)
    love.graphics.rectangle("fill", x * display_size +  screen_x, y * display_size + screen_y, 4, 4)

  end

  -- draw rhe current screen view as a small rect on the minimap

  do
    local start_position_x = screen_x - battle.camera_x_position / battle.chunk_size * scale
    local width = love.graphics.getWidth() / battle.chunk_size * scale
    local start_position_y = screen_y - battle.camera_y_position / battle.chunk_size * scale
    local height = love.graphics.getHeight() / battle.chunk_size * scale
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", start_position_x, start_position_y, width, height)
  end

  love.graphics.setColor(1, 1, 1)

  -- if we click on the minimap jump there with the view

  local x, y = love.mouse.getPosition()
  local minimap_start_x = love.graphics.getWidth() - width - 30
  local minimap_start_y = love.graphics.getHeight() - height - 30
  local minimap_end_x = minimap_start_x + width
  local minimap_end_y = minimap_start_y + height

  if x > minimap_start_x and x < minimap_end_x and y > minimap_start_y and y < minimap_end_y then
    if love.mouse.isDown(1) then
      local x = (x - minimap_start_x) / scale * battle.chunk_size
      local y = (y - minimap_start_y) / scale * battle.chunk_size
      battle.camera_x_position = -x + love.graphics.getWidth() / 2
      battle.camera_y_position = -y + love.graphics.getHeight() / 2
    end
  end

end

return MinimapDrawer