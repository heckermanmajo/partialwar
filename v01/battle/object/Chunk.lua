--- @class Chunk A chunk is used to group local units together for faster collision detection.
--- @field public x number
--- @field public y number
--- @field public size number
--- @field public units table<number, BattleUnit>
Chunk = {}
Chunk.new = function(x, y, size)
  return {
    x = x,
    y = y,
    size = size,
    units = {}
  }
end