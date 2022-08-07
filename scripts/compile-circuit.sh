#!/bin/bash

cd contracts/circuits

# Trusted setup
export POWER=10
if [ -f ./powersOfTau28_hez_final_${POWER}.ptau ]; then
    echo "powersOfTau28_hez_final_${POWER}.ptau already exists. Skipping."
else
    echo "Downloading powersOfTau28_hez_final_${POWER}.ptau"
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_${POWER}.ptau
fi

export CIRCUIT='Telepathy'

echo "Compiling ${CIRCUIT}.circom..."

# Compile circuit
circom ${CIRCUIT}.circom --r1cs --wasm --sym -o .
snarkjs r1cs info ${CIRCUIT}.r1cs

# Start a new zkey and make a contribution
snarkjs groth16 setup ${CIRCUIT}.r1cs powersOfTau28_hez_final_${POWER}.ptau circuit_0000.zkey
snarkjs zkey contribute circuit_0000.zkey circuit_final.zkey --name='kid-116' -v -e='random'
snarkjs zkey export verificationkey circuit_final.zkey verification_key.json

# Generate solidity contract
snarkjs zkey export solidityverifier circuit_final.zkey ../verifier.sol

cd ../..
