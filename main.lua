json = require "json"
require "vector"
require "vehicle"
require "manager"
require "food"
require "udpthread"

local socket = require('socket')

function love.load(args)
    id = 5555
    if #args > 0 then
        port = args[1]
    else
        port = 12345
    end
    print("UDP port = ", port)
    udp = socket.udp()
    udp:setsockname('*', port)
    udp:settimeout(0)

    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
    font = love.graphics.newFont(60)
    love.graphics.setFont(font)
    ratio = width / height
    scaleX = 0.25
    scaleY = 0.25
    originX = 0
    originY = 0
    camX = 0
    camY = 0
    tenacious = {nil, -1}
    manager = Manager:create()
    pause = true
end

function love.update(dt)
    survive()

    if pause then
        return
    end
    
    manager:update(dt)

    local leader = manager:findTenacious()
    if leader[2] then
        tenacious = leader
    end
end

function survive()
    cmd = json.encode({cmd="env", id=id})
    local answer = manager:parseCommand(cmd)
    print(answer)
end

function love.draw()
    love.graphics.push()
    love.graphics.scale(scaleX, scaleY)
    love.graphics.translate(-originX, -originY)

    love.graphics.setColor(0, 0.3, 0.3)
    love.graphics.rectangle("line", 1, 1, width * 4 - 1, height * 4 - 1)

    love.graphics.setColor(0, 0.3, 0.3)
    local x, y = love.mouse.getPosition()
    camX = x * 1 / scaleX - width / 2 + originX
    camY = y * 1 / scaleY - height / 2 + originY
    -- love.graphics.rectangle("line", camX, camY, width, height)

    manager:draw()

    love.graphics.setColor(1, 1, 1)
   
    love.graphics.print("Current FPS "..tostring(love.timer.getFPS().." count = " .. tostring(manager:count())), 10, 10)
    if tenacious[1] then
        love.graphics.print("Leader: ".. tenacious[1] .. " " .. tenacious[2], 10, 80)
    end
    love.graphics.pop()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    if key == "1" then
        originX = 0
        originY = 0
        scaleX = 0.25
        scaleY = 0.25
    end
    if key == "space" then
        pause = not pause
    end
    if key == "n" then
		print(manager:parseCommand(json.encode({cmd="create", id=id, color={0, 1, 0}})))
    end
	if key == "left" then
		print(manager:parseCommand(json.encode({cmd="force", id=id, x=-2, y=0})))
	end
	if key == "right" then
		print(manager:parseCommand(json.encode({cmd="force", id=id, x=2, y=0})))
	end
	if key == "up" then
		print(manager:parseCommand(json.encode({cmd="force", id=id, x=0, y=-2})))
	end
	if key == "down" then
		print(manager:parseCommand(json.encode({cmd="force", id=id, x=0, y=2})))
	end
	if key == "e" then
		print(manager:parseCommand(json.encode({cmd="env", id=id})))
	end
	if key == "i" then
		print(manager:parseCommand(json.encode({cmd="info", id=id})))
	end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        local x_ = x * 1 / scaleX + originX
        local y_ = y * 1 / scaleY + originY
        local info = manager:checkClicked(x_, y_)
        if info then
            print(json.encode(info))
        end
    end
end
