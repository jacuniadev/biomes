return class {
    init = function(self, x, y)
        self.x = x or 0;
        self.y = y or 0;

        self.speed = 4.3;
    end;

    get = function(self)
        return self.x, self.y;
    end;
    
    update = function(self, delta)
        if not user.world then return end;

        local ww, wh = user.world:getMapSize();

        -- camera moving
        self.x = self.x + (user.entity.position.x - self.x) * delta * self.speed;
        self.y = self.y + (user.entity.position.y - self.y) * delta * self.speed;

        -- camera bound
        if self.x < 0 then
            self.x = 0;
        elseif self.x > ww then
            self.x = ww;
        end

        if self.y < 0 then
            self.y = 0;
        elseif self.y > wh then
            self.y = wh;
        end
    end;
};