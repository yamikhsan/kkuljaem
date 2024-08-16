const express = require("express");
const app = express();

function isPrime(num) {
  for (let i = 2, s = Math.sqrt(num); i <= s; i++) {
    if (num % i === 0) return false;
  }
  return num > 1;
}

function fibonacci(n) {
  if (n === 0) return 0;
  if (n === 1) return 1;

  let a = 0;
  let b = 1;
  for (let i = 2; i <= n; i++) {
    let temp = a + b;
    a = b;
    b = temp;
  }
  return b;
}

app.get("/catch_pokemon", (req, res) => {
  const random = Math.random();
  const success = random < 0.5;

  res.json({
    catch: success,
  });
});

app.get("/release_pokemon", (req, res) => {
  const num = Math.floor(Math.random() * 100) + 1;
  const prime = isPrime(num);
  res.json({
    isPrime: prime,
    number: num,
  });
});

app.get("/rename_pokemon", (req, res) => {
  const name = req.query.name || "";
  const count = parseInt(req.query.count) || 0;

  const fib = fibonacci(count);

  const rename = `${name}-${fib}`;

  res.json({
    rename: rename,
    count: count + 1,
  });
});

const port = 3000;
app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});
