pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/poseidon.circom";
include "../node_modules/circomlib/circuits/mux1.circom";

template CheckRoot(n) { // compute the root of a MerkleTree of n Levels 
    signal input leaves[2**n];
    signal output root;

    //[assignment] insert your code here to calculate the Merkle root from 2^n leaves

    component poseidon[2**(n-1)];

    for(var l = 0; l < 2**(n-1); l++) {
        poseidon[l] = Poseidon(2);
    }

    var i;
    var totalLeavesNumber = 2**n;

    for(i = 0; i < totalLeavesNumber / 2; i++) {
        poseidon[i].inputs[0] <== leaves[i * 2];
        poseidon[i].inputs[1] <== leaves[i * 2 + 1];
    }

    var totalHashNumber = 2 ** n - 1;

    var k = 0;

    for(i = totalLeavesNumber; i < totalHashNumber; i++) {
        poseidon[i].inputs[0] <== poseidon[k].out;
        poseidon[i].inputs[1] <== poseidon[k + 1].out;
        k++;
    }

    root <== poseidon[k].out;
}

template MerkleTreeInclusionProof(n) {
    signal input leaf;
    signal input path_elements[n];
    signal input path_index[n]; // path index are 0's and 1's indicating whether the current element is on the left or right
    signal output root; // note that this is an OUTPUT signal

    //[assignment] insert your code here to compute the root from a leaf and elements along the path

    component mux[n];
    component poseidon[n];
    for(var j = 0; j < n; j++) {
        mux[j] = MultiMux1(2);
        poseidon[j] = Poseidon(2);
    }
    var i = 0;
    var k = 0;
    mux[i].c[0][0] <== leaf;
    mux[i].c[0][1] <== path_elements[i];
    mux[i].c[1][0] <== path_elements[i];
    mux[i].c[1][1] <== leaf;
    mux[i].s <== path_index[i];
    poseidon[k].inputs[0] <== mux[i].out[0];
    poseidon[k].inputs[1] <== mux[i].out[1];
    for(i = 1; i < n; i++) {
        mux[i].c[0][0] <== poseidon[k].out;
        mux[i].c[0][1] <== path_elements[i];
        mux[i].c[1][0] <== path_elements[i];
        mux[i].c[1][1] <== poseidon[k].out;
        k++;
        mux[i].s <== path_index[i];
        poseidon[k].inputs[0] <== mux[i].out[0];
        poseidon[k].inputs[1] <== mux[i].out[1];
    }
    root <== poseidon[k].out;
}