local actions = require("game.types.actions");
local entity_types = require("game.types.entities");

local entity = class {
    init = function(self, eType, angle, speed, x, y)
        self.id = -1;
        self.type = eType or entity_types["NONE"];
        
        self.speed = self.type == entity_types["NONE"] or self.type == entity_types["OBJECT"] and 0 or speed or 0;
        self.action = self.type == entity_types["NONE"] or self.type == entity_types["OBJECT"] and actions.NONE or actions.IDLE;

        self.angle = angle or 0;
        self.position = { x = x or 0; y = y or 0 };
        
        self.health = 100;
        self.max_health = 100;
        
        self.attacking = false;
    end;

    setId = function(self, id)
        if (id and type(id) == "number") then
            self.id = id;
        end;
    end;

    update = function(self, delta)
        if self.type == entity_types["NONE"] or self.type == entity_types["OBJECT"] then
            return;
        end

        if self.type == entity_types["PLAYER"] then
            if user.entity and user.world:isEntityExists(user.entity) then
                local ex, ey = utils:getScreenFromWorldPosition(user.entity.position.x, user.entity.position.y);
                user.entity.angle = utils:findRotation(ex, ey, user.mouse.x, user.mouse.y);

                -- entity moving
                if utils:isBoundKeyDown("walk_forward") then
                    user.entity.position.y = user.entity.position.y - user.entity.speed * delta;
                elseif utils:isBoundKeyDown("walk_backward") then
                    user.entity.position.y = user.entity.position.y + user.entity.speed * delta;
                end

                if utils:isBoundKeyDown("walk_left") then
                    user.entity.position.x = user.entity.position.x - user.entity.speed * delta;
                elseif utils:isBoundKeyDown("walk_right") then
                    user.entity.position.x = user.entity.position.x + user.entity.speed * delta;
                end

                -- entity acting
                if utils:isAnyBoundKeyDown("walk_forward", "walk_backward", "walk_left", "walk_right") then
                    user.entity.action = actions.WALK;
                else
                    user.entity.action = actions.IDLE;
                end
            end
        end
    end;
};

return entity;