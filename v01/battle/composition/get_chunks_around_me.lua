--- @param Battle Battle
--- @param chunk Chunk
--- @param also_diagonal boolean If true, also return diagonal chunks, otherwise only return chunks that are directly adjacent to the given chunk.
--- @param max_distance_of_neighbour_chunks number The maximum distance of neighbour chunks to the given chunk, so we can decide if we want only the direct n
---        neighbours or also the neighbours of the neighbours, etc. 1 means only direct neighbours, 2 means also neighbours of neighbours, etc.
function get_chunks_around_me(Battle, chunk, also_diagonal, max_distance_of_neighbour_chunks)

  local chunk_size = Battle.chunk_size
  local chunk_x = chunk.x
  local chunk_y = chunk.y

  local neighbour_chunks = {}

  for distance = 1, max_distance_of_neighbour_chunks do
    for x = -distance, distance do
      for y = -distance, distance do

        if not also_diagonal and (x == y or x == -y) then
          goto continue
        end

        local neighbour_chunk_x = chunk_x + x * chunk_size
        local neighbour_chunk_y = chunk_y + y * chunk_size

        if Battle.chunk_map[neighbour_chunk_x] and Battle.chunk_map[neighbour_chunk_x][neighbour_chunk_y] then
          table.insert(neighbour_chunks, Battle.chunk_map[neighbour_chunk_x][neighbour_chunk_y])
        end

        ::continue::
      end
    end
  end

  return neighbour_chunks

end

return get_chunks_around_me