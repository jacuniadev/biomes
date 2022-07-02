return class {
    init = function(self)
        self.font = fonts:get("EXTRABOLD_BIG");
        self.logo = sprites:get("MENU_LOGO");
        self.global_alpha = 0;

        self.buttons = {
            {
                text = "Play";
                alpha = 0.6;
                hovered = false;
                callback = function()
                    
                end;
            };
            {
                text = "Settings";
                alpha = 0.6;
                hovered = false;
                callback = function()
                    
                end;
            };
            {
                text = "Quit";
                alpha = 1;
                hovered = false;
                callback = function()
                    
                end;
            };
        }
    end;

    update = function(self, delta)
        -- update global alpha up to 1
        self.global_alpha = math.min(self.global_alpha + delta * 0.22, 1);

        -- update buttons alpha when hovering
        for button_name, button_data in pairs(self.buttons) do
            if button_data.hovered then
                button_data.alpha = math.min(button_data.alpha + delta * 2.15, 1);
            else
                button_data.alpha = math.max(button_data.alpha - delta * 2.15, 0.65);
            end;
        end;
    end;

    draw = function(self)
        -- draw world
        user.world:draw();

        -- draw rectangle black background
        utils:drawRectangle(0, 0, user.screen.width, user.screen.height, {0, 0, 0, 169 * self.global_alpha});

        -- logo params
        local logoWidth, logoHeight = self.logo:getDimensions();
        local logoX, logoY = logoWidth * user.screen.ratio - 180, logoHeight * user.screen.ratio + 20;

        -- logo draw
        utils:drawImage(
            logoX, logoY,
            logoWidth * user.screen.ratio, logoHeight * user.screen.ratio,
            0,
            self.logo,
            {255, 255, 255, 255 * self.global_alpha}
        );

        local buttonOffset = 0;

        -- buttons
        for _, button in pairs(self.buttons) do
            local buttonText = button.text;
            local buttonWidth, buttonHeight = self.font:getWidth(buttonText), self.font:getHeight();
            buttonOffset = buttonOffset - buttonHeight;

            local buttonX, buttonY = logoX - 230, logoY + 90 * user.screen.ratio - buttonOffset;            
            local isButtonHovered = utils:isMouseInPosition(buttonX, buttonY - 20, buttonWidth, buttonHeight);
            local buttonHoverAlpha = isButtonHovered and 255 or 200;

            if isButtonHovered then button.hovered = true; else button.hovered = false; end

            -- draw button
            utils:drawText(
                buttonText,
                buttonX, buttonY - 20,
                buttonWidth, buttonHeight,
                self.font,
                "right", nil,
                {200, 200, 200, buttonHoverAlpha * button.alpha * self.global_alpha}
            );
        end
    end;
}