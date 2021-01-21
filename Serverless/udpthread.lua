local code = [[
    local port, channel_name, manager = ...
    print("Port = ", port, " channel = ", channel_name, " manager = ", manager.objects)
    while true do
        print(#manager.foods)
    end
]]

function create_thread(port, channel_name, manager)
    local thread = love.thread.newThread(code)
    thread:start(port, channel_name, manager)
end
