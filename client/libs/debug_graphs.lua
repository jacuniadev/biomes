-- Code based on https://github.com/icrawler/FPSGraph

local debugGraph = {}

function debugGraph:new(type, x, y, width, height, delay, label, font)
    if ({mem = 0, fps = 0, custom = 0})[type] == nil then
        error("Acceptable types: mem, fps, custom")
    end

    local instance = {
        x = x or 0, -- X position
        y = y or 0, -- Y position
        width = width or 50, -- Graph width
        height = height or 30, -- Graph height
        delay = delay or 0.5, -- Update delay
        label = label or type, -- Graph label
        font = font or love.graphics.newFont(8),
        data = {},
        _max = 0,
        _time = 0,
        _type = type
    }

    -- Build base data
    for i = 0, math.floor(instance.width / 2) do
        table.insert(instance.data, 0)
    end

    -- Updating the graph
    function instance:update(dt, val)
        local lastTime = self._time
        self._time = (self._time + dt) % self.delay

        -- Check if the minimum amount of time has past
        if dt > self.delay or lastTime > self._time then
            -- Fetch data if needed
            if val == nil then
                if self._type == "fps" then
                    -- Collect fps info and update the label
                    val = 0.75 * 1 / dt + 0.25 * love.timer.getFPS()
                    self.label = "FPS: " .. math.floor(val * 10) / 10
                elseif self._type == "mem" then
                    -- Collect memory info and update the label
                    val = collectgarbage("count")
                    self.label = "Memory (KB): " .. math.floor(val * 10) / 10
                else
                    -- If the val is nil then we'll just skip this time
                    return
                end
            end

            -- pop the old data and push new data
            table.remove(self.data, 1)
            table.insert(self.data, val)

            -- Find the highest value
            local max = 0
            for i = 1, #self.data do
                local v = self.data[i]
                if v > max then
                    max = v
                end
            end

            self._max = max
        end
    end

    function instance:draw()
        -- Store the currently set font and change the font to our own
        local fontCache = love.graphics.getFont()
        love.graphics.setFont(self.font)

        local max = math.ceil(self._max / 10) * 10 + 20
        local len = #self.data
        local steps = self.width / len

        -- Build the line data
        local lineData = {}
        for i = 1, len do
            -- Build the X and Y of the point
            local x = steps * (i - 1) + self.x
            local y = self.height * (-self.data[i] / max + 1) + self.y

            -- Append it to the line
            table.insert(lineData, x)
            table.insert(lineData, y)
        end

        -- Draw the line
        love.graphics.line(unpack(lineData))

        -- Print the label
        if self.label ~= "" then
            love.graphics.print(self.label, self.x, self.y + self.height - self.font:getHeight())
        end

        -- Reset the font
        love.graphics.setFont(fontCache)
    end

    return instance
end

return debugGraph
