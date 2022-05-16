//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import { PoseidonT3 } from "./Poseidon.sol"; //an existing library to perform Poseidon hash on solidity
import "./verifier.sol"; //inherits with the MerkleTreeInclusionProof verifier contract

contract MerkleTree is Verifier {
    uint256[] public hashes; // the Merkle tree in flattened array form
    uint256 public index = 0; // the current index of the first unfilled leaf
    uint256 public root; // the current Merkle root

    constructor() {
        // [assignment] initialize a Merkle tree of 8 with blank leaves
        uint256 zero = 0;
        uint256 leavesNumber = 8;

        for(uint i = 0; i < leavesNumber; i++) {
            hashes.push(zero);
        }

        // n levels mercletree has 2**n - 1 nodes excluding leaves
        uint256 nodesNumberExcludingLeaves = 2**3 - 1;

        for(uint256 j = 0; j < (leavesNumber + nodesNumberExcludingLeaves) / 2; j++) {
            uint256[2] memory input=[hashes[2 * j], hashes[2 * j + 1]];
            uint256 node = PoseidonT3.poseidon(input);
            hashes.push(node);
        }

        root = hashes[hashes.length - 1];
    }

    function insertLeaf(uint256 hashedLeaf) public returns (uint256) {
        // [assignment] insert a hashed leaf into the Merkle tree
        uint256 leavesNumber = 8;

        // insert a hashed leaf into the Merkle tree
        hashes[index] = hashedLeaf;

        // n levels mercletree has 2**n - 1 nodes excluding leaves
        uint256 nodesNumberExcludingLeaves = 2**3 - 1;

        for(uint256 j = 0; j < (leavesNumber + nodesNumberExcludingLeaves) / 2; j++) {
            uint256[2] memory input=[hashes[2 * j], hashes[2 * j + 1]];
            uint256 node = PoseidonT3.poseidon(input);
            hashes[leavesNumber + j] = node;
        }

        index++;
        root = hashes[hashes.length - 1];

        return root;
    }

    function verify(
            uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c,
            uint[1] memory input
        ) public view returns (bool) {

        // [assignment] verify an inclusion proof and check that the proof root matches current root
        bool verifyProofResult = Verifier.verifyProof(a, b, c, input);
        if(verifyProofResult == true) {
            if(input[0] == root) {
                return true;
            }
            return false;
        } else {
            return false;
        }

    }
}
