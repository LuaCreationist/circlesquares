local gmaker = {} 
function gmaker.makeGrid(width,height)
	local grid = {} 
	for x = 1,width do 
		grid[x] = {} 
		for y = 1,height do 
			grid[x][y] = {x = x,y = y,r = 0,g = 0,b = 0,d = "forward",modifier=0,distance=nil,distance2=nil} 
		end
	end
	return grid
end
return gmaker