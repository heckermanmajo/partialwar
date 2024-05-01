--- @class ControlGroup Collection of units that belong together and can be controlled together.
---        as a game mechanic: if the organisation of the control group reaches 0, the control
---        group is destroyed and units move randomly around.
--- @field units BattleUnit[] The units that belong to the control group.
--- @field organisation number The organisation of the control group. If it reaches 0, the control group is destroyed.
--- @field target_chunk Chunk The chunk that the control group is currently targeting
--- @field mode string "idle", "searching", "engaged", "on_the_way"
--- @field last_mode string The last mode of the control group
--- @field faction BattleFaction The faction that the control group belongs to
--- @field center_x number Units will follow this "center-leader" point in a relative distance
--- @field center_y number Units will follow this "center-leader" point in a relative distance
--- @field slowest_unit_speed number The speed of the slowest unit in the control group
ControlGroup = {}

--- Creates a new control group.
--- @param faction BattleFaction
function ControlGroup.new(faction)

  local self = setmetatable({}, {__index = ControlGroup})

  self.faction = faction
  self.units = {}
  self.organisation = 100
  self.target_chunk = nil
  self.mode = "idle" -- "searching", "engaged", "idle", "on_the_way"
  self.last_mode = "idle"
  self.center_x = 0
  self.center_y = 0
  self.slowest_unit_speed = 999999999

  table.insert(Battle.control_groups, self)

  return self

end
