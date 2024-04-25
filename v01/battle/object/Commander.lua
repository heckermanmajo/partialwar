--- @class Commander
--- @field public x number
--- @field public y number
--- @field public health number
Commander = {}

--- @param x number
--- @param y number
--- @param health number
---@return Commander
function Commander.new(x, y, health)
  return {
    x = x,
    y = y,
    health = health
  }
end
