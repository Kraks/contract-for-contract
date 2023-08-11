# Benchmark program for case studies

This folder contains 10 sets of benchmark programs, compiled bytecode, and transaction data collected from real-world attacks. These programs are used in the case studies (Section 6, Table 1) and in the evaluation of gas efficiency (Section 7, Table 2).

## Description

Table 1 in the paper lists all cases we studied. Their correspondence to this folder is listed below:

- Umbrella - `integer-overflow-Umbrella-700K`
- EFLeverVault - `unchecked-flashloan-callback-EFLeverVault-1M`
- Nood - `reentrancy-N00d-29K`
- Dexible - `arbitrary-external-call-dexible-1.5M`
- SushiSwap - `unchecked-user-input-SushiSwap-3.3M`
- SwaposV2 - `erroneous-accounting-SwaposV2-468K`
- Unknown - `missing-slippage-check-UnknownVictim-111K`
- Sturdy - `read-only-reentrancy-sturdy-800K`
- LEVUSDC - `access-control-LEVUSDC-105K`
- Bao - `inflation-manipulate-BaoCommunity-46K`

For each case, there are

- raw experiment data (`data`) and summary of the data (`data/log.txt`),
- the original smart contract program, ConSol-annotated program, ConSol-transpiled program, and manually fixed program using low-level assertions (`code`, all in Solidity),
- and compiled bytecode corresponding to the Solidity source code.
