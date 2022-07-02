const { PACKETS } = require("../constants");

const Packet = require("../packet");


class Update extends Packet {
    constructor(data) {
        super(PACKETS.UPDATE, data);
    }
}

module.exports = Update;