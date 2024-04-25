--- Draws the camp tiles on the screen
local TileRenderer = {}

---@param camp Camp
function TileRenderer.draw(camp)

  for _, tile in ipairs(camp.tiles) do

    love.graphics.setColor(1, 1, 1)

    love.graphics.draw(
      tile.image,
      tile.x * camp.tile_size + camp.view_x,
      tile.y * camp.tile_size + camp.view_y
    )

    --- owner outline based on the faction color
    if tile.owner then
      love.graphics.setColor(tile.owner.color)
      love.graphics.rectangle(
        "line",
        tile.x * camp.tile_size + camp.view_x,
        tile.y * camp.tile_size + camp.view_y,
        camp.tile_size,
        camp.tile_size
      )
      --- draw a colored shadow over the tile
      love.graphics.setColor(tile.owner.color[1], tile.owner.color[2], tile.owner.color[3], 0.1)
      love.graphics.rectangle(
        "fill",
        tile.x * camp.tile_size + camp.view_x,
        tile.y * camp.tile_size + camp.view_y,
        camp.tile_size,
        camp.tile_size
      )
    end




  end

end

return TileRenderer