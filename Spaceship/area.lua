Area = {}
Area.__index = Area 

function Area:create(x, y, w, h, f)
    local area = {}
    setmetatable(area, Area)
    area.x = x
    area.y = y
    area.w = w
    area.h = h
    area.f = f
    return area
end

function Area:draw()
    local r, g, b, a = love.graphics.getColor()
    if self.f < 0 then
        love.graphics.setColor(255/255, 105/255, 180/255, 0.5)
        
    else
        love.graphics.setColor(32/255, 178/255, 170/255, 0.5)
    end
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setColor(r, g, b, a)

end

function Area:apply(object)
    local xc = object.location.x
    local yc = object.location.y
    if (xc > self.x and xc < self.x + self.w and yc > self.y and yc < self.y + self.h) then
        -- friction = (object.velocity * -1):norm()
        -- if (friction) then
        --     friction = friction * self.f
        --     object:applyForce(friction)
        -- end
        mag = object.velocity:mag()
        drag = self.f * mag * mag
        dragVec = (object.velocity * -1):norm()
        if dragVec then
            dragVec:mull(drag)
            --dragVec:div(1 / object.weight)
            dragVec:div(1 / (object.location1.x / 80))
            object:applyForce(dragVec)
        end
    end
end