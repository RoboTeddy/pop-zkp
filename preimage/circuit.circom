include "../../circomlib/circuits/poseidon.circom"

template Hasher(n) {
  signal private input xs[n];
  signal output out;

  component p = Poseidon(n);

  // TODO: replace with a `for` loop
  p.inputs[0] <== xs[0]
  p.inputs[1] <== xs[1]

  out <== p.out
}

component main = Hasher(2);