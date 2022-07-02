local fake_map = require("game.maps.menu");

return class {
    init = function(self)
        self.objects_sprites = {
            TREE = sprites:get("OBJECT_TREE_SMALL");
        };
        self.map = fake_map;
        self.entities = {};
    end;

    addEntity = function(self, entity)
        for _, e in pairs(self.entities) do
            if e == entity then
                return;
            end
        end

        table.insert(self.entities, entity);
    end;

    removeEntity = function(self, entity)
        for i, v in ipairs(self.entities) do
            if v == entity then
                table.remove(self.entities, i);
                break;
            end
        end
    end;

    isEntityExists = function(self, entity)
        for _, e in pairs(self.entities) do
            if e == entity then
                return true;
            end
        end

        return false;
    end;

    setMap = function(self, map)
        self.map = map;
    end;

    getMapSize = function(self)
        if self.map then
            return self.map.width, self.map.height;
        end
    end;

    update = function(self, delta)
        for _, entity in pairs(self.entities) do
            entity:update(delta);
        end
    end;

    draw = function(self)
        -- due i was lazy to make bounding box for whole map, i just lil black rectangle for it
        utils:drawRectangle(0, 0, user.screen.width, user.screen.height, {10, 20, 17});

        if self.map and next(self.map) ~= nil then
            if self.map.tiles then
                for _, map_tile in pairs(self.map.tiles) do
                    local x, y = utils:getScreenFromWorldPosition(map_tile.x, map_tile.y);
            
                    if map_tile.type == "grass" then
                        utils:drawRectangle(x, y, map_tile.w, map_tile.h, {21, 45, 36});
                    end
                end
            end

            if self.map.objects then
                for _, map_objects in pairs(self.map.objects) do
                    local x, y = utils:getScreenFromWorldPosition(map_objects.x, map_objects.y);
            
                    local sprite;
                    local spriteWidth, spriteHeight;

                    if map_objects.type == "tree" then
                        sprite = self.objects_sprites.TREE or nil;
                        spriteWidth, spriteHeight = sprite and sprite:getWidth() or 0, sprite and sprite:getHeight() or 0;

                        if sprite then
                            utils:drawImage(x, y, spriteWidth - 150, spriteHeight - 150, nil, sprite, {255, 255, 255});
                        end
                    end
                end
            end
        end

        for _, entity in pairs(self.entities) do entity:draw() end;
    end;
}