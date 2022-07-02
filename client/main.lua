-- global modules
json = require("libs.json");
class = require("libs.class");
bitwise = require("libs.bitop");

-- game modules
local GAME_UTILS = require("game.utils");
local GAME_FONTS = require("game.fonts");
local GAME_SPRITES = require("game.sprites");
local GAME_SOUNDS = require("game.sounds");
local GAME_NETWORKING = require("game.networking.main");

-- user modules
local GAME_USER_HWID = require("game.user.fairplay.hwid");
local GAME_USER_SCENE = require("game.user.scene");
local GAME_USER_WORLD = require("game.user.world");
local GAME_USER_CAMERA = require("game.user.camera");

-- entities
local GAME_ENTITY_PLAYER = require("game.entities.player");

-- global variables
tick = 0;
_delta = 0;

fonts = GAME_FONTS();
sprites = GAME_SPRITES();
sounds = GAME_SOUNDS();
user = {
    id = -1;                                                        -- player id (for network & easy identification entity)
    hwid = GAME_USER_HWID();                                        -- user hwid
    mouse = { x = 0; y = 0 },                                       -- user mouse
    screen = { width = 0; height = 0; ratio = 1000 / 2152 };        -- user screen size & ratio
    world = GAME_USER_WORLD();                                      -- user game world
    scene = GAME_USER_SCENE();                                      -- user game scenes
    camera = GAME_USER_CAMERA(0, 0);                                -- user game camera
    entity = GAME_ENTITY_PLAYER("( = ^_^ = )", 0, 0);                         -- user game entity
    networking = GAME_NETWORKING();                                 -- user networking
};
utils = GAME_UTILS();

-- game loaded
love.load = function()
    -- update user screen & mouse data
    utils:updateUserData();

    user.world:addEntity(user.entity);
    user.networking:connect("localhost", 3000);
end;

-- game update
love.update = function(delta)
    _delta = delta;
    tick = tick + delta * 1000;

    -- update user screen & mouse data
    utils:updateUserData();

    -- update user game
    user.scene:update(delta);
    user.networking:update(delta);
end;

-- game draw
love.draw = function()
   return user.scene:draw();
end;