Manager = {}
Manager.__index = Manager

function Manager:create()
    local manager = {}
    setmetatable(manager, Manager)
    manager.objects = {}
    manager.nfood = 100
    manager.foods = {}
    manager.time = 0
    manager.decrease = 0
    return manager
end

function Manager:update(dt)
    self.time = self.time + dt
    self:checkFood()
    self:checkOther()
    self:randomForce()
    if #self.foods < self.nfood then
        table.insert(self.foods, Food:create())
    end
    
    local cur_decrease = math.floor(self.time) % 20
    if self.decrease == 0 and cur_decrease == 1 then
        if self.nfood > 20 then
            self.nfood = self.nfood - 1
        end
    end
    self.decrease = cur_decrease

    local count = self:count()
    if (count < math.floor(self.time  / 5)) and (count < 10) then
        local id = love.math.random(0, 10000)
        local r = math.random(30, 60) / 100
        local g = math.random(30, 60) / 100
        local b = math.random(30, 60) / 100
        self:add(id, {r, g, b, 0.7})
        self.objects[id].velocity.x = love.math.random(-6, 6)
        self.objects[id].velocity.y = love.math.random(-6, 6)
    end

    for k, v in pairs(self.objects) do
        v:borders()
        v:update(dt)
        if v:isRotten() then
            self.objects[k] = nil
        end
    end
end

function Manager:applyForce(id, x, y)
    local obj = self.objects[id]
    if obj then
        obj:applyForce(Vector:create(x, y))
    end
end

function Manager:checkClicked(x, y)
    for k, v in pairs(self.objects) do
        local d = v.location:distTo(Vector:create(x, y))
        if d < v.life then
            return v:toObject()
        end
    end
    return nil
end

function Manager:checkFood()
    for k, v in pairs(self.objects) do
        local removes = {}
        for i = 1, #self.foods do
            local d = v.location:distTo(self.foods[i].location)
            if d < v.life then
                v:incLife()
                table.insert(removes, i)
            end
        end
        for i = #removes, 1, -1 do
            table.remove(self.foods, removes[i])
        end
    end
end

function Manager:checkOther()
    for k, v in pairs(self.objects) do
        for k_, v_ in pairs(self.objects) do
            if k ~= k_ then
                local d = v.location:distTo(v_.location)
                if d < v.life + v_.life then
                    if v.life > v_.life then
                        v:incLife(v_.life)
                        self.objects[k_] = nil
                    elseif v.life < v_.life then
                        v_:incLife(v.life)
                        self.objects[k] = nil
                    end
                end
            end
        end
    end
end

function Manager:randomForce()
    local val = love.math.random()
    if val > 0.9 then
        local fx = math.random(-5, 5) / 10
        local fy = math.random(-5, 5) / 10
        for k, v in pairs(self.objects) do
            if not v.human then
                v:applyForce(Vector:create(fx, fy))
            end
        end
    end
end

function Manager:findTenacious()
    local maxLife = -1
    local key = nil
    for k, v in pairs(self.objects) do
        if v.lifeTimer > maxLife then
            maxLife = v.lifeTimer
            key = k
        end
    end
    return {key, maxLife}
end

function Manager:getEnvironment(id)
    local envs = {}
    envs.other = {}
    envs.food = {}
    local obj = self.objects[id]
    if obj then
        for k, v in pairs(self.objects) do
            if k ~= id then
                local d = obj.location:distTo(v.location)
                if d < (obj.life + obj.rsense + v.life) then
                    table.insert(envs.other, v:toObject())
                end
            end
        end
        for i = 1, #self.foods do
            v = self.foods[i]
            local d = obj.location:distTo(v.location)
            if d < (obj.life + obj.rsense) then
                table.insert(envs.food, v:toObject())
            end
        end
    end
    return envs
end

function Manager:add(id, color, human)
    self.objects[id] = Vehicle:create(color, human)
end

function Manager:draw()
    for k, v in pairs(self.objects) do
        v:draw()
    end
    for k, v in pairs(self.foods) do
        v:draw()
    end
end

function Manager:parseCommand(data)
    local status, val = pcall(self.parse, self, data)
    if status then
        return json.encode(val)
    end
    return json.encode({error=val})
end

function Manager:count()
    local count = 0
    for k, v in pairs(manager.objects) do
        count = count + 1 end
    return count
end

function Manager:parse(data)
    local message = json.decode(data)
    if not message.id then
        error("id required")
    end
    if not message.cmd then
        error("cmd required")
    end
    object = self.objects[message.id]
    if message.cmd == "create" then
        if message.color then
            color = message.color
        else
            color = {love.math.random(), love.math.random(), love.math.random()}
        end
        self:add(message.id, message.color, true)
    elseif object == nil then
        return {status = "nil"}
    elseif message.cmd == "force" then
        self:applyForce(message.id, message.x, message.y)
    elseif message.cmd == "env" then
        local answer = self:getEnvironment(message.id)
        answer.cmd = message.cmd
        return answer
    elseif message.cmd == "info" then
        local answer = self.objects[message.id]:toObject()
        answer.cmd = message.cmd
        return answer
    end
    return {status = "ok", cmd=message.cmd}
end