local cron = require("libs.cron");
local inspect = require("libs.inspect");

local socket = require("socket");

local entity_types = require("game.types.entities");

local PLAYER_ENTITY = require("game.entities.player");

return class {
    init = function(self)
        self.socket = false;
        
        self.details = {
            host = nil;
            port = nil;

            -- socket stats
            sent = 0;
            received = 0;
        };

        self.reconnection = {
            attempts = 0;
            maxAttempts = 3;
            interval = 5 * 1000;
            timer = false;
        };
    end;

    update = function(self, delta)
        local data, message, received, sent;

        if self.socket then
            repeat
                data, message = self.socket:receive("*l");
                received, sent = self.socket:getstats();

                if data then
                    if type(data) == "string" then
                        local m = json.decode(data);
                        
                        if m.action == "game_joined" then
                            if m.data then
                                if next(m.data.entities) ~= nil then
                                    for i, entity in ipairs(m.data.entities) do
                                        if entity.type == entity_types["PLAYER"] then
                                            local e = PLAYER_ENTITY(nil, entity.position.x, entity.position.y);

                                            if e then
                                                e:setId(entity.id);

                                                if not user.world:isEntityExists(e) then
                                                    user.world:addEntity(e);
                                                end

                                                if m.data.eid and m.data.eid == entity.id then
                                                    e:setNickname(user.entity.nickname);
                                                    
                                                    user.id = m.data.eid;
                                                    user.entity = e;
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end

                    print(data);
                elseif message ~= "timeout" then
                    if message == "Socket is not connected" then
                        -- self:reconnect();
                    end

                    print("Networking error: " .. message);

                    self.socket:close();
                    self.socket = false;
                end
            until not data;
        end;
    end;

    send = function(self, message) 
        if self.socket then
            if type(message) == "table" then
                message = json.encode(message);
            end

            self.socket:send(message);
        end;
    end;

    connect = function(self, host, port)
        if not host or type(host) ~= "string" then
            print("Networking error: Invalid host");
            return;
        end;

        if not port or type(port) ~= "number" or math.floor(port) ~= port then
            print("Networking error: Invalid port");
            return;
        else
            -- check if port is valid (0-65535)
            if port < 0 or port > 65535 then
                print("Networking error: Invalid port range");
                return;
            end;
        end;

        self.details.host = host;
        self.details.port = port;

        if not self.socket then
            self.socket = socket.tcp();

            self.socket:settimeout(0);
            self.socket:setpeername(self.details.host, self.details.port);
        else
            local peername = self.socket:getpeername();

            if peername.host ~= self.details.host or peername.port ~= self.details.port then
                if self.socket then
                    self.socket:close();
                    self.socket = false;
                end

                self.socket = socket.tcp();

                self.socket:settimeout(0);
                self.socket:setpeername(self.details.host, self.details.port);
            end;
        end;
        
        self:send(
            {
                action = "handshake";
                data = {
                    nickname = user.entity and user.entity.nickname or "";
                    hwid = user.hwid and user.hwid:get() or "NO_HWID";
                }
            }
        );
    end;

    disconnect = function(self)
        if self.socket then
            self.socket:close();
            self.socket = false;
        end;
    end;

    reconnect = function(self)

    end;
};