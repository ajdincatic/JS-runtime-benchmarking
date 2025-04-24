const express = require("express");
const app = express();
const PORT = 3000;

app.get("/ping", (req, res) => {
  res.json({ status: "ok", message: "pong" });
});

app.get("/compute", (req, res) => {
  let total = 0;
  for (let i = 0; i < 1e7; i++) {
    total += i;
  }
  res.json({ status: "ok", result: total });
});

app.get("/memory", (req, res) => {
  const largeArray = new Array(1e6).fill("x");
  res.json({ status: "ok", message: "memory allocated", size: largeArray.length });
});

app.get("/bulk", (req, res) => {
  res.json({ status: "ok", message: "bulk request test" });
});

app.listen(PORT, () => {
  console.log(`Node.js server listening on port ${PORT}`);
});