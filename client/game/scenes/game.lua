local hud = require("game.scenes.ui.hud");

return class {
    init = function(self) 
        self.hud = hud();
    end;

    update = function(self, delta)
        if not user then return end;

        -- update game stuff
        user.world:update(delta);
        user.camera:update(delta);
        
        -- update ui (animations, etc.)
        self.hud:update(delta);
    end;

    draw = function(self)
        if not user then return end;

        -- draw game stuff
        user.world:draw();

        -- draw ui
        self.hud:draw();
    end;
}