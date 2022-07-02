-- ALPHA/BETA/DEBUG PURPOSES ONLY
 
local size_init = 15;

local size = {
    w = 860 * size_init;
    h = 860 * size_init;
};

return {
    width = size.w;
    height = size.h;
    tiles = {
        {
            type = "grass";
            x = -2048;
            y = -1152;
            w = size.w;
            h = size.h;
        }
    };
    objects = {
        {
            type = "tree";
            x = 0;
            y = 0;
        };
        {
            type = "tree";
            x = -340;
            y = -390;
        };
        {
            type = "tree";
            x = -640;
            y = -120;
        };
        {
            type = "tree";
            x = -299;
            y = 500;
        };
        {
            type = "tree";
            x = 332;
            y = 500;
        };
        {
            type = "tree";
            x = 542;
            y = -273;
        };
    };
};