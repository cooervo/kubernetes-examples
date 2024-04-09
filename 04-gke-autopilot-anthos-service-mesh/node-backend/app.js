const express = require("express");
const app = express();
const port = 3000;

console.log(`===> node running`);

app.get("/", (req, res) => {
  res.send("Hello from Node.js!");
});

app.listen(port, () => {
  console.log(`===> Node js Server is running on port ${port}`);
});
