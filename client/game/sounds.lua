local sounds = {
    -- Main menu sounds
    MAIN_MENU_BACKGROUND = "assets/sounds/menu/1.mp3";
    -- Entities sounds
    ENTITY_PLAYER_ATTACK = "assets/sounds/entities/player/attack.mp3";  
};

return class {
    init = function(self)
        self.loaded_sounds = {};

        for sound_name, sound_path in pairs(sounds) do
            if not self.loaded_sounds[sound_name] then
                if love.filesystem.getInfo(sound_path) then
                    self.loaded_sounds[sound_name] = love.audio.newSource(sound_path, "static");
                else
                    print(("Sounds - sound file does not exist: %s"):format(sound_path));
                end
            end
        end
    end;

    get = function(self, sound_name)
        if self.loaded_sounds[sound_name] then
            return self.loaded_sounds[sound_name];
        end

        print(("Sounds:get() - sound is not loaded: %s"):format(sound_name));
        return nil;
    end;
}