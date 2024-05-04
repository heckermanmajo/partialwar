--- @class Chunk A chunk is used to group local units together for faster collision detection.
--- @field public x number
--- @field public y number
--- @field public size number
--- @field public units table<number, BattleUnit>
--- @field public is_checkpoint boolean
--- @field public current_owner Faction|nil
Chunk = {}
Chunk.new = function(x, y, size)
  return {
    x = x,
    y = y,
    size = size,
    units = {},
    -- todo: use this number to be able to look for enemies
    --       nearby
    -- this allows for faster projectile collision detection
    -- this allows for faster target acquisition
    number_player_units = 0,
    number_enemy_units = 0,
    player_units = {},
    enemy_units = {},

    is_checkpoint = false,
    current_owner = nil
  }
end