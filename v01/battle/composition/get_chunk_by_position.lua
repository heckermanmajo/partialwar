

--- Get the chunk by the given position.
--- @param Battle Battle
--- @param x number
--- @param y number
--- @return Chunk
function get_chunk_by_position(Battle, x, y)

  local chunk_x = math.floor(x / Battle.chunk_size) * Battle.chunk_size
  local chunk_y = math.floor(y / Battle.chunk_size) * Battle.chunk_size

  if Battle.chunk_map[chunk_x] == nil then
    return nil
  end

  return Battle.chunk_map[chunk_x][chunk_y]

end

return get_chunk_by_position