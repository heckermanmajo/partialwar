--- @class SpawnQueueEntry
--- @field unit_type BattleUnitType
--- @field target_chunk
SpawnQueueEntry = {}


function SpawnQueueEntry.new(unit_type, target_chunk)
  local entry = {
    unit_type = unit_type,
    target_chunk = target_chunk
  }
  return entry
end
