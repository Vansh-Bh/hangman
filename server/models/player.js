const mongoose = require("mongoose");

const playerSchema = new mongoose.Schema({
  nickname: {
    type: String,
  },
  socketID: {
    type: String,
  },
  isPartyLeader: {
    type: Boolean,
    default: false,
  },
});

module.exports = playerSchema;