local sprites = {
    -- Main menu sprites
    MENU_LOGO = "assets/graphics/ui/menu/logo.png";
    -- HUD sprites
    HUD_FOOD_ICON = "assets/graphics/ui/hud/food.png";
    HUD_HEALTH_ICON = "assets/graphics/ui/hud/health.png";
    -- Player sprites
    PLAYER_HEAD = "assets/graphics/entities/player/new/head.png";
    PLAYER_HAND = "assets/graphics/entities/player/new/hand.png";
    -- Object sprites
    OBJECT_TREE_BIG = "assets/graphics/entities/objects/tree/big.png";
    OBJECT_TREE_SMALL = "assets/graphics/entities/objects/tree/small.png";
};

return class {
    init = function(self)
        -- loaded sprites list
        self.loaded_sprites = {};

        -- load sprites
        for sprite_name, sprite_path in pairs(sprites) do
            -- check if sprite is already loaded
            if not self.loaded_sprites[sprite_name] then
                -- check if sprite file exists
                if love.filesystem.getInfo(sprite_path) then
                    -- load sprite
                    self.loaded_sprites[sprite_name] = love.graphics.newImage(sprite_path);
                else
                    print(("Sprites - sprite file does not exist: %s"):format(sprite_path));
                end
            end
        end
    end;

    get = function(self, sprite_name)
        -- check if sprite is loaded
        if self.loaded_sprites[sprite_name] then
            return self.loaded_sprites[sprite_name];
        end

        print(("Sprites:get() - sprite is not loaded: %s"):format(sprite_name));
        return nil;
    end;
};