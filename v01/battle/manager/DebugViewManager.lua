local DebugViewManager = {}


function DebugViewManager.draw_meta_info()
  -- mouse position
  love.graphics.print("Mouse: " .. love.mouse.getX() .. ", " .. love.mouse.getY(), 10, 10)
end

return DebugViewManager