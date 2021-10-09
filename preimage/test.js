const path = require("path")
const tester = require("circom").tester;
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


const preimage = 123456
const input = {
  privateKey: S,
  x: preimage,
};

let x = preimage;
for (let i = 0; i < 32; i++) {
  x = poseidon([x, 0])
  console.log(i, x)
}


/*
async function main() {
  const circuit = await tester(path.join(__dirname, "circuit.circom"))

  const start = Date.now()
  const witness = await circuit.calculateWitness(input, true);
  console.log("witness", witness)


  const stop = Date.now()
  console.log("Time", stop - start)
  await circuit.assertOut(witness, {
    merkleRoot: 20316867844455062873308906955804935458737524164102552604878669177666010571765n,
    pubKeyAx: A[0],
    pubKeyAy: A[1],
  });
  await circuit.checkConstraints(witness);
}



main().then(() => console.log('Done'))
*/


