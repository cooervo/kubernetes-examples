const express = require("express");

const app = express();
app.get("/", (req, res) => {
  res.send("Hello World!!");
});
const HOST = "0.0.0.0";
const PORT = 3300;
app.listen(PORT, HOST, () => {
  console.log(`Running on http://${HOST}:${PORT}`);
});
