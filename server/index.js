const express = require("express");
const http = require("http");
const mongoose = require("mongoose");
const Game = require("./models/game");

const app = express();
const port = process.env.PORT || 3000;
const server = http.createServer(app);
const io = require("socket.io")(server);
require('dotenv').config();

app.use(express.json());

const DB = process.env.MONGODB_URI;

io.on("connection", (socket) => {
  console.log(`New connection: ${socket.id}`);

  socket.on("host-game", async ({ nickname }) => {
    try {
      let game = new Game();
      let player = {
        socketID: socket.id,
        nickname,
        isPartyLeader: true,
      };
      game.players.push(player);
      game.isJoin = true; 
      game = await game.save();

      const gameId = game._id.toString();
      socket.join(gameId);
      io.to(gameId).emit("updateGame", game);
    } catch (e) {
      console.log(`Error in host-game: ${e}`);
    }
  });

  socket.on("join-game", async ({ nickname, gameId }) => {
    try {
      if (!gameId.match(/^[0-9a-fA-F]{24}$/)) {
        socket.emit("notCorrectGame", "Please enter a valid game ID");
        return;
      }
      let game = await Game.findById(gameId);

      if (game && game.isJoin) {
        const id = game._id.toString();
        let player = {
          nickname,
          socketID: socket.id,
        };
        socket.join(id);
        game.players.push(player);
        game = await game.save();
        io.to(gameId).emit("updateGame", game);
      } else {
        socket.emit(
          "notCorrectGame",
          "The game is in progress or has ended, please try again later!"
        );
      }
    } catch (e) {
      console.log(`Error in join-game: ${e}`);
    }
  });

  socket.on("sendWord", async ({ gameId, word }) => {
    try {
      console.log(`Received word: ${word}`);
      if (word.length !== 5) {
        socket.emit("invalidWord", "The word must be exactly 5 letters long.");
        return;
      }

      let game = await Game.findById(gameId);

      if (game) {
        let player = game.players.find(player => player.socketID === socket.id);
        if (player) {
          player.word = word;
          game = await game.save();

          if (game.players.every(player => player.word)) {
            const [player1, player2] = game.players;
            io.to(player1.socketID).emit("receiveWord", player2.word);
            io.to(player2.socketID).emit("receiveWord", player1.word);
          }
        }
      }
    } catch (e) {
      console.log(`Error in sendWord: ${e}`);
    }
  });

  socket.on("successfulGuess", async ({ gameId }) => {
    try {
      let game = await Game.findById(gameId);

      if (game) {
        let opponent = game.players.find(player => player.socketID !== socket.id);

        if (opponent) {
          io.to(opponent.socketID).emit("lostGame", "");
        }
        game.isJoin = false;
        await game.save();
      }
    } catch (e) {
      console.log(`Error in successfulGuess: ${e}`);
    }
  });

  socket.on("unsuccessfulGuess", async ({ gameId }) => {
    try {
      let game = await Game.findById(gameId);

      if (game) {
        let opponent = game.players.find(player => player.socketID !== socket.id);

        if (opponent) {
          io.to(opponent.socketID).emit("wonGame", "");
        }
        game.isJoin = false;
        await game.save();
      }
    } catch (e) {
      console.log(`Error in unsuccessfulGuess: ${e}`);
    }
  });

  socket.on("disconnect", async () => {
    try {
      console.log(`Player disconnected: ${socket.id}`);
      let game = await Game.findOne({ "players.socketID": socket.id });

      if (game) {
        game.players = game.players.filter(player => player.socketID !== socket.id);

        if (game.players.length === 0) {
          await Game.deleteOne({ _id: game._id });
        } else {
          game = await game.save();
          io.to(game._id.toString()).emit("updateGame", game);
        }
      }
    } catch (e) {
      console.log(`Error on disconnect: ${e}`);
    }
  });
});

mongoose.connect(DB)
  .then(() => {
    console.log("Database connection successful");
  })
  .catch((e) => {
    console.log(`Database connection error: ${e}`);
  });

server.listen(port, "0.0.0.0", () => {
  console.log(`Server started and running on port ${port}`);
});
