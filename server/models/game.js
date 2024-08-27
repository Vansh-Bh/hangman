const mongoose = require('mongoose');

const playerSchema = new mongoose.Schema({
    socketID: String,
    nickname: String,
    isPartyLeader: Boolean,
    word: String,
});

const gameSchema = new mongoose.Schema({
    players: [playerSchema],
    isJoin: {
        type: Boolean,
        default: true,
    },
    isOver: {
        type: Boolean,
        default: false,
    },
    isGameStarted: {
        type: Boolean,
        default: false,
    },
    gameCode: {
        type: String,
        unique: true,
        required: true,
    }
});

const Game = mongoose.model('Game', gameSchema);

module.exports = Game;
