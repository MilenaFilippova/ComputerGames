require("vector")
require("mover")

function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()

    background = love.graphics.newImage("resources/background.png")

    mover_images = {}
    mover_images[1] = love.graphics.newImage("resources/ship_no_engine.png")
    mover_images[2] = love.graphics.newImage("resources/ship_engine_on.png")
    mover_images[3] = love.graphics.newImage("resources/ship_engine_full.png")

    obstacle_images = {love.graphics.newImage("resources/obstacle_round.png")}
    player = Mover:create(mover_images, Vector:create(400, 300),Vector:create(0,0))

    obstacle = Mover:create(obstacle_images, Vector:create(50,50), Vector:create(0.5,2))
    obstacle2= Mover:create(obstacle_images, Vector:create(600,50), Vector:create(0.5,2))

    obstacle.aVelocity = 0.1
    obstacle2.aVelocity = 0.1
    start = 0
    time_start = love.timer.getTime()
end

function love.update()
    if start == 1 then
        if love.keyboard.isDown("left") then
            player.angle = player.angle - 0.05
        end
        if love.keyboard.isDown("right") then
            player.angle = player.angle + 0.05
        end
        if love.keyboard.isDown("up") then
            x = 0.1 * math.cos(player.angle)
            y = 0.1 * math.sin(player.angle)
            player:applyForce(Vector:create(x,y))
        end

        time_end = love.timer.getTime()
        all_time = time_end - time_start

        player:checkBoundaries()
        if player:checkObstacles(obstacle) or player:checkObstacles(obstacle2) then
            start = 2
            player.location = Vector:create(400, 300)
            obstacle.location = Vector:create(50,50)
            obstacle2.location = Vector:create(600,50)
        end

        player:update()
        obstacle:checkBoundaries()  
        obstacle:update()
        obstacle2:checkBoundaries()  
        obstacle2:update()
        
    end
    
end

function love.draw()
    --старт
     if start == 0 then
        love.graphics.print("Get ready to play. Press the key.", width/2-150, 300, 0, 2, 2)
    end
    --игра
    if start == 1 then
        love.graphics.draw(background, 0,0)
        player:draw()
        obstacle:draw()
        obstacle2:draw()
        love.graphics.print("time = " .. all_time)
    end
    --результаты игры
    if start == 2 then
        love.graphics.print("GAME OVER! Your play time = " .. math.floor(all_time), width/2-150, 300, 0, 1.5, 1.5)
    end
   
end

function love.keypressed(key)
    if key == 'space' then
        start = 1
        --после нажатия клавиши фиксируем время
        time_start = love.timer.getTime()
    end
end