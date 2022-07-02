const { ENTITY } = require("../constants");
const Entity = require("../entity");

const { isEmptyOrSpaces } = require("../utils");

class Player extends Entity {
    constructor(gameServer, socket) {
        super(ENTITY.PLAYER);

        if (!gameServer) throw Error("Game server is required");
        this.gameServer = gameServer;
        this.gameServer.on("message", this.onMessage.bind(this));

        if (!socket) throw Error("Socket is required");
        this.socket = socket;

        this.handshaked = false;
    }

    setHwid(hwid) {
        if (!hwid || isEmptyOrSpaces(hwid)) {
            // TODO: kick player
            return;   
        } else {
            // TODO: HWID service checkout if hwid is valid or invalid

            this.hwid = hwid;
        }
    }

    setNickname(nickname) {
        if (!nickname || isEmptyOrSpaces(nickname)) nickname = `Player #${this.id !== -1 ? this.id : this.socket.connectionId}`;

        this.nickname = nickname;
    }

    onMessage(message) {
        const { connectionId, message: raw } = message;

        if (connectionId === this.socket.connectionId) {
            switch (typeof raw) {
                case "string": {
                    try {
                        const json = JSON.parse(raw);
                        const { action, data } = json;

                        switch (action) {
                            case "handshake": {
                                if (this.handshaked) return;

                                const { nickname, hwid } = data;
                                const eid = 10000 + this.gameServer.entities.length + 1;

                                this.setId(eid);
                                this.setHwid(hwid);
                                this.setNickname(nickname);

                                this.handshaked = true;
                                this.gameServer.players.push(this);
                                this.gameServer.entities.push(this);

                                console.log(`${this.nickname} (HWID: ${this.hwid}, EID: ${eid}, SID: ${connectionId}) connected to the server`);
                                break;
                            }
                            case "chat": {
                                break;
                            }
                        }
                    } catch(e) { }
                    break;
                }
            }
        }
    }
}

module.exports = Player;