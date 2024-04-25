local GenerateCampMap = {}

local seed = 0

---@param Camp Camp
function GenerateCampMap.generate_map(Camp)

  math.randomseed(seed)

  for y = 0, 10 do

    Camp.tile_map[y] = {}

    for x = 0, 10 do

      local tile_type_number = math.random(1, 100)

      local tile_type = "grass"

      if tile_type_number < 50 then
        tile_type = "grass"
      elseif tile_type_number < 70 then
        tile_type = "water"
      elseif tile_type_number < 90 then
        tile_type = "minerals"
      else
        tile_type = "factory"
      end

      local tile = Tile.new(
        x,
        y,
        tile_type,
        not (tile_type == "water"),
        love.graphics.newImage("camp/res/" .. tile_type .. ".png")
      )

      Camp.tile_map[y][x] = tile
      table.insert(Camp.tiles, tile)

    end

  end

end

return GenerateCampMap