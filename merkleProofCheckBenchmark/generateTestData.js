const path = require("path")
const poseidon = require("circomlib/src/poseidon");
const utils = require("ffjavascript").utils;
const Scalar = require("ffjavascript").Scalar;

// stolen from circom's babyjub.js test
const createBlakeHash = require("blake-hash");
const eddsa = require("circomlib/src/eddsa.js");
const F = require("circomlib/src/babyjub.js").F;

const rawpvk = Buffer.from("0001020304050607080900010203040506070809000102030405060708090021", "hex");
const pvk = eddsa.pruneBuffer(createBlakeHash("blake512").update(rawpvk).digest().slice(0,32));
const S = Scalar.shr(utils.leBuff2int(pvk), 3);

const A = eddsa.prv2pub(rawpvk);
// end stolen

console.log("S", S); // private key
console.log("A", A); // public key

let x = 123456;
for (let i = 0; i < 32; i++) {
  x = poseidon([x, 0])
  console.log(i, x)
}
