const poseidon = require("circomlib/src/poseidon");

let x = 123456

for (let i = 0; i < 32; i++) {
  x = poseidon([x, 0])
  console.log(i, x)
}
