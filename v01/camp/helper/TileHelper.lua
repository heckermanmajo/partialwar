local TileHelper = {}

--- This function returns a tile by its position.
---@param camp Camp
---@param x number
---@param y number
---@return Tile|nil
function TileHelper.get_tile_by_position(camp, x, y)
  for _, tile in ipairs(camp.tiles) do
    if tile.x == x and tile.y == y then
      return tile
    end
  end
  return nil
end

--- This function returns all tiles around a given tile.
---@param camp Camp
---@param tile Tile
---@return table<Tile>
function TileHelper.get_all_tiles_around_given_tile(camp, tile, include_diagonals)
  local tiles = {}
  for _, t in ipairs(camp.tiles) do
    if t.x == tile.x - 1 and t.y == tile.y then
      table.insert(tiles, t)
    end
    if t.x == tile.x + 1 and t.y == tile.y then
      table.insert(tiles, t)
    end
    if t.x == tile.x and t.y == tile.y - 1 then
      table.insert(tiles, t)
    end
    if t.x == tile.x and t.y == tile.y + 1 then
      table.insert(tiles, t)
    end

    if include_diagonals then
      if t.x == tile.x - 1 and t.y == tile.y - 1 then
        table.insert(tiles, t)
      end
      if t.x == tile.x + 1 and t.y == tile.y - 1 then
        table.insert(tiles, t)
      end
      if t.x == tile.x - 1 and t.y == tile.y + 1 then
        table.insert(tiles, t)
      end
      if t.x == tile.x + 1 and t.y == tile.y + 1 then
        table.insert(tiles, t)
      end
    end

  end
  return tiles
end

return TileHelper