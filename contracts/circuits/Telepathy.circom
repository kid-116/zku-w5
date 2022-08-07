pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";
include "../../node_modules/circomlib/circuits/bitify.circom";
include "../../node_modules/circomlib/circuits/poseidon.circom";
include "./RangeProof.circom";

/*
    Let us assume that the board is a 5x5 one
    having a maximum of 10 different symbols colored in no more than 5 colors 
*/
template Telepathy() {
    signal input pubGuessRow;
    signal input pubGuessColumn;
    signal input pubGuessColor;
    signal input pubGuessSymbol;
    signal input pubResponse;
    signal input pubSolnHash;

    signal input privSolnRow;
    signal input privSolnColumn;
    signal input privSolnColor;
    signal input privSolnSymbol;
    signal input privSalt;

    signal output solnHashOut;

    signal NUM_ROWS <== 5;
    signal NUM_COLUMNS <== 5;
    signal NUM_COLORS <== 5;
    signal NUM_SYMBOLS <== 10;

    // Create constraints around feature range
    component privRowInRange = RangeProof(32);
    privRowInRange.range[0] <== 1;
    privRowInRange.range[1] <== NUM_ROWS;
    privRowInRange.in <== privSolnRow;
    privRowInRange.out === 1;

    component privColumnInRange = RangeProof(32);
    privColumnInRange.range[0] <== 1;
    privColumnInRange.range[1] <== NUM_COLUMNS;
    privColumnInRange.in <== privSolnColumn;
    privColumnInRange.out === 1;

    component privColorInRange = RangeProof(32);
    privColorInRange.range[0] <== 1;
    privColorInRange.range[1] <== NUM_COLORS;
    privColorInRange.in <== privSolnColor;
    privColorInRange.out === 1;

    component privSymbolInRange = RangeProof(32);
    privSymbolInRange.range[0] <== 1;
    privSymbolInRange.range[1] <== NUM_SYMBOLS;
    privSymbolInRange.in <== privSolnSymbol;
    privSymbolInRange.out === 1;

    // Verify that the hash of the private solution matches pubSolnHash
    component poseidon = Poseidon(4 + 1);
    poseidon.inputs[0] <== privSalt;
    poseidon.inputs[1] <== privSolnRow;
    poseidon.inputs[2] <== privSolnColumn;
    poseidon.inputs[3] <== privSolnSymbol;
    poseidon.inputs[4] <== privSolnColor;
    solnHashOut <== poseidon.out;
    pubSolnHash === solnHashOut;
    
    // Find number of correct guesses
    var correctGuesses = 0;

    component columnIsEqual = IsEqual();
    columnIsEqual.in[0] <== pubGuessColumn;
    columnIsEqual.in[1] <== privSolnColumn;
    correctGuesses += columnIsEqual.out;

    component rowIsEqual = IsEqual();
    rowIsEqual.in[0] <== pubGuessRow;
    rowIsEqual.in[1] <== privSolnRow;
    correctGuesses += rowIsEqual.out;
    
    component colorIsEqual = IsEqual();
    colorIsEqual.in[0] <== pubGuessColor;
    colorIsEqual.in[1] <== privSolnColor;
    correctGuesses += colorIsEqual.out;

    component symbolIsEqual = IsEqual();
    symbolIsEqual.in[0] <== pubGuessSymbol;
    symbolIsEqual.in[1] <== privSolnSymbol;
    correctGuesses += symbolIsEqual.out;

    // Create constraint around correct response
    component responseIsZero = IsEqual();
    responseIsZero.in[0] <== 0;
    responseIsZero.in[1] <== pubResponse;

    component correctGuessesIsZero = IsEqual();
    correctGuessesIsZero.in[0] <== 0;
    correctGuessesIsZero.in[1] <== correctGuesses;

    correctGuessesIsZero.out === responseIsZero.out;
}

component main = Telepathy();
