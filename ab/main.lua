--[[
  - simplest auto battler
  - der screen ist die karte
  - links und rechts spawnen units

]]
Camera = {x = 0, y = 0, zoom = 1}
Chunk = {
  instances = {},
  mapped_on_position = {},
  width = 256,
  height = 256
}
Chunk.__index = Chunk
function Chunk.new(x,y)
  local chunk = {
    x = x,
    y = y,
    units = {}
  }
  setmetatable(chunk, Chunk)
  return chunk
end

Unit = {
  instances = {},
  types = {} -- todo: load here some images and stats
}
Unit.__index = Unit

function Unit:new(x,y,type)
  local unit = {
    x = x,
    y = y,
    type = type,
    target = nil,
    time_since_attack = 0,
    time_until_next_attack_update = 0,
    current_chunk = nil,
    x_velocity = 0,
    y_velocity = 0,
    rotation = 0,
    attacking = false,
    hits_last_second = 0,
    target_chunk = nil
  }
  setmetatable(unit, Unit)
  table.insert(Unit.instances, unit)
  return unit
end

Projectile = { instances = {}}
Projectile.__index = Projectile

Controller = {
  selected_units = {}
}