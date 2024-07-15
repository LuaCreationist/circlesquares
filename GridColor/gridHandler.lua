local G_handle = {}
function G_handle.load()
	MATH = math
	gW = 360 -- grid width 
	gH = 360 -- grid height 
	gW2 = gW/2
	gH2 = gH/2
    frameOne = true 
    grid_maker = require("grid")
    G_handle.grid = grid_maker.makeGrid(gW, gH) -- Creates a 500x500 2D grid, each cell has X, Y, and R, G, B
    G_handle.direction = "forward"
    G_handle.magicNumber = 0.000009
    G_handle.center_cell = { x = gW2, y = gH2 }
    G_handle.mode = "normal"
end
function distancefromCenter(cell)
    local centerX, centerY = gW2, gH2
    local dx = cell.x - centerX
    local dy = cell.y - centerY
    return MATH.sqrt(dx * dx + dy * dy)
end
function distanceFromBorders(cell)
    local leftDist = cell.x
    local rightDist = gW - cell.x
    local topDist = cell.y
    local bottomDist = gH - cell.y
    return MATH.min(leftDist, rightDist, topDist, bottomDist)
end
function smoothstep(min, max, value)
    local x = MATH.max(0, MATH.min(1, (value - min) / (max - min)))
    return x * x * (3 - 2 * x)
end
function G_handle.update()
    local mode = G_handle.mode
    if frameOne == true then
        frameOne = false 
        for x = 1,gW do 
            for y = 1,gH do 
                G_handle.grid[x][y].distance = distancefromCenter(G_handle.grid[x][y])
                G_handle.grid[x][y].distance2 = distanceFromBorders(G_handle.grid[x][y])
            end
        end 
    end
    local magicNumber = G_handle.magicNumber
    for x = 1, gW do
        for y = 1, gH do
            local cell = G_handle.grid[x][y]
            local distance = 0+cell.distance
            if distance > 0 then distance = distance / 45 end
            local smoothFactor = smoothstep(0, 1, cell.g)
            local sinValue = 0.5 + 0.5 * MATH.sin(cell.g * MATH.pi * 2)
            local cosValue = 0.5 + 0.5 * MATH.cos(cell.g * MATH.pi * 2)
            if cell.d == "forward" then
                if mode == "normal" then 
                    cell.g = cell.g + (magicNumber * distance)--MATH.abs( (magicNumber * distance) - (magicNumber*cell.distance2) )
                else
                    cell.g = cell.g + MATH.abs( (magicNumber * distance) - (magicNumber*cell.distance2) )
                end
                cell.r = smoothFactor * sinValue + ( (smoothFactor * sinValue)*cell.modifier )
                cell.b = smoothFactor * cosValue + ( (smoothFactor * cosValue)*cell.modifier )
                if cell.g >= 1 then cell.d = "back" end
            else
                if mode == "normal" then 
                    cell.g = cell.g - MATH.abs( (magicNumber * distance) - (magicNumber*cell.distance2) )
                else
                    cell.g = cell.g - (magicNumber * distance)
                end
                cell.r = smoothFactor * sinValue + ( (smoothFactor * sinValue)*cell.modifier )
                cell.b = smoothFactor * cosValue + ( (smoothFactor * cosValue)*cell.modifier )
                if cell.g <= 0 then
                    cell.d = "forward"
                    cell.modifier = cell.modifier + 0.001
                    if cell.modifier >= 1.2 then
                        cell.modifier = 0 
                    end 
                end
            end
        end
    end
end
function G_handle.draw(width,height) -- draws the grid onto screen using width/height of screen to determine cell size 
	local w = width/gW
	local h = height/gH
	for x = 1,gW do 
		for y = 1,gH do 
			local cell = G_handle.grid[x][y]
			local r, g, b, a = love.graphics.getColor( )
			if r ~= cell.r or g ~= cell.g or b ~= cell.b then 
				love.graphics.setColor(cell.r,cell.g,cell.b)
			end
			local x1 = (x-1) * w
			local y1 = (y-1) * h
			love.graphics.rectangle("fill",x1,y1,w,h)
		end
	end
end
return G_handle