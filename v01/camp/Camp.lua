local Menu = require("menu")

local GenerateCampMap = require("camp/manager/GenerateCampMap")
local TileRenderer = require("camp/manager/TileRenderer")
local ArmySpawner = require("camp/manager/ArmySpawner")
local ArmyRenderer = require("camp/manager/ArmyRenderer")
local TileInfoRenderer = require("camp/manager/TileInfoRenderer")
local ArmyMover = require("camp/manager/ArmyMover")
local MoneyRenderer = require("camp/manager/MoneyRenderer")
local NextRoundManager = require("camp/manager/NextRoundManager")
local CampEndManager = require("camp/manager/CampEndManager")
local IncomeDisplayManager = require("camp/manager/IncomeDisplayManager")

--- @class Camp
--- @field public id string
--- @field public tile_size number
--- @field public tiles Tile[]
--- @field public tile_map Tile[][]
--- @field public view_x number
--- @field public view_y number
--- @field public selected_tile Tile
--- @field public current_faction_turn Faction
--- @field public click_consumed_by_ui boolean
--- @field public factions Faction[]
--- @field public mode string
--- @field public money_per_factory number
--- @field public money_per_minerals number
--- @field public money_per_tile number
Camp = {
  id = "camp",
  tile_size = 128,
  tiles = {},
  tile_map = {},
  view_x = 0,
  view_y = 0,
  selected_tile = nil,
  --- The current faction that is playing
  current_faction_turn = nil,
  click_consumed_by_ui = false,
  factions = {
    player = Faction.new("player", { 0, 0, 1 }, true, 1000),
    enemy = Faction.new("enemy", { 1, 0, 0 }, false, 1000)
  },
  mode = "camp",
  money_per_factory = 60,
  money_per_minerals = 50,
  money_per_tile = 10,
  level_cost = 500,
  round_counter = 0 -- needed for the AI behavior
}

function Camp.start()
  GenerateCampMap.generate_map(Camp)
  ArmySpawner.spawn_armies(Camp)

  Camp.current_faction_turn = Camp.factions.player

end

--- @param result BattleResult
function Camp.consume_battle_result(result)

  -- todo: rewrite this to "attacker" and "defender"

  local player_has_lost = false
  local enemy_has_lost = false

  if result.player_command_points <= 0 then
    player_has_lost = true
  end

  if result.enemy_command_points <= 0 then
    enemy_has_lost = true
  end

  if player_has_lost then
    result.player_tile.army = nil
    result.player_tile.owner = nil
    result.enemy_tile.army.command_points = result.enemy_command_points
  end

  if enemy_has_lost then
    result.enemy_tile.army = nil
    result.enemy_tile.owner = nil
    result.player_tile.army.command_points = result.player_command_points
  end

end

function Camp.update(dt)

  if not Menu.menu_sound:isPlaying() then
    love.audio.play(Menu.menu_sound)
  end

  CampEndManager.end_camp(Camp)

  Camp.click_consumed_by_ui = false

  -- change the view with the arrow keys
  if love.keyboard.isDown("w") then
    Camp.view_y = Camp.view_y + 700 * dt
  end
  if love.keyboard.isDown("s") then
    Camp.view_y = Camp.view_y - 700 * dt
  end
  if love.keyboard.isDown("a") then
    Camp.view_x = Camp.view_x + 700 * dt
  end
  if love.keyboard.isDown("d") then
    Camp.view_x = Camp.view_x - 700 * dt
  end

  NextRoundManager.update(Camp, dt)

  --- All user input is halted when it's not the player's turn
  if Camp.current_faction_turn == Camp.factions.player then


    -- right click unset the selected tile
    if love.mouse.isDown(2) then
      Camp.selected_tile = nil
    end

    if Camp.selected_tile then
      TileInfoRenderer.update(Camp, Camp.selected_tile, dt)
    end

    if (
      Camp.selected_tile
        and Camp.selected_tile.army
        and Camp.selected_tile.owner == Camp.factions.player
        and not Camp.selected_tile.army.movement_this_turn
    ) then
      if love.keyboard.isDown("up") then
        ArmyMover.move_army_up(Camp, Camp.selected_tile)
      end

      if love.keyboard.isDown("down") then
        ArmyMover.move_army_down(Camp, Camp.selected_tile)
      end

      if love.keyboard.isDown("left") then
        ArmyMover.move_army_left(Camp, Camp.selected_tile)
      end

      if love.keyboard.isDown("right") then
        ArmyMover.move_army_right(Camp, Camp.selected_tile)
      end

    end

    if love.mouse.isDown(1) and (not Camp.click_consumed_by_ui) then
      local x, y = love.mouse.getPosition()
      for _, tile in ipairs(Camp.tiles) do
        if x > tile.x * Camp.tile_size + Camp.view_x and
          x < tile.x * Camp.tile_size + Camp.view_x + Camp.tile_size and
          y > tile.y * Camp.tile_size + Camp.view_y and
          y < tile.y * Camp.tile_size + Camp.view_y + Camp.tile_size then
          Camp.selected_tile = tile
        end
      end
    end

  end

end

function Camp.draw()
  love.graphics.setColor(1, 1, 1)
  TileRenderer.draw(Camp)

  ArmyRenderer.draw(Camp)

  if Camp.selected_tile then
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle(
      "line",
      Camp.selected_tile.x * Camp.tile_size + Camp.view_x + 3,
      Camp.selected_tile.y * Camp.tile_size + Camp.view_y + 3,
      Camp.tile_size - 6,
      Camp.tile_size - 6
    )

    TileInfoRenderer.draw(Camp, Camp.selected_tile)

  end

  Menu.draw_background_brown(0, 0, 380, 480)

  MoneyRenderer.render_money(Camp)
  NextRoundManager.draw(Camp)
  IncomeDisplayManager.draw(Camp)

end

