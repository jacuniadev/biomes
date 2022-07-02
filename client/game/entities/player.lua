local entity = require("game.entities.entity");
local actions = require("game.types.actions");
local entity_types = require("game.types.entities");

return entity:extend {
    init = function(self, nickname, x, y)
        -- super call to have entity datas
        entity.init(self, entity_types["PLAYER"], 0, 150, not x or type(x) ~= "number" and 0 or x, not y or type(y) ~= "number" and 0 or y);

        -- sprites
        self.sprites = {
            HEAD = sprites:get("PLAYER_HEAD");
            HAND = sprites:get("PLAYER_HAND");
        };

        -- fonts
        self.fonts = {
            NICKNAME = {
                FONT = fonts:get("EXTRABOLD_SMALL");
                COLOR = { 200; 200; 200 };
            };
        };

        -- hands position to animate
        self.left_hand = {0, 80};
        self.right_hand = {0, 80};

        -- body elements targets
        self.targets = {
            hands = {0, 0, 80, 80};
        };

        -- properties
        self.nickname   = "";                  -- player nickname
        self.score      = 0;                   -- player score

        -- set player nickname
        if not nickname or type(nickname) ~= "string" then
            self.nickname = "";

            print("Player - nickname is not a string or is nil");
        else
            self.nickname = nickname;
        end
    end;

    draw = function(self)
        local ww, wh = user.world:getMapSize();

        local x, y = utils:getScreenFromWorldPosition(self.position.x, self.position.y);

        -- check by action and animate
        if not self.attacking then
            -- animating hands (idle/walk states)
            if self.action == actions.WALK then
                self.targets.hands = ((tick % 600 > 300) and {30, 30, 80, 80} or {0, 0, 80, 80});
            elseif self.action == actions.IDLE then
                self.targets.hands = ((tick % 700 > 400) and {0, 0, 90, 90} or {0, 0, 80, 80});
            end
        end

        -- update hands
        local actionSpeed = self.action == actions.WALK and 4 or 1.3;

        self.left_hand[1] = self.left_hand[1] + (self.targets.hands[1] - self.left_hand[1]) * _delta * actionSpeed;
        self.left_hand[2] = self.left_hand[2] + (self.targets.hands[3] - self.left_hand[2]) * _delta * actionSpeed;
        self.right_hand[1] = self.right_hand[1] + (self.targets.hands[2] - self.right_hand[1]) * _delta * actionSpeed;
        self.right_hand[2] = self.right_hand[2] + (self.targets.hands[4] - self.right_hand[2]) * _delta * actionSpeed;

        -- draw player head with ratio
        local hw, hh = self.sprites.HEAD:getDimensions();
        utils:drawImage(x, y, hw * user.screen.ratio - 15, hh * user.screen.ratio - 15, self.angle, self.sprites.HEAD);

        -- draw player hands with ratio
        local hhw, hhh = self.sprites.HAND:getDimensions();
        local hx, hy = utils:getPointFromDistanceRotation(x, y, self.left_hand[1] * user.screen.ratio, -self.angle);
        hx, hy = utils:getPointFromDistanceRotation(hx, hy, self.left_hand[2] * user.screen.ratio, -self.angle + 90);
        utils:drawImage(hx, hy, hhw * user.screen.ratio - 10.5, hhh * user.screen.ratio - 10.5, 180, self.sprites.HAND);

        hx, hy = utils:getPointFromDistanceRotation(x, y, self.right_hand[1] * user.screen.ratio, -self.angle);
        hx, hy = utils:getPointFromDistanceRotation(hx, hy, self.right_hand[2] * user.screen.ratio, -self.angle - 90);
        utils:drawImage(hx, hy, hhw * user.screen.ratio - 10.5, hhh * user.screen.ratio - 10.5, 0, self.sprites.HAND);

        -- draw player nickname on middle of player head
        local nicknameX, nicknameY = x - self.fonts.NICKNAME.FONT:getWidth(self.nickname) / 2, y - self.fonts.NICKNAME.FONT:getHeight() * 2.6;
        utils:drawText(self.nickname, nicknameX, nicknameY, self.fonts.NICKNAME.FONT:getWidth(self.nickname), self.fonts.NICKNAME.FONT:getHeight(), self.fonts.NICKNAME.FONT, "center", "center");
    end;
};