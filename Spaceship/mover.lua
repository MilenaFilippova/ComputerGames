Mover = {}
Mover.__index = Mover

function Mover:create(images, location, velocity, auto)
    local mover = {}
    setmetatable(mover, Mover)
    mover.images = images
    mover.location = location
    mover.velocity = velocity

    -- angular
    mover.acceleration = Vector:create(0, 0)
    mover.aAcceleration = 0
    mover.aVelocity = 0
    mover.auto = auto or false
    mover.maxSpeed = 4
    mover.maxForce = 0.1
    mover.angle = 0
    return mover
end

function Mover:applyForce(force)
    self.acceleration:add(force)
end


function Mover:checkBoundaries() --чтобы кораблик не улетел в космос, за пределы границ
    if self.location.x < 30 then
        self.location.x = width - 30
    elseif self.location.x > width - 30 then
        self.location.x = 30
    end
    if self.location.y < 30 then
        self.location.y = height - 30
    elseif self.location.y > height - 30 then
        self.location.y = 30
    end
    --if (self.location - object.location):mag() <= object.size / 2 + self.size / 2 then
   -- end
end

function Mover:checkCoordinates() --запоминаем координаты
    local x = self.location.x
    local y = self.location.y
    imag = self.images[1]
    local x1 = imag:getWidth()/16
    local y1 = imag:getHeight()/16
    coords = {{x,y},{x+x1,y},{x+x1,y+y1},{x,y+y1},{x,y}}
    return coords      
end

function Mover:checkObstacles(object)
    local coords1 = self:checkCoordinates()
    local coords2 = object:checkCoordinates()
    axis1 = {}
    axis2 = {}

    for i=1, #coords1 - 1 do
        point1 = coords1[i]
        point2 = coords1[i+1]
        local v1 = Vector:create(point1[1], point1[2])
        local v2 = Vector:create(point2[1], point2[2])
        v1:sub(v2)
        local perp = Vector:create(v1.y * -1, v1.x)
        perp:norm()
        table.insert(axis1, perp)
    end

    for i=1, #coords2 - 1 do
        point1 = coords2[i]
        point2 = coords2[i+1]
        local vv1 = Vector:create(point1[1], point1[2])
        local vv2 = Vector:create(point2[1], point2[2])
        vv1:sub(vv2)
        local perp1 = Vector:create(vv1.y * -1, vv1.x)
        perp1:norm()
        table.insert(axis2, perp1)
    end

    for i = 1, #axis1 do
        local ax = axis1[i]
        local p1 = self:normal(ax)
        local p2 = self:normal(ax, object)
        if p1:overlap(p2) == false then
            return false
        end
    end

    for i = 1, #axis2 do
        local axx = axis2[i]
        local pp1 = self:normal(axx)
        local pp2 = self:normal(axx, object)
        if pp1:overlap(pp2) == false then
            return false
        end
    end
    return true
end

function Mover:normal(axis, object)
    local coords1 = self:checkCoordinates()
    if object then
        local coords2 = object:checkCoordinates()
        local min = axis:dot(Vector:create(coords2[1][1], coords2[1][2]))
        local max = min
        for i = 2, #coords2 do
            t = axis:dot(Vector:create(coords2[i][1], coords2[i][2]))
            if t < min then
                min = t 
            elseif t > max then
                max = t 
            end
        end
        proj = Vector:create(min,max)
    else 
        local min = axis:dot(Vector:create(coords1[1][1], coords1[1][2]))
        local max = min
        for i = 2, #coords1 do
            t = axis:dot(Vector:create(coords1[i][1], coords1[i][2]))
            if t < min then
                min = t 
            elseif t > max then
                max = t 
            end
        end
        proj = Vector:create(min,max)
    end
    return proj
end

function Mover:random()
    local location = Vector:create()
    location.x = love.math.random(0, width)
    location.y = love.math.random(0, height)
    local velocity = Vector:create()
    velocity.x = love.math.random(-2, 2)
    velocity.y = love.math.random(-2, 2)

    return Mover:create(location, velocity)
end





function Mover:draw()
    love.graphics.push()
    love.graphics.translate(self.location.x, self.location.y)
    love.graphics.rotate(self.angle + math.pi / 2)
    n = 1

    if #self.images > 1 then
        mag = self.velocity:mag()
        if mag < 1 then
            n = 1
        elseif mag > 1 and mag < 2.5 then
            n = 2
        else
            n = 3
        end
    end
    image = self.images[n]
    love.graphics.draw(image, -image:getWidth()/16, -image:getHeight()/16, 0 , 1/8, 1/8)
    love.graphics.pop()
end

function Mover:update()
    self.velocity:add(self.acceleration)
    self.velocity = self.velocity:limit(5)
    self.location:add(self.velocity)
    self.aVelocity = self.aVelocity + self.aAcceleration
    self.angle = self.angle + self.aVelocity
     -- Когда сила не прикладываетя - ускорение зануляется (мгновенный результат)
    self.acceleration:mul(0)
end