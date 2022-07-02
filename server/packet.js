class Packet {
    constructor(action, data) {
        this.action = action;
        this.data = data;
    }

    get json() {
        return JSON.stringify(this);
    }
}

module.exports = Packet;