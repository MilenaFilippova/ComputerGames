Mover = {}
Mover.__index = Mover

function Mover:create(location, velocity, weight)
    local mover = {}
    setmetatable(mover, Mover)
    mover.location = location
    mover.velocity = velocity
    mover.weight = weight or 1
    mover.size = mover.weight * 0.5 * 20
    return mover
end


function Mover:update()
    self.location = self.location + self.velocity
end

function Mover:applyForce(force)
    self.velocity = self.velocity + (force / self.weight)
end

function Mover:checkBound(object, count)
    if (self.location.x < object.size.x + 20) and (self.location.x > 20) and (self.location.y < object.location.y + object.size.y) and (self.location.y > object.location.y) then
        self.location.x = object.size.x + 20
        self.velocity.x = self.velocity.x * -1
        count = count + 1
        self.velocity.x = self.velocity.x + 1
        self.velocity.y = self.velocity.y + 1
    end
    return count
end

function Mover:checkBoundaries()
    if self.location.x > width - 40 - self.size then
        self.location.x = width-self.size - 40
        self.velocity.x = self.velocity.x * -1
    end

    if self.location.y > height - self.size then
        self.location.y = height - self.size
        self.velocity.y = self.velocity.y * -1 
    elseif self.location.y < self.size then
        self.location.y = self.size
        self.velocity.y = self.velocity.y * -1
    end
end

function Mover:draw()
    love.graphics.circle("fill", self.location.x, self.location.y, self.size)
end

