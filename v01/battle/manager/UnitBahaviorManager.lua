-- The idea is that units manage themselves and have no groups.
-- You place hold, attack and waypoints on the map
-- aber man kann einheiten auch normal steuern, etc.

local  UnitBehaviourManager = {}

function UnitBehaviourManager.update(dt)

  for _, _u in ipairs(Battle.units) do

    --- @type BattleUnit
    local u = _u

    --if(u)

  end

end

return UnitBehaviourManager