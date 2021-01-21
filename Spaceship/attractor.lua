Attractor = {}
Attractor.__index = Attractor

function Attractor:create(location, mass)
    local attractor = {}
    setmetatable(attractor, Attractor)
    attractor.location = location
    attractor.mass = mass
    attractor.size = 30 + 0.3 * mass
    attractor.inner_size = attractor.size
    return attractor
end

function Attractor:attract(object)
    dir = self.location - object.location
    dist = dir:mag()
    if dist then
        if dist < 5 then
            dist = 5
        end
        if dist > 25 then
            dist = 25
        end
        dir = dir:norm()
        if dir then
            strength = (G * self.mass * object.weight)/(dist * dist)
            force = dir * strength
            object:applyForce(force)
        end
    end
end

function Attractor:draw()
    love.graphics.circle("line", self.location.x, self.location.y, self.size)
    self.inner_size = self.inner_size - 0.5
    if self.inner_size <= 0 then
        self.inner_size = self.size
    end
    love.graphics.circle("line", self.location.x, self.location.y, self.inner_size)
end