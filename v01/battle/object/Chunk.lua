--- @class Chunk A chunk is used to group local units together for faster collision detection.
--- @field public x number
--- @field public y number
--- @field public size number
--- @field public units table<number, BattleUnit>
--- @field public is_checkpoint boolean
--- @field public spawn_point_for BattleFaction|nil
Chunk = {}
Chunk.new = function(x, y, size)
  return {
    x = x,
    y = y,
    size = size,
    units = {},
    is_checkpoint = false,
    spawn_point_for = nil
  }
end