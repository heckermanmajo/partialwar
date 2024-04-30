--- @class ControlGroup Collection of units that belong together and can be controlled together.
---        as a game mechanic: if the organisation of the control group reaches 0, the control
---        group is destroyed and units move randomly around.
--- @field units BattleUnit[]
--- @field organisation number
ControlGroup = {}

-- control groups dont define targets to attack
-- but chunks to hold
-- also together movement
-- units will not venture out to far from a control group
-- control groups have a middle-point
-- all n seconds a unit tries to get back near to the middle point of the control group
-- the control group does not need to stand exactly on a chunk only near to it
-- how to have formations??

-- formations -> this is the big thing just spawn formations
-- charge would remove the controllability but all units would press forward
-- engaged in fight -> no control


function ControlGroup.new()

  local self = setmetatable({}, {__index = ControlGroup})

  self.faction = nil
  self.units = {}
  self.organisation = 100
  self.target_chunk = nil
  self.hold_position = nil

  table.insert(Battle.control_groups, self)

  return self

end
