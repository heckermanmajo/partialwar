--- @class BattleFaction
--- @field public name string
--- @field public color table<number, number>
--- @field public is_player boolean
--- @field public command_points number

BattleFaction = {}
function BattleFaction.new(name, color, is_player, command_points)
  local faction = {
    name = name,
    color = color,
    is_player = is_player,
    command_points = command_points or 0
  }
  --BattleFaction.check(faction)
  return faction
end
