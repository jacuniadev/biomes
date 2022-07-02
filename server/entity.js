const { ENTITY } = require("./types");

class Entity {
    constructor(type) {
        this.type = type;

        this.id = -1;
        this.isDestroyed = false;

        this.angle = 0;
        this.position = { x: 0, y: 0 };
    }

    setId(id = -1) {
        this.id = id;
    }

    setAngle(angle = 0) {
        if (this.isDestroyed) return;

        this.angle = angle || 0;
    }

    setPosition(x = 0, y = 0) {
        if (this.isDestroyed) return;

        this.position.x = x || 0;
        this.position.y = y || 0;
    }

    update() {
        if (this.isDestroyed) return;

        switch (this.type) {
            case ENTITY.PLAYER: {
                break;
            }
            default: {
                break;
            }
        }
    }
}

module.exports = Entity;