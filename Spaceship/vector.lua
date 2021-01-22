Vector = {}
Vector.__index = Vector

function Vector:create(x, y)
    local vector = {}
    setmetatable(vector, Vector)
    vector.x = x
    vector.y = y
    return vector
end

function Vector:__tostring()
    return "Vector(x = " ..self.x .. ", y = " .. self.y .. ")"
end

function Vector:__add(other)
    return Vector:create(self.x + other.x, self.y + other.y)
end

function Vector:__sub(other)
    return Vector:create(self.x - other.x, self.y - other.y)
end

function Vector:__mul(val)
    return Vector:create(self.x * val, self.y * val)
end

function Vector:__div(val)
    return Vector:create(self.x / val, self.y / val)
end

function Vector:mag()
    return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vector:norm()
    m = self:mag()
    if (m > 0) then
        return self / m
    end
end

function Vector:limit(max)
    if self:mag() > max then
        norm = self:norm()
        return norm * max
    end
    return self
end

function Vector:add(other)
    self.x = self.x + other.x
    self.y = self.y + other.y
end

function Vector:sub(other)
    self.x = self.x - other.x
    self.y = self.y - other.y
end

function Vector:mul(value)
    self.x = self.x * value
    self.y = self.y * value
end

function Vector:div(value)
    self.x = self.x / value
    self.y = self.y / value
end

function Vector:dot(other) -- определить точки нормали, получаем угол между векторами
    return self.x * other.x + self.y * other.y
end

function Vector:overlap(other)
    if (self.x > other.y) or (self.y > other.x) then
        return true
    else
        return false
    end
end