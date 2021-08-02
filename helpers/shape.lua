local gears = require("gears")
local wibox = require("wibox")

shape = {}

function shape.horizontal_pad(width)
  return wibox.widget {
    forced_width = width,
    layout = wibox.layout.fixed.horizontal
  }
end

-- Create rounded rectangle shape (in one line)
function shape.rrect(radius)
  return function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, radius)
  end
end

-- Create partially rounded rect
function shape.prrect(radius, tl, tr, br, bl)
  return function(cr, width, height)
    gears.shape.partially_rounded_rect(cr, width, height, tl, tr, br, bl, radius)
  end
end

-- Create cutting corner
function shape.cutting_corner(cr, width, height)
  cr:move_to(0,0)
  cr:line_to(width - height / 25, 0)
  cr:line_to(width, height / 25)
  cr:line_to(width, height)
  cr:line_to(0, height)
  cr:close_path()
end

-- Create horizontal rounded bars
function shape.format_progress_bar(bar)
  bar.forced_width = dpi(100)
  bar.shape = shapes.rrect(beautiful.border_radius - 3)
  bar.bar_shape = shapes.rrect(beautiful.border_radius - 3)
  bar.background_color = beautiful.xcolor0
  return bar
end

-- Create parallelogram with custom width
function shape.pgram(base_width)
  return function(cr, width, height)
    gears.shape.parallelogram(cr, width, height, base_width)
  end
end

return shape
