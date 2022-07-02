const Socket = require("./socket");

const Player = require("./entities/player");

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
        new Player(this, socket);
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

    addEntity(entity) {
        const eid = this.eids.length > 0 ? this.eids.pop() : this.cursors.eid++;

        entity.isDestroyed = false;
        entity.setId(eid);

        this.entities.push(entity);

        const packet = new addEntity(entity);

        for (let index = this.clients.length; index--;) {
            const client = this.clients[index];

            if (client && client.socket.isConnected) {
                client.socket.write(packet.json);
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
        
    }

    update(delta, unix) {
        for (let index = this.entities.length; index--;) {
            const entity = this.entities[index];

            if (!entity.isDestroyed) {
                entity.update(delta, unix);
            }
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