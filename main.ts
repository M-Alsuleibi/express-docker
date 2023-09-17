import "dotenv/config";
import express from "express";
import "reflect-metadata";
import { UsersController } from "./src/users/controller.js";

const app = express();

app.use(express.json())

app.get("/", (req, res) => {
	res.json({ msg: "Hello from express" })
})

app.use("/users", UsersController)

const port = process.env.PORT || 3000;
const server = app.listen(port, () => {
	console.log(`Starting A new server on port ${port}`)
})

process.on("SIGHUP", () => {
	server.close()
})
