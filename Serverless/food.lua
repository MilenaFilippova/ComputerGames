Food = {}
Food.__index = Food

function Food:create()
    local food = {}
    setmetatable(food, Food)
    local x = love.math.random(0, 4 * width)
    local y = love.math.random(0, 4 * height)
    food.location = Vector:create(x, y)
    return food
end

function Food:draw()
    love.graphics.rectangle("fill", self.location.x - 10, self.location.y - 10, 20, 20)
end

function Food:toObject()
    return {x=self.location.x, y=self.location.y}
end
