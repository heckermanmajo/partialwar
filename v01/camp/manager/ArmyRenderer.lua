local ArmyRenderer = {}

function ArmyRenderer.draw(camp)
  for _, tile in ipairs(camp.tiles) do
    ---@type Army
    local army = tile.army
    if army then
      local faction = army.faction
      local size_of_one_square = 4
      local space_between_squares = 2
      local outer_space = 2
      local line_width = 2
      local squares_to_draw = math.ceil(army.command_points / 100)
      -- we want a square of smaller squares
      local square_number = math.ceil(math.sqrt(squares_to_draw))
      local width = (
        square_number * size_of_one_square
          + (square_number) * space_between_squares
        + outer_space
      )
      local height = width

      -- todo: center the army in the middle of the tile

      -- create square-border for the army with the faction color
      -- with the provided width and height and line width
      if army.movement_this_turn then
        love.graphics.setColor(0.5, 0.5, 0.5)
      else
        love.graphics.setColor(faction.color)
      end

      love.graphics.setLineWidth(line_width)
      --[[love.graphics.rectangle(
        "line",
        tile.x * camp.tile_size + (camp.tile_size - width) / 2 + Camp.view_x,
        tile.y * camp.tile_size + (camp.tile_size - height) / 2 + Camp.view_y,
        width,
        height
      )]]

      local army_level = army.army_level
      for i = 1, army_level do
        -- for each level a square around the border with some space between them
        love.graphics.rectangle(
          "line",
          tile.x * camp.tile_size + (camp.tile_size - width) / 2 + Camp.view_x - i * 4,
          tile.y * camp.tile_size + (camp.tile_size - height) / 2 + Camp.view_y - i * 4,
          width + 8 * i,
          height + 8 * i
        )
      end

      -- fill the inner of the square with white
      love.graphics.setColor(0.3, 0.3, 0.3)
      love.graphics.rectangle(
        "fill",
        tile.x * camp.tile_size + (camp.tile_size - width) / 2 + Camp.view_x + line_width,
        tile.y * camp.tile_size + (camp.tile_size - height) / 2 + Camp.view_y + line_width,
        width - 2 * line_width,
        height - 2 * line_width
      )
      -- todo: draw the squares of the units ...

      -- render the rows of 4x4 squares for each 100 command points
      -- it yould align with the rect border
      for j = 0, square_number - 1 do
        for i = 0, square_number - 1 do
          love.graphics.setColor(faction.color)
          love.graphics.rectangle(
            "fill",
            tile.x * camp.tile_size + (camp.tile_size - width) / 2 + Camp.view_x + outer_space + i * (size_of_one_square + space_between_squares),
            tile.y * camp.tile_size + (camp.tile_size - height) / 2 + Camp.view_y + outer_space + j * (size_of_one_square + space_between_squares),
            size_of_one_square,
            size_of_one_square
          )
          squares_to_draw = squares_to_draw - 1
          if squares_to_draw == 0 then
            goto done_drawing
          end
        end
      end
      ::done_drawing::

    end
  end
end

return ArmyRenderer