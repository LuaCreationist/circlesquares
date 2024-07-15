function love.load()
	shader = require("shader")
	shader.load()
	width,height = love.graphics.getDimensions()
	gridHandler = require("gridHandler")
	gridHandler.load()
	paused = false 
	love.window.setTitle("Grid Colors, paused - "..tostring(paused)..",magic number:"..tostring(gridHandler.magicNumber))
	canvas = love.graphics.newCanvas(width,height)
end
function love.keypressed(key)
	if key:lower() == "p" then 
		if paused == true then 
			paused = false 
		else
			paused = true 
		end
	elseif key:lower() == "q" then
		gridHandler.magicNumber = gridHandler.magicNumber * 10 
	elseif key:lower() == "e" then 
		gridHandler.magicNumber = gridHandler.magicNumber/10
	elseif key:lower() == "m" then
		if gridHandler.mode == "normal" then 
			gridHandler.mode = "special"
		else
			gridHandler.mode = "normal"
		end 
	end
	love.window.setTitle("Grid Colors, paused - "..tostring(paused)..",magic number:"..tostring(gridHandler.magicNumber))
end
function love.resize(w,h)
	width = w 
	height = h 
	canvas = love.graphics.newCanvas(width,height)
end
function render_grid()
	love.graphics.setShader(shader.blendSimilarShader)
	gridHandler.draw(width,height)
	love.graphics.setShader()
end
function love.update(dt)
	if paused == false then 
		width,height = love.graphics.getDimensions()
		gridHandler.update(dt)
	end
	
end
function love.draw()
	canvas:renderTo(render_grid)
	love.graphics.setColor(1,1,1)
	love.graphics.draw(canvas,0,0)
end