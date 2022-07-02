local SCENE_GAME = require("game.scenes.game");
local SCENE_MENU = require("game.scenes.menu");

return class {
    init = function(self)
        self.scenes = {
            GAME = SCENE_GAME();
            MENU = SCENE_MENU();
        }

        self.current_scene = self.scenes.GAME;
    end;

    setScene = function(self, scene)
        if self.scenes[scene] then
            self.current_scene = self.scenes[scene];
        end;
    end;

    update = function(self, delta)
        self.current_scene:update(delta);
    end;

    draw = function(self)
        self.current_scene:draw();
    end;
};