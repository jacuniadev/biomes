const net = require("net");

const EventEmitter = require("events");

class Socket extends EventEmitter {
    constructor(
        options = {
            port: 3000,
        }
    ) {
        super();

        if (typeof options.port !== "number") throw Error("Port must be a number");
        if (options.port < 0 || options.port > 65535) throw Error("Port range limit reached");
       
        this.options = options;

        this.sockets = [];

        this.server = net.createServer();
        this.server.on("listening", () => this.emit("listening", this.server.address()));
        this.server.on("connection", this._connection.bind(this));

        this.server.listen(this.options.port);
    }

    _destroy(socket) {
        const found = this.sockets.find(s => s.connectionId === socket.connectionId);

        if (found) {
            if (found.isConnected) {
                found.isConnected = false;

                found.destroy();
            }

            this.emit("disconnect", found);
            this.sockets.splice(this.sockets.indexOf(found), 1);
        }
    }

    _connection(socket) {
        socket.setNoDelay(true);
        socket.setKeepAlive(true);

        socket.isConnected = true;
        socket.connectionId = this.sockets.length + 1;

        socket.on("data", raw => this.emit("message", {
            connectionId: socket.connectionId,
            message: raw.toString()
        }));
        socket.on("error", () => this._destroy(socket));
        socket.on("close", () => this._destroy(socket));

        this.emit("connect", socket);
        this.sockets.push(socket);
    }

    getSocketById(id = -1) {
        const found = this.sockets.find(s => s.connectionId === id);

        if (found && found.isConnected)
            return found;

        return null;
    }

    sendToAllSockets(message) {
        for (let index = this.sockets.length; index--;) {
            const socket = this.sockets[index];

            if (socket && socket.isConnected) socket.write(message + "\n");
        }
    }

    sendToSocket(socket, message) {
        message = typeof message === "object" ? JSON.stringify(message) : message;

        if (socket.isConnected)
            return socket.write(message + "\n");

        return false;
    }
};

module.exports = Socket;