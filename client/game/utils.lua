return class {
    init = function(self)
        self.keys = {
            ["walk_forward"] = {"w"};
            ["walk_backward"] = {"s"};
            ["walk_left"] = {"a"};
            ["walk_right"] = {"d"};
            ["hit"] = {"mouse1"};
        };
    end;

    isMouseInPosition = function(self, x, y, width, height)
        local cx, cy = love.mouse.getPosition();
        
        return ((cx >= x and cx <= x + width) and (cy >= y and cy <= y + height));
    end;

    updateUserData = function(self)
        local cx, cy = love.mouse.getPosition();
        local w, h = love.graphics.getDimensions();

        user.screen.width = w;
        user.screen.height = h;

        user.mouse.x = cx;
        user.mouse.y = cy;
    end;

    getScreenFromWorldPosition = function(self, x, y)
        local cx, cy = user.screen.width / 2 + x * user.screen.ratio - user.camera.x * user.screen.ratio, user.screen.height / 2 + y * user.screen.ratio - user.camera.y * user.screen.ratio
            
        return cx, cy;
    end;

    getPointFromDistanceRotation = function(self, x, y, dist, angle)
        local a = math.rad(90 - angle);
        local dx = math.cos(a) * dist;
        local dy = math.sin(a) * dist;

        return x + dx, y + dy;
    end;

    findRotation = function(self, x1, y1, x2, y2) 
        local t = -math.deg(math.atan2(x2 - x1, y2 - y1));

        return t < 0 and t + 360 or t
    end;
    
    isBoundKeyDown = function(self, name)
        for _, key in pairs(self.keys[name]) do
            local mouse = (key:find("mouse") and tonumber(key:gsub("mouse", "")) or 333)
            if love.keyboard.isDown(key) or (mouse and love.mouse.isDown(mouse)) then return true, key end
        end
        return false
    end;

    isAnyBoundKeyDown = function(self, ...)
        for _, key in pairs({...}) do
            local _c = self:isBoundKeyDown(key)
            if _c then return true end
        end
        return false
    end;

    _setColor = function(self, color)
        if color then
            love.graphics.setColor(color[1]/255, color[2]/255, color[3]/255, (tonumber(color[4])) and (color[4]/255) or 1)
        else
            love.graphics.setColor(1, 1, 1, 1)
        end
    end;

    drawRectangle = function(self, x, y, w, h, color, type, segments)
        self:_setColor(color);

        if not type then type = "fill" end;
        if not segments then segments = 0 end;

        love.graphics.rectangle(type, x, y, w, h, 0, 0, segments);
    end;

    drawImage = function(self, x, y, w, h, rotation, image, color)
        if not image then return end;

        local width, height = image:getDimensions();

        self:_setColor(color);
        love.graphics.draw(image, x, y, (rotation or 0)/20/2.8647889756541, w / width, h / height, width / 2, height / 2);
    end;

    drawText = function(self, text, x, y, w, h, fontSet, alignX, alignY, color)
        self:_setColor(color);

        if fontSet then
            love.graphics.setFont(fontSet)
        end
        local _, wt = love.graphics.getFont():getWrap(text,tonumber(w) or 9999)
        local height = #wt * (love.graphics.getFont()):getHeight()
        if alignY and alignY == "center" then
            y = y + (h/2) - (height/2)
        end
        love.graphics.printf(text, x, y, (tonumber(w)) and w or 9999, (tostring(alignX) == alignX) and alignX or "left")
    end;
};