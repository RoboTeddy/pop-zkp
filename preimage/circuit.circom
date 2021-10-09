include "../../circomlib/circuits/poseidon.circom"
include "../../circomlib/circuits/babyjub.circom"

// TODO:
// [ ] take input signal that describes the merkle path (0=left, 1=right)
// [ ] take inputs that describe the other branchs of the merkle tree
// [x] check a baby jubjub keypair

template IteratedHasher(numInputs, levels) {
  signal private input xs[numInputs];
  signal output out;

  // array of hash components
  component poseidons[levels];

  // create all the circuit components
  for (var i = 0; i < levels; i++) {
    poseidons[i] = Poseidon(numInputs);
  }

  // hook in input signals
  poseidons[0].inputs[0] <== xs[0]
  poseidons[0].inputs[1] <== xs[1]

  // hook intermediary hashes together
  for (var i = 1; i < levels; i++) {
    poseidons[i].inputs[0] <== poseidons[i-1].out
    poseidons[i].inputs[1] <== 0
  }

  out <== poseidons[levels-1].out
}

template Main() {
  signal private input preimage;

  signal private input privateKey;
  signal private input pubKeyAx;
  signal private input pubKeyAy;
  
  signal output merkleRoot;

  // poseidon was designed with two 32-byte inputs in mind,
  // in order to allow for merkle trees with a branching factor of 2
  // simulating a merkle tree with 32 levels to allow for ~ all humans

  component iteratedHasher = IteratedHasher(2, 32)

  // shorter dev loop cause can use smaller circuit
  //component iteratedHasher = IteratedHasher(2, 3)

  iteratedHasher.xs[0] <== preimage;
  iteratedHasher.xs[1] <== 0;
  merkleRoot <== iteratedHasher.out

  // Ensure user owns key
  component babyPdk = BabyPbk()
  babyPdk.in <== privateKey
  babyPdk.Ax === pubKeyAx
  babyPdk.Ay === pubKeyAy
}

component main = Main();
