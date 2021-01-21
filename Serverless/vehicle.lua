Vehicle = {}
Vehicle.__index = Vehicle

function Vehicle:create(color, human)
    local vehicle = {}
    setmetatable(vehicle, Vehicle)
    vehicle.acceleration = Vector:create(0, 0)
    vehicle.velocity = Vector:create(0, 0)
    local x = love.math.random(10, 4 * width - 10)
    local y = love.math.random(10, 4 * height - 10)
    vehicle.location = Vector:create(x, y)
    vehicle.life = 60
    vehicle.rsense = 160
    vehicle.state = "alive"
    vehicle.deadTimer = 0
    vehicle.lifeTimer = 0
    vehicle.maxSpeed = 6
    vehicle.maxForce = 0.2
    vehicle.wtheta = 0
    vehicle.human = human or false
    vehicle.color = color or {1, 0, 0}
    return vehicle
end

function Vehicle:isAlive()
    return self.state == "alive"
end

function Vehicle:incLife(life)
    life = life or 1
    self.life = self.life + life
    if self.life > 120 then
        self.life = 120
    end
end

function Vehicle:update(dt)
    if self:isAlive() then
        self.lifeTimer = self.lifeTimer + dt
        self.life = self.life - dt * 2
        self.velocity:add(self.acceleration)
        self.velocity:limit(self.maxSpeed)
        self.location:add(self.velocity)
        self.acceleration:mul(0)
    end
    if self.life < 5 then
        self.state = "dead"
        self.velocity:mul(0)
    end
    if self.state == "dead" then
        self.deadTimer = self.deadTimer + dt
    end
end

function Vehicle:isRotten()
    return self.deadTimer > 20
end

function Vehicle:applyForce(force)
    self.acceleration:add(force)
end

function Vehicle:toObject()
    return {x=self.location.x, y=self.location.y, life=math.floor(self.life)}
end

function Vehicle:borders()
    if self.location.x < self.life then
        -- self.location.x = 4 * width + self.life
        self.velocity.x = -self.velocity.x
    end
    if self.location.y < self.life then
        --self.location.y = 4 * height + self.life
        self.velocity.y = -self.velocity.y
    end
    if self.location.x > 4 * width - self.life then
        --self.location.x = -self.life
        self.velocity.x = -self.velocity.x
    end
    if self.location.y > 4 * height - self.life then
        --self.location.y = -self.life
        self.velocity.y = -self.velocity.y
    end
end


function Vehicle:draw()
    r, g, b, a = love.graphics.getColor()
    local theta = self.velocity:heading()
    local alpha = 1
    if not self:isAlive() then
        alpha = 0.7
    end
    love.graphics.push()
    love.graphics.translate(self.location.x, self.location.y)
    love.graphics.rotate(theta)
    local color = self.color
    love.graphics.setColor(color[1], color[2], color[3], alpha)
    love.graphics.circle("fill", 0, 0, self.life)
    if self.human then
        love.graphics.setColor(0, 0, 1, alpha)
    else
        love.graphics.setColor(0, 1, 0, alpha)
    end
    
    love.graphics.circle("fill", self.life / 4, 0, self.life / 4)
    love.graphics.setColor(0, 0, 1, alpha / 2)
    love.graphics.circle("line", 0, 0, self.rsense + self.life)
    love.graphics.pop()
    love.graphics.setColor(r, g, b, a)
end
