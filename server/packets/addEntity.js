const Packet = require("../packet");

const { PACKETS } = require("../constants");

class AddEntity extends Packet {
    constructor(entity) {
        if (!entity) throw Error("Entity is required!");

        const data = {
            id: entity.id,
            type: entity.type,
            position: {
                x: entity.position.x,
                y: entity.position.y
            },
            angle: entity.angle
        };

        super(PACKETS.NEW_ENTITY, data);
    }
}

module.exports = AddEntity;