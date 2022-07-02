// const Socket = require("./socket");

// const s = new Socket({
//     port: 3000
// });

// s.on("message", message => console.log(message));
// s.on("listening", address => console.log(address));
// s.on("disconnect", socket => console.log(socket.connectionId, "disconnected"));

const GameServer = require("./game");

new GameServer();