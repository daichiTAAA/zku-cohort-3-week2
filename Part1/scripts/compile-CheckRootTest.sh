#!/bin/bash

cd circuits

mkdir CheckRootTest

if [ -f ./powersOfTau28_hez_final_14.ptau ]; then
    echo "powersOfTau28_hez_final_14.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_14.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_14.ptau
fi

echo "Compiling CheckRootTest.circom..."

# compile circuit

circom CheckRootTest.circom --r1cs --wasm --sym -o CheckRootTest
snarkjs r1cs info CheckRootTest/CheckRootTest.r1cs

# Start a new zkey and make a contribution

snarkjs plonk setup CheckRootTest/CheckRootTest.r1cs powersOfTau28_hez_final_14.ptau CheckRootTest/circuit_final.zkey

# generate solidity contract
snarkjs zkey export solidityverifier CheckRootTest/circuit_final.zkey ../CheckRootTestVerifier.sol

cd ..