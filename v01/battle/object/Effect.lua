--- @class Effect blood, fire, etc.
--- @field public image love.Image
--- @field public duration number
--- @field public x number
--- @field public y number
--- @field public rotation number
Effect = {}

--- @param image love.Image
--- @param x number
--- @param y number
--- @param rotation number
---@param duration number
---@return Effect
function Effect.new(image, x, y, rotation, duration)

  return {
    image = image,
    duration = duration,
    x = x,
    y = y,
    rotation = rotation
  }

end