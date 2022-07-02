module.exports = {
    isEmptyOrSpaces: str => {
        if (typeof str !== "string")
            return null;

        return str === null || str.match(/^ *$/) !== null;
    }
};