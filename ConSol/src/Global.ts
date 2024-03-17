import { ContractDefinition, SourceUnit, StructDefinition } from 'solc-typed-ast';

/* eslint no-var: 0 */
declare global {
  // We use a global mutable variable to generate unique address spec id.
  // The id is assigned to address specs in the `where` clause.
  var addrSpecId: number;
  var structMap: Map<string, StructDefinition>;
  var csVarId: number;
  var sourceUnits: Array<SourceUnit>;
}

export function setSourceUnits(units: Array<SourceUnit>): void {
  globalThis.sourceUnits = units;
}

export function findContract(name: string): ContractDefinition | undefined {
  // XXX: assume there is only one source unit
  return globalThis.sourceUnits[0].vContracts.find((contract) => contract.name === name);
}

export function resetAddrSpecId(): void {
  globalThis.addrSpecId = 0;
}

export function nextAddrSpecId(): number {
  const n = globalThis.addrSpecId;
  globalThis.addrSpecId += 1;
  return n;
}

export function resetStructMap(): void {
  globalThis.structMap = new Map<string, StructDefinition>();
}

export function resetCSVarId(): void {
  globalThis.csVarId = 0;
}

export function freshName(): string {
  const n = globalThis.csVarId;
  globalThis.csVarId += 1;
  return '_cs_' + n;
}
