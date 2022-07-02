const Socket = require("./socket");

const Player = require("./entities/player");

const Welcome = require("./packets/welcome");
const AddEntity = require("./packets/addEntity");
const Update = require("./packets/update");

const TICKS = 1000 / 16;
console.log("ticks", TICKS);

class GameServer extends Socket {
    constructor() {
        super(
            {
                port: 3000,
            }
        );

        this.clients = new Map();
        this.inactiveClients = [];

        this.entities = [];
        this.inactiveEntities = [];
        this.destroyedEntities = [];

        this.cursors = {
            client: 1,
            entity: 1
        };
    
        setInterval(() => this.update(TICKS, Date.now()), TICKS);

        this.on("listening", this.onListen.bind(this));
    }

    onListen(details) {
        console.log("Server listening on", details.port);

        this.on("connect", this.onConnection.bind(this));   
    }

    onConnection(socket) {
        return this.addClient(socket);
    }

    _deleteEntity(entity) {
        const index = this.entities.indexOf(entity);

        if (index === -1) throw Error("Entity is not in world!");

        const len = this.entities.length - 1;

        if (index !== len) {
            const tmp = this.entities[index];

            this.entities[index] = entities[len];
            this.entities[len] = tmp;
        }

        this.entities.pop();
    }

    destroyEntity(entity) {
        if (entity.id === -1) return;

        entity.isDestroyed = true;
        this.destroyedEntities.push(entity);
    }

    addEntity(entity) {
        const eid = this.inactiveEntities.length > 0 ? this.inactiveEntities.pop() : this.cursors.entity++;

        entity.isDestroyed = false;
        entity.setId(eid);
        this.entities.push(entity);

        const packet = new AddEntity(entity);

        for (let index = this.clients.length; index--;) {
            const client = this.clients[index];

            if (client && client.socket.isConnected) {
                if (packet)
                    this.sendToSocket(client.socket, packet);
            }
        }
    }

    removeEntity(entity) {
        const index = this.entities.indexOf(entity);

        if (index === -1) throw Error("Entity is not in world!");

        const len = this.entities.length - 1;

        if (index !== len) {
            const tmp = this.entities[index];

            this.entities[index] = entities[len];
            this.entities[len] = tmp;
        }

        this.entities.pop();

        entity.setId(-1);
        entity.isDestroyed = true;
    }

    addClient(socket) {
        const cid = this.inactiveClients.length > 0 ? this.inactiveClients.pop() : this.cursors.client++;
        
        socket.clientId = cid;
        this.clients.set(cid, socket);

        const player = new Player(this, socket);
        this.addEntity(player);

        const tmp_entities = [];
        for (let index = this.entities.length; index--;) {
            const entity = this.entities[index];

            if (entity && !entity.isDestroyed) {
                tmp_entities.push({
                    id: entity.id,
                    type: entity.type,
                    angle: entity.angle,
                    position: entity.position
                })
            }
        }

        const packet = new Welcome({
            eid: player.id,
            entities: tmp_entities,
        });
        this.sendToSocket(socket, packet);
    }

    removeClient(socket) {
        const cid = socket.clientId;
        if (!cid) throw Error("Client has no id!");

        this.inactiveClients.push(cid);
    }

    update(delta, unix) {
        for (let index = this.entities.length; index--;) {
            const entity = this.entities[index];

            if (!entity.isDestroyed) {
                entity.update(delta, unix);
            }
        }

        const tmp = [];
        for (let index = this.entities.length; index--;) {
            const entity = this.entities[index];

            if (!entity.isDestroyed) {
                tmp.push({
                    id: entity.id,
                    position: entity.position,
                    angle: entity.angle
                });
            }
        }

        const packet = new Update(tmp);
        if (packet) {
            this.sendToAllSockets(packet.json);
        }

        if (this.destroyedEntities.length > 0) {
            for (let index = this.destroyedEntities.length; index--;) {
                const entity = this.destroyedEntities[index];

                if (entity) {
                    this._deleteEntity(entity);
                }
            }

            this.destroyedEntities.length = 0;
        }
    }
}

module.exports = GameServer;