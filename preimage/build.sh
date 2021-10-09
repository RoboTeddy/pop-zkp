npx circom circuit.circom --r1cs --wasm --sym && \

# not necessary, just interesting to look at
# npx snarkjs r1cs export json circuit.r1cs circuit.r1cs.json

# Smaller (2^12)
# npx snarkjs powersoftau prepare phase2 ../pot12_0001.ptau pot12_final.ptau -v && \
# npx snarkjs zkey new circuit.r1cs pot12_final.ptau circuit_0000.zkey && \

# Larger (2^14)
npx snarkjs powersoftau prepare phase2 ../pot14_0001.ptau pot14_final.ptau -v && \
npx snarkjs zkey new circuit.r1cs pot14_final.ptau circuit_0000.zkey && \

npx snarkjs zkey contribute circuit_0000.zkey circuit_final.zkey --name="1st Contributor Name" -v && \
npx snarkjs zkey export verificationkey circuit_final.zkey verification_key.json 
