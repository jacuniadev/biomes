return class {
    init = function(self)
        self.fonts = {
            PROGRESS_VALUE = fonts:get("EXTRABOLD_SMALL");
        };

        self.animation_speed = 2.3;
        self.progress = {
            health = {
                icon = sprites:get("HUD_HEALTH_ICON");
                color = {
                    background = { 204, 0, 0, 50 };
                    fill = { 204, 0, 0, 255 };
                    text = { 255, 255, 255, 255 };
                };
                value = 0;
                position = { x = 30; y = 135 };
            };
            food = {
                icon = sprites:get("HUD_FOOD_ICON");
                color = {
                    background = { 116, 55, 0, 50 };
                    fill = { 116, 55, 0, 255 };
                    text = { 255, 255, 255, 255 };
                };
                value = 0.6;
                position = { x = 30; y = 75 };
            }
        };
    end;

    update = function(self, delta)
        if not user or not user.world:isEntityExists(user.entity) then return end;

        -- animating progress bar values
        self.progress.health.value = self.progress.health.value + ((user.entity.health / user.entity.max_health) - self.progress.health.value) * delta * self.animation_speed;
    end;

    draw = function(self)
        local barWidth, barHeight = 390 * user.screen.ratio, 42 * user.screen.ratio;

        for progress_name, progress in pairs(self.progress) do
            local x, y = progress.position.x * user.screen.ratio, user.screen.height - progress.position.y * user.screen.ratio;

            local icon = progress.icon or nil;
            local iconWidth, iconHeight = 0, 0;

            if icon then
                iconWidth, iconHeight = icon:getDimensions();
            end

            local color = progress.color or { 255, 255, 255, 255 };

            local value = progress.value or 100;
            local valueText = "";

            -- background + fill
            utils:drawRectangle(x, y, barWidth, barHeight, color.background);
            utils:drawRectangle(x, y, barWidth * value, barHeight, color.fill);

            -- icon
            if icon then
                utils:drawImage(iconWidth - x - 18.5, y + 10, iconWidth * user.screen.ratio, iconHeight * user.screen.ratio, 0, icon, { 255, 255, 255, 255 });
            end

            -- text
            if progress_name == "health" then
                valueText = string.format("%d", user and user.entity and math.floor(user.entity.health / user.entity.max_health * 100) or 0);
            elseif progress_name == "food" then
                valueText = string.format("%d", value * 100);
            end

            utils:drawText(
                valueText,
                barWidth - self.fonts.PROGRESS_VALUE:getWidth(valueText) - x + 25,
                y - 4.5,
                self.fonts.PROGRESS_VALUE:getWidth(valueText),
                0,
                self.fonts.PROGRESS_VALUE,
                "right",
                nil,
                color.text
            );
        end
    end;
}