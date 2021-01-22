require("vector")
require("mover")
require("racket")

function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
    background = love.graphics.newImage("resources/background.png")

    location = Vector:create(width/2 , height/2)
    location1 = Vector:create(20, height/2 - 50)
    location2 = Vector:create(width - 40, height/2 - 50)
    sd = Vector:create(0, 6)
    ev = Vector:create(1, 1)
    size = Vector:create(20, 100)
    racket1 = Racket:create(location1, size)
    racket2 = Racket:create(location2, size)
    velocity = Vector:create(love.math.random(-10, 10)/10, love.math.random(-10, 10)/10)

    if velocity.x < 0 then
        velocity.x = velocity.x - 3
    else 
        velocity.x = velocity.x + 3
    end
    if velocity.y < 0 then
        velocity.y = velocity.y - 3
    else 
        velocity.y = velocity.y + 3
    end

    mover = Mover:create(location, velocity)
    w = false
    s = false
    count = 0
    screen = 0
    lou = 0
end

function love.update()
    if screen == 1 then
        if racket1.location.y < 0 then
            w = false
            s = true
        end
        if racket1.location.y + racket1.size.y > height then
            w = true
            s = false
        end
        if w then 
            racket1.location = racket1.location - sd
        end
        if s then
            racket1.location = racket1.location + sd
        end
        racket2.location.y = mover.location.y - 50
        racket1:update()
        racket2:update()

        count = mover:checkBound(racket1, count)

        if mover.location.x < mover.size then
            mover.location = location
            velocity1 = Vector:create(love.math.random(-10, 10)/10, love.math.random(-10, 10)/10)
            if velocity1.x < 0 then
                velocity1.x = velocity1.x - 3
            else 
                velocity1.x = velocity1.x + 3
            end
            if velocity1.y < 0 then
                velocity1.y = velocity1.y - 3
            else 
                velocity1.y = velocity1.y + 3
            end    
            mover.velocity = velocity1
            --проиграл
            count = 0
            screen = 2
        end
        if count == 10 then
            --выиграл
            screen = 3
        end
        mover:checkBoundaries()
        mover:update()
    end
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    if screen == 0 then
        love.graphics.print("Get ready to play.Operate the W and S keys", height/2-120, 300, 0, 2, 2)
    end
    if screen == 2 then
        love.graphics.print("Game over! You lose!", height/2-70, 300, 0, 2, 2)
    end
    if screen == 3 then
        love.graphics.print("Game over! You won!", height/2-70, 300, 0, 2, 2)
    end
    if screen == 1 then
        mover:draw()
        racket1:draw()
        racket2:draw()
        love.graphics.print("You have collected " .. tostring(count) .. " points!")
    end
end

function love.keypressed(key)
    if key == 'space' then
        screen = 1
    end
    --вниз ракетку
    if key == 's' then
    w = false
    s = true
    end
    --вверх ракетку
    if key == 'w' then
    w = true
    s = false
    end
end