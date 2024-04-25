local CampEndManager = {}

---@param camp Camp
function CampEndManager.end_camp(camp)

  local enemy_armies_or_factories = false
  local player_armies_or_factories = false

  for _, tile in ipairs(camp.tiles) do

    if tile.owner == camp.factions.enemy then
      if tile.army then
        enemy_armies_or_factories = true
      end
      if tile.type == "factory" then
        enemy_armies_or_factories = true
      end
    end

    if tile.owner == camp.factions.player then
      if tile.army then
        player_armies_or_factories = true
      end
      if tile.type == "factory" then
        player_armies_or_factories = true
      end
    end

  end

  if not enemy_armies_or_factories then
    print("Player wins!")
    os.exit()
  end

  if not player_armies_or_factories then
    print("Enemy wins!")
    os.exit()
  end

end

return CampEndManager