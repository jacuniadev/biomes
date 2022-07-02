local fonts = {
    MEDIUM_SMALL = {
        path = "assets/fonts/medium.ttf";
        size = 16;
    };
    MEDIUM_MEDIUM = {
        path = "assets/fonts/medium.ttf";
        size = 24;
    };
    MEDIUM_BIG = {
        path = "assets/fonts/medium.ttf";
        size = 48;
    };
    REGULAR_SMALL = {
        path = "assets/fonts/regular.ttf";
        size = 16;
    };
    REGULAR_MEDIUM = {
        path = "assets/fonts/regular.ttf";
        size = 24;
    };
    REGULAR_BIG = {
        path = "assets/fonts/regular.ttf";
        size = 48;
    };
    EXTRABOLD_SMALL = {
        path = "assets/fonts/extrabold.ttf";
        size = 16;
    };
    EXTRABOLD_MEDIUM = {
        path = "assets/fonts/extrabold.ttf";
        size = 24;
    };
    EXTRABOLD_BIG = {
        path = "assets/fonts/extrabold.ttf";
        size = 48;
    };
};

return class {
    init = function(self)
        -- loaded fonts list
        self.loaded_fonts = {};

        -- load fonts
        for font_name, font_data in pairs(fonts) do
            -- check if font is already loaded
            if not self.loaded_fonts[font_name] then
                -- check if font file exists
                if love.filesystem.getInfo(font_data.path) then
                    -- load font
                    self.loaded_fonts[font_name] = love.graphics.newFont(font_data.path, font_data.size);
                else
                    print(("Fonts - font file does not exist: %s"):format(font_data.path));
                end
            end
        end
    end;

    get = function(self, font_name)
        -- check if font is loaded
        if self.loaded_fonts[font_name] then
            return self.loaded_fonts[font_name];
        end

        print(("Fonts:get() - font is not loaded: %s"):format(font_name));
        return nil;
    end;
};