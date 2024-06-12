const express = require("express");
const http = require("http");
const mongoose = require("mongoose");
const Game = require("./models/game");

const app = express();
const port = process.env.port || 3000;
var server = http.createServer(app);
var io = require('socket.io')(server);

app.use(express.json());

const DB = "mongodb+srv://vanshbhardwaj28134:f6Fx48s7xa5a8zmE@cluster0.lthprjf.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";

io.on('connection', (socket) => {
    console.log(socket.id);

    socket.on('host-game', async ({ nickname }) => {
        try {
            let game = new Game();
            let player = {
                socketID: socket.id,
                nickname,
                isPartyLeader: true,
            };
            game.players.push(player);
            game = await game.save();

            const gameId = game._id.toString();
            socket.join(gameId);
            io.to(gameId).emit('updateGame', game);
        } catch (e) {
            console.log(e);
        }
    });

    socket.on("join-game", async ({ nickname, gameId }) => {
        try {
            if (!gameId.match(/^[0-9a-fA-F]{24}$/)) {
                socket.emit("notCorrectGame", "Please enter a valid game ID");
                return;
            }
            let game = await Game.findById(gameId);

            if (game.isJoin) {
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
                    "The game is in progress, please try again later!"
                );
            }
        } catch (e) {
            console.log(e);
        }
    });

    socket.on('sendWord', async ({ gameId, word }) => {
        try {
            console.log(`Received word: ${word}`);
            if (word.length !== 5) {
                socket.emit('invalidWord', 'The word must be exactly 5 letters long.');
                return;
            }
    
            let game = await Game.findById(gameId);

            let player = game.players.find(player => player.socketID === socket.id);
            if (player) {
                player.word = word; 
                game = await game.save();

                if (game.players.every(player => player.word)) {
                    const [player1, player2] = game.players;
                    io.to(player1.socketID).emit('receiveWord', player2.word);
                    io.to(player2.socketID).emit('receiveWord', player1.word);

                    startGameClock(gameId);
                }
            }
        } catch (e) {
            console.log(e);
        }
    });

    socket.on('stopTimer', async () => {
        try {
            let game = await Game.findOne({ 'players.socketID': socket.id });
            if (game) {
                let player = game.players.find(player => player.socketID === socket.id);
                if (player) {
                    player.finished = true;
                    await game.save();
                    await checkGameResult(game._id.toString());
                }
            }
        } catch (e) {
            console.log(e);
        }
    });

    const startGameClock = async (gameID) => {
        let game = await Game.findById(gameID);
        game.startTime = new Date().getTime();
        game = await game.save();
    
        let time = 0;
    
        let timerId = setInterval(callback
            (async function gameIntervalFunc(callback) {
                game = await Game.findById(gameID); // Fetch the latest game state
                if (!game.isOver) {
                    const timeFormat = calculateTime(time);
                    io.to(gameID).emit("timer", {
                        countDown: timeFormat,
                        msg: "Time",
                    });
                    console.log(time);
                    time++;
                } else {
                    clearInterval(timerId);
                    let endTime = new Date().getTime();
                    let elapsedTime = endTime - game.startTime;
                    console.log(`Elapsed time: ${elapsedTime} ms`);
                    io.to(gameID).emit("gameOver", { elapsedTime });
                }
                return gameIntervalFunc;
            })(),
            1000
        );
    };

    const calculateTime = (time) => {
        let min = Math.floor(time / 60);
        let sec = time % 60;
        return `${min}:${sec < 10 ? "0" + sec : sec}`;
    };

    const checkGameResult = async (gameId) => {
        let game = await Game.findById(gameId);
        if (game.players.every(player => player.finished)) {
            game.isOver = true;
            await game.save();

            let playerTimes = game.players.map(player => ({
                nickname: player.nickname,
                time: player.finishedTime
            }));
            io.to(gameId).emit("gameResult", playerTimes);
        }
    };

    socket.on("timer", async ({ playerId, gameID }) => {
        let countDown = 5;
        let game = await Game.findById(gameID);
        let player = game.players.id(playerId);

        if (player.isPartyLeader) {
            let timerId = setInterval(async () => {
                if (countDown >= 0) {
                    io.to(gameID).emit("timer", {
                        countDown,
                        msg: "Game Starting",
                    });
                    console.log(countDown);
                    countDown--;
                } else {
                    game.isJoin = false;
                    game = await game.save();
                    io.to(gameID).emit("updateGame", game);
                    startGameClock(gameID);
                    clearInterval(timerId);
                }
            }, 1000);
        }
    });
    
    const checkWinCondition = (word, guesses) => {
        for (let char of word) {
            if (!guesses.includes(char)) {
                return false;
            }
        }
        return true;
    };
});

mongoose.connect(DB).then(() => {
    console.log("connection successful");
}).catch((e) => {
    console.log(e);
});

server.listen(port, "0.0.0.0", () => {
    console.log(`Server started and running on port ${port}`);
});
