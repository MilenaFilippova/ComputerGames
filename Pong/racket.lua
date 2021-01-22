Racket = {}
Racket.__index = Racket

function Racket:create(location, size)
    local racket = {}
    setmetatable(racket, Racket)
    racket.location = location
    racket.size = size
    return racket
end

function Racket:update()
end

function Racket:draw()
    love.graphics.rectangle("fill", self.location.x, self.location.y, self.size.x, self.size.y)
end