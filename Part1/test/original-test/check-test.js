const { groth16, plonk } = require('snarkjs');

async function CheckRootTest() {
  const { proof, publicSignals } = await plonk.fullProve(
    { leaves: [1, 2, 3, 4, 5, 6, 7, 8] },
    '../circuits/CheckRootTest/CheckRootTest_js/CheckRootTest.wasm',
    '../circuits/CheckRootTest/circuit_final.zkey'
  );
  console.log(
    'input leaves = [1, 2, 3, 4, 5, 6, 7, 8], and then output is: ',
    publicSignals
  );
  return;
}

async function MerkleTreeInclusionProofTest() {
  const { proof, publicSignals } = await groth16.fullProve(
    {
      leaf: '1',
      path_elements: ['2', '3', '4'],
      path_index: ['0', '0', '0'],
    },
    '../circuits/circuit_js/circuit.wasm',
    '../circuits/circuit_final.zkey'
  );
  console.log(
    `input leaves =
    {
      leaf: '1',
      path_elements: ['2', '3', '4'],
      path_index: ['0', '0', '0'],
    }, and then output is: `,
    publicSignals
  );
  return;
}

// CheckRootTest();
MerkleTreeInclusionProofTest();
