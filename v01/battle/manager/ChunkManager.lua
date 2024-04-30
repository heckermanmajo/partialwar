--- Updates the chunks and the units in them.
--- @class ChunkManager
--- @field init_chunks fun(Battle: Battle):void
--- @field draw fun(Battle: Battle):void
--- @field init_unit fun(unit: BattleUnit, battle: Battle):void
--- @field remove_unit_from_chunk fun(unit: BattleUnit, chunk: Chunk):void
--- @field update_all_unit_positions fun(Battle: Battle, dt: number):void
--- @field get_chunk_by_position fun(x: number, y: number, Battle: Battle):Chunk
local ChunkManager = {}

--- Initializes the chunks for the battle.
--- @param Battle Battle
function ChunkManager.init_chunks(Battle)

  assert(Battle, "Battle is nil")
  assert(Battle.chunk_size, "Battle.chunk_size is nil")
  assert(Battle.world_width, "Battle.world_width is nil")
  assert(Battle.world_height, "Battle.world_height is nil")
  assert(Battle.chunks, "Battle.chunks is nil")

  local chunk_size = Battle.chunk_size

  for x = 0, Battle.world_width, chunk_size do

    for y = 0, Battle.world_height, chunk_size do

      local chunk = Chunk.new(x, y, chunk_size)
      table.insert(Battle.chunks, chunk)
      if not Battle.chunk_map[x] then
        Battle.chunk_map[x] = {}
      end
      Battle.chunk_map[x][y] = chunk

    end

  end

end

--- Draws the chunks.
--- @param Battle Battle
--- @return void
function ChunkManager.draw(Battle)

  if not Battle.debug then
    return
  end

  for _, _c in ipairs(Battle.chunks) do

    local padding = 200

    --[[local chunk_is_in_view = (
      _c.x + Battle.camera_x_position > 0 and
      _c.x + Battle.camera_x_position < love.graphics.getWidth() and
      _c.y + Battle.camera_y_position > 0 and
      _c.y + Battle.camera_y_position < love.graphics.getHeight()
    )]]
    -- add padding to the chunks
    local chunk_is_in_view = (
      _c.x + Battle.camera_x_position > -padding and
      _c.x + Battle.camera_x_position < love.graphics.getWidth() + padding and
      _c.y + Battle.camera_y_position > -padding and
      _c.y + Battle.camera_y_position < love.graphics.getHeight() + padding
    )


    if chunk_is_in_view then
      --- @type Chunk
      local c = _c
      love.graphics.rectangle("line", c.x + Battle.camera_x_position, c.y + Battle.camera_y_position, c.size, c.size)
      -- draw the number of units in the chunk at the left top corner
      love.graphics.print(#c.units, c.x + Battle.camera_x_position, c.y + Battle.camera_y_position)
    end
  end

end

--- Removes a unit from a chunk.
--- @param unit BattleUnit
--- @param chunk Chunk
--- @return void
function ChunkManager.remove_unit_from_chunk(unit, chunk)

  for index, _unit in ipairs(chunk.units) do
    if _unit == unit then
      table.remove(chunk.units, index)
      return
    end
  end

end

--- Updates the chunk value of all units in a given battle.
--- @param Battle Battle
--- @param dt number
--- @return void
function ChunkManager.update_all_unit_positions(Battle, dt)

  -- todo: dont update every frame

  for _, _u in ipairs(Battle.units) do

    --- @type BattleUnit
    local u = _u

    local my_old_chunk = u.current_chunk
    local new_chunk = ChunkManager.get_chunk_by_position(u.x, u.y, Battle)

    if my_old_chunk ~= new_chunk then
      if my_old_chunk then
        ChunkManager.remove_unit_from_chunk(u, my_old_chunk)
      end
      table.insert(new_chunk.units, u)
      u.current_chunk = new_chunk
    end

  end

end

--- Returns the chunk at the given position.
--- @param x number
--- @param y number
--- @param Battle Battle
--- @return Chunk
function ChunkManager.get_chunk_by_position(x, y, Battle)

  local _x = Battle.get_x_position_in_world(x)
  local _y = Battle.get_y_position_in_world(y)

  local chunk_size = Battle.chunk_size
  local chunk_x = math.floor(_x / chunk_size) * chunk_size
  local chunk_y = math.floor(_y / chunk_size) * chunk_size

  return Battle.chunk_map[chunk_x][chunk_y]

end

--- Returns the neighbour chunks of a given chunk.
--- @param chunk Chunk
--- @param Battle Battle
--- @return Chunk[]
function ChunkManager.get_neighbour_chunks(chunk, Battle)

  local chunk_size = Battle.chunk_size
  local chunk_x = chunk.x
  local chunk_y = chunk.y

  local neighbour_chunks = {}

  for x = -chunk_size, chunk_size, chunk_size do
    for y = -chunk_size, chunk_size, chunk_size do
      if x ~= 0 or y ~= 0 then
        local out_of_map = chunk_x + x < 0 or chunk_x + x > Battle.world_width or chunk_y + y < 0 or chunk_y + y > Battle.world_height
        if out_of_map then
          goto continue
        end
        local neighbour_chunk = Battle.chunk_map[chunk_x + x][chunk_y + y]
        table.insert(neighbour_chunks, neighbour_chunk)
        :: continue ::
      end
    end
  end

  return neighbour_chunks

end

return ChunkManager