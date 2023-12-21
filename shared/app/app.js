const express = require("express");
const app = express();

console.log(`===> node server started`);

app.get("/", (req, res) => {
  res.send(process.argv[2] || "Hello from NodeJs!");
});

app.get("/egress", async (req, res) => {
  const response = await fetch(
    "https://jsonplaceholder.typicode.com/todos/1"
  ).catch((error) => console.log(`===> json fetch error`, error));
  console.log(`===> json fetch response`, response);
  // process response and get json data
  const data = await response.json();
  console.log(`===> json fetch data`, data);

  res.send(data);
});

const port = 80;
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});