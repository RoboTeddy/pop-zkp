include "../../circomlib/circuits/babyjub.circom"
include "../../circomlib/circuits/bitify.circom"
include "../../circomlib/circuits/poseidon.circom"
include "../../circomlib/circuits/switcher.circom"

// doesn't truly check a merkle path — just simulates the workload
template MerkleProofCheckBenchmark(levels) {
  signal private input preimage;
  signal private input digests[levels];
  signal private input directions[levels];
  signal output out;

  component poseidons[levels];
  component switchers[levels]
  
  // create circuit components
  for (var i = 0; i < levels; i++) {
    poseidons[i] = Poseidon(2); // two 32-byte inputs
    switchers[i] = Switcher();
  }

  for (var i = 0; i < levels; i++) {
    if (i == 0) {
      // input signal
      switchers[i].L <== preimage 
    }
    else {
      // signal from previous layer
      switchers[i].L <== poseidons[i-1].out; 
    }
    switchers[i].R <== digests[i];
    switchers[i].sel <== directions[i];

    poseidons[i].inputs[0] <== switchers[i].outL
    poseidons[i].inputs[1] <== switchers[i].outR
  }

  out <== poseidons[levels - 1].out
}

template Main(levels) {
  signal private input preimage;
  signal private input digests[levels];
  signal private input packedDirections;

  signal private input privateKey;
  signal private input pubKeyAx;
  signal private input pubKeyAy;
  
  signal output merkleRoot;


  component directionsBits = Num2Bits(levels);
  directionsBits.in <== packedDirections;

  // simulating a merkle tree with 32 levels to allow for ~ all humans
  component merkleProofCheckBenchmark = MerkleProofCheckBenchmark(levels)
  merkleProofCheckBenchmark.preimage <== preimage;
  for (var i = 0; i < levels; i++) {
    merkleProofCheckBenchmark.digests[i] <== digests[i];
    merkleProofCheckBenchmark.directions[i] <== directionsBits.out[i];
  }
  merkleRoot <== merkleProofCheckBenchmark.out

  // Ensure user owns key
  component babyPdk = BabyPbk()
  babyPdk.in <== privateKey
  babyPdk.Ax === pubKeyAx
  babyPdk.Ay === pubKeyAy
}

// allow smaller circuit size during dev
component main = Main(32);
