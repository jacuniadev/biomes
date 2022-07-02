const { PACKETS } = require('../constants');
const Packet = require('../packet');

class Welcome extends Packet {
    constructor(data) {
        super(PACKETS.WELCOME, data);
    }
}

module.exports = Welcome;