pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/poseidon.circom";
include "../node_modules/circomlib/circuits/pedersen.circom";
include "../node_modules/circomlib/circuits/mimc.circom";
include "../node_modules/circomlib/circuits/sha256/sha256.circom";

template testPoseidon(n) {
  signal input in[n];
  signal output out;

  component poseidon = Poseidon(n);

  for(var i = 0; i < n ; i++) {
    poseidon.inputs[i] <== in[i];
  }

  out <== poseidon.out;
}

template testPedersen(n) {
  signal input in[n];
  signal output out;

  component pedersen = Pedersen(n);

  for(var i = 0; i < n ; i++) {
    pedersen.in[i] <== in[i];
  }

  out <== pedersen.out[0];
}

template testMimc(n) {
  signal input in[n];
  signal input k;
  signal output out;

  component mimc = MultiMiMC7(n, 1);

  mimc.k <== k;

  for(var i = 0; i < n ; i++) {
    mimc.in[i] <== in[i];
  }

  out <== mimc.out;
}

template testSha256(nBits) {
  signal input in[nBits];
  signal output out[256];

  component sha256 = Sha256(nBits);

  for(var i = 0; i < nBits ; i++) {
    sha256.in[i] <== in[i];
  }

  for(var j = 0; j < 256; j++) {
    out[j] <== sha256.out[j];
  }
}

component main = testSha256(1);