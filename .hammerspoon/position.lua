-- Copyright (c) 2016 Miro Mannino
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this 
-- software and associated documentation files (the "Software"), to deal in the Software 
-- without restriction, including without limitation the rights to use, copy, modify, merge,
-- publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
-- to whom the Software is furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all copies
-- or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
-- DEALINGS IN THE SOFTWARE.

hs.window.animationDuration = 0

local sizes = {2, 3, 3/2}
local fullScreenSizes = {1, 4/3, 2}

local GRID = {w = 24, h = 24}
hs.grid.setGrid(hs.geometry(nil, nil, GRID.w, GRID.h))
hs.grid.setMargins(hs.geometry(0, 0))

local pressed = {
  up = false,
  down = false,
  left = false,
  right = false
}

function nextStep(dim, offs, cb)
  if hs.window.focusedWindow() then
    local axis = dim == 'w' and 'x' or 'y'
    local oppDim = dim == 'w' and 'h' or 'w'
    local oppAxis = dim == 'w' and 'y' or 'x'
    local win = hs.window.frontmostWindow()
    local screen = win:screen()

    cell = hs.grid.get(win, screen)

    local nextSize = sizes[1]
    for i=1,#sizes do
      if cell[dim] == GRID[dim] / sizes[i] and
        (cell[axis] + (offs and cell[dim] or 0)) == (offs and GRID[dim] or 0)
        then
          nextSize = sizes[(i % #sizes) + 1]
        break
      end
    end

    cb(cell, nextSize)
    if cell[oppAxis] ~= 0 and cell[oppAxis] + cell[oppDim] ~= GRID[oppDim] then
      cell[oppDim] = GRID[oppDim]
      cell[oppAxis] = 0
    end

    hs.grid.set(win, cell, screen)
  end
end

function nextFullScreenStep()
  if hs.window.focusedWindow() then
    local win = hs.window.frontmostWindow()
    local screen = win:screen()

    cell = hs.grid.get(win, screen)

    local nextSize = fullScreenSizes[1]
    for i=1,#fullScreenSizes do
      if cell.w == GRID.w / fullScreenSizes[i] and 
         cell.h == GRID.h and
         cell.x == (GRID.w - GRID.w / fullScreenSizes[i]) / 2 and
         cell.y == 0 then
        nextSize = fullScreenSizes[(i % #fullScreenSizes) + 1]
        break
      end
    end

    cell.w = GRID.w / nextSize
    cell.h = GRID.h
    cell.x = (GRID.w - GRID.w / nextSize) / 2
    cell.y = 0

    hs.grid.set(win, cell, screen)
  end
end

function fullDimension(dim)
  if hs.window.focusedWindow() then
    local win = hs.window.frontmostWindow()
    local screen = win:screen()
    cell = hs.grid.get(win, screen)

    if (dim == 'x') then
      cell = '0,0 ' .. GRID.w .. 'x' .. GRID.h
    else  
      cell[dim] = GRID[dim]
      cell[dim == 'w' and 'x' or 'y'] = 0
    end

    hs.grid.set(win, cell, screen)
  end
end

hs.hotkey.bind(hyper, "g", function ()
  hs.window.frontmostWindow():moveOneScreenWest()
end)

hs.hotkey.bind(hyper, ";", function ()
  hs.window.frontmostWindow():moveOneScreenEast()
end)

-- down
hs.hotkey.bind(hyper, "m", function ()
  nextStep('h', true, function (cell, nextSize)
    cell.y = GRID.h - GRID.h / nextSize
    cell.h = GRID.h / nextSize
  end)
end)

-- right
hs.hotkey.bind(hyper, "l", function ()
  nextStep('w', true, function (cell, nextSize)
    cell.x = GRID.w - GRID.w / nextSize
    cell.w = GRID.w / nextSize
  end)
end)

-- left
hs.hotkey.bind(hyper, "h", function ()
  nextStep('w', false, function (cell, nextSize)
    cell.x = 0
    cell.w = GRID.w / nextSize
  end)
end)

-- up
hs.hotkey.bind(hyper, "u", function ()
  nextStep('h', false, function (cell, nextSize)
    cell.y = 0
    cell.h = GRID.h / nextSize
  end)
end)

-- center
hs.hotkey.bind(hyper, "j", function ()
  nextFullScreenStep()
end)
hs.hotkey.bind(hyper, "k", function ()
  nextFullScreenStep()
end)

-- cursor
hs.hotkey.bind(hyper, "delete", function ()
  local frame = hs.screen.mainScreen():frame()
  local dest = {x=frame.x + frame.w - 50, y=frame.y + frame.h - 50}
  hs.mouse.setAbsolutePosition(dest)
end)
