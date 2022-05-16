#!/bin/bash

cd circuits

mkdir CompareTest

if [ -f ./powersOfTau28_hez_final_17.ptau ]; then
    echo "powersOfTau28_hez_final_17.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_17.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_17.ptau
fi

echo "Compiling CompareTest.circom..."

# compile circuit

circom CompareTest.circom --r1cs --wasm --sym -o CompareTest
snarkjs r1cs info CompareTest/CompareTest.r1cs

# Start a new zkey and make a contribution

snarkjs plonk setup CompareTest/CompareTest.r1cs powersOfTau28_hez_final_17.ptau CompareTest/circuit_final.zkey

# generate solidity contract
snarkjs zkey export solidityverifier CompareTest/circuit_final.zkey ../CompareTestVerifier.sol

cd ..