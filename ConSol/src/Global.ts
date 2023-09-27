/* eslint no-var: 0 */
declare global {
  // We use a global mutable variable to generate unique address spec id.
  // The id is assigned to address specs in the `where` clause.
  var addrSpecId: number;
}

export function resetAddrSpecId(): void {
  globalThis.addrSpecId = 0;
}

export function nextAddrSpecId(): number {
  const n = globalThis.addrSpecId;
  globalThis.addrSpecId += 1;
  return n;
}
