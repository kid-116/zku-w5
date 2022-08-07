const { ethers } = require('hardhat');
const wasm_tester = require('circom_tester').wasm;
const F1Field = require('ffjavascript').F1Field;
const Scalar = require('ffjavascript').Scalar;
const buildPoseidon = require("circomlibjs").buildPoseidon;

exports.p = Scalar.fromString('21888242871839275222246405745257275088548364400416034343698204186575808495617');
const Fr = new F1Field(exports.p);

const CIRCUIT = 'Telepathy'

describe(CIRCUIT, function () {
    this.timeout(100000000);
    
    let Verifier;
    let verifier;
    let input;
    let circuit;
    let poseidonJs;

    beforeEach(async function () {
        Verifier = await ethers.getContractFactory('Verifier');
        verifier = await Verifier.deploy();
        await verifier.deployed();

        circuit = await wasm_tester(`contracts/circuits/${CIRCUIT}.circom`);

        const SALT = 3141592653;
        input = {
            'pubGuessRow': 1,
            'pubGuessColumn': 1,
            'pubGuessColor': 1,
            'pubGuessSymbol': 1,
            'pubResponse': null,
            'pubSolnHash': null,
            'privSolnRow': 1,
            'privSolnColumn': 1,
            'privSolnColor': 1,
            'privSolnSymbol': 1,
            'privSalt': SALT
        }

        poseidonJs = await buildPoseidon();
    });

    function calcSolnHash(input) {
        return ethers.BigNumber.from(poseidonJs.F.toObject(poseidonJs([
            input['privSalt'],
            input['privSolnRow'],
            input['privSolnColumn'],
            input['privSolnSymbol'],
            input['privSolnColor']
        ])));
    }

    it("Should run without errors on correct input", async function () {
        input['pubResponse'] = 1;
        input['pubSolnHash'] = calcSolnHash(input);

        await circuit.calculateWitness(input, true);
    });

    // TODO: Add more tests
});
