const Packet = require("../packet");

class addEntity extends Packet {
    constructor(entity) {
        const data = {
            id: entity.id,
            type: entity.type,
            position: {
                x: entity.position.x,
                y: entity.position.y
            },
            angle: entity.angle
        };

        super("new_entity", data);
    }
}

module.exports = addEntity;