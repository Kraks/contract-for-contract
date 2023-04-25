## Core Syntax

```
flat-contract ::= { x | e }

before, after ::= ts @ f(arg_1, ...) returns r

spec ::=
  | dom ... -> range                -- function contracts
  | before => after /\ side-cond    -- pos temporal contracts
  | before =/> after /\ side-cond   -- neg temporal contracts
  | before ~> after /\ side-cond    -- pos contextual contracts
  | before ~/> after /\ side-cond   -- neg contextual contracts
```

`dom`, `range` can be arbitrary expressions that evaluate to either
- a flat contract (a function returning boolean values), or
- a function contract (first-class)
- an address contract (second-class)

We write `_` for a wildcard variable, indicating we don't care that variable name.

## Flat Contracts

Specifying the pre-condition and post-condition, where the post-condition
can depend on the argument value:

```
# {x | x > 0}
# {y | y > x + 1}
function f(uint x) returns y { ... }
```
It is also equivalent to core syntax:
```
# {x | x > 0} -> {y | y > x + 1}
```

We can omit any part of the argument or return value contracts:

```
# {x | x > 0}
function f(uint x) returns y { ... }
```
It is equivalent to core syntax where the omitted part is simply `true`:
```
# {x | x > 0} -> {y | true}
```
Another way is to use the `any` flat contract, which is defined as `any = { _ | true }`:
```
# {x | x > 0} -> any
```

For multi-argument functions, we use multiple `->` to compose larger function
contracts:
```
# {x | x > 0} -> {y | y < 100} -> {z | z == x + y }
function f(int x, int y) returns int { returns x + y; }
```
Or, we could write a single flat contract for the argument introducing
multiple argument binders:
```
# { (x, y) | x > 0 && y < 100 } -> {z | z == x + y }
function f(int x, int y) returns int { returns x + y; }
```

### Special Variables

When specifying the spec of functions, two special variables are available
`msg.sender` the address of the caller and `block.timestamp` the current
block timestamp.

```
# { msg.sender ... }
NEED AN EXAMPLE USING THEM
```

## Contracts for First-class Functions

We can specify the contract for function arguments too:
```
# { f | {x | x < 0} -> {y | y > 0} }
function map(int[] memory data, function (int) pure returns (int) f) { ... }
```
It might be too verbose -- so we can define those predicates separately for better readability/maintainability:
```
function greaterThanZero(int x) returns (bool) {
  return x > 0;
}
function smallerThanZero(int x) returns (bool) {
  return x < 0;
}
# { f | smallerThanZero -> greaterThanZero }
function map(int[] memory data, function (int) pure returns (int) f) { ... }
```

Functions contracts can be higher-order -- it can take other function contracts
as part of the spec. For example
```
# TODO
function f(function (function (int) returns (int) g) h) { ... }
```

Function contracts are first-class -- so if this guarded function is escaped (e.g. by returning), the contract is still enforced:
```
NEED AN EXAMPLE
```

## Address Contracts

Address contracts share similar syntax as function contracts, but introduces additionally more binders for the arguments and returned values:

```
# { a | { {value, gas, ...} | <pre-cond-value-gas> }
     -> { arg | <pre-cond-arg> }
     -> { (res, data) | <post-cond> } }
function f(address a) {
  (bool success, bytes memory data) = a.call{value: ...}(arg);
}
```

It would be convenient to directly enforces the success of the call and omit
the data:
```
# { a | { {value, gas}(arg) | <pre-cond> } -> { (true, _) | true } }
function f(address a) { ... }
```

### Control-Flow Integrity

TODO

### Limitations

Address contracts are **not** higher-order -- if an address takes another address
as argument, then we cannot enforce the contract of the argument address.
For example, in the following case, `b` itself has an "address contract"
`<b-pre> -> <b-post>` but there is no general way to enforce that.
Because we do not have the control of the actual callee function of `a`,
therefore no way to modify the code of `a` to check the pre-condition
and post-condition when `b` is called in `a`.

```
# { a | { b | <b-pre> -> <b-post> } -> { (true, _) | true } }
function f(address a) {
  address b = ...
  (bool success, bytes memory data) = a.call(b);
}
```

Address contracts are **second-class** -- we can only enforce the pre-condition
and post-condition of addresses within the current calling context.
If the address escapes (e.g. by returning, or stored in a global variable),
we cannot enforce the contract anymore.

Why? Because in general we do not have the ability to insert checks around the
computation of that address. We can indeed create a new contract (and a new address) that wraps the old address call with checks, but then calling
the new address will not exhibit the same behavior as calling the old address
for the caller.

For example, the following identity function of addresses has a spec
for the argument address. But the body of function does not invoke
the address, instead, it directly returns `a` to the caller.
Once address `a` escapes, we cannot enforce the condition anymore.

```
# { a | { {value, gas}(arg) | <pre-cond> } -> { (res, data) | <post-cond> } }
function f(address a) returns address { return a }
```

## Temporal Contracts

Temporal contracts relate two function calls (events) and enforces there
relation.
They can inspect the time-stamps, message sender, arguments, return values
of the two function calls.

TODO: where to add message sender?
```
# ts1 @ f(x) returns z from sdr1 => ts2 @ g(a) returns c from sdr2
```

### Positive temporal properties

Positive temporal properties enforces that an event must happen
after another event.

```
# ts1 @ f(x) returns z => ts2 @ g(a) returns c /\ side-cond
```

- when invoke `g`, check `f` has invoked **and** `side-cond` is true
- ~~after invoke `f`, enforce `g` will be invoked eventually~~

Side condition can be arbitrary expressions that uses the time-stamps, message
sender, arguments, return values of the two function calls.
For example, the following spec passes arguments of `f` and `g` into
another function for checking:

```
# ts1 @ f(x) returns z => ts2 @ g(a) returns c /\ check(x, a)
```

If a variable occurs in both events, an additional equality constraint
is synthesized.  For example,
```
# ts1 @ f(x) returns z => ts1 @ g(z) returns c
```
requires that both function `f` and `g` happen in the same transaction,
and the return value of `f` is the same as the argument of `g`.
It will be translated to the core syntax as the following:
```
# ts1 @ f(x) returns z => ts2 @ g(y) returns c /\ ts1 == ts2 && x == y
```

It is totally fine to omit the time-stamp, arguments, or return values.
Simply requiring `f` happens before `g`:
```
# f => g
function f(...) { ... }
```

Note: `f => g` matches the most recent call of `f`, or any prior call of `f` (if
there are multiple calls of `f`)?

Note: need to think about interactions with compiler optimization (eg inlining).

### Negative temporal properties

Negative temporal properties enforces that an event must **not**
happen after another event.

```
# ts1 @ f(x) returns z =/> ts2 @ g(a) returns c /\ side-cond
```

- when invoke `g`, check `f` has not invoked **and** `side-cond` is true
- ~~after invoke `f`, enforce `g` cannot be invoked eventually~~

For example, the following spec enforces that `g` cannot be
invoked after `f` using `z` as the argument:
```
# ts1 @ f(x) returns z =/> ts2 @ g(z) returns c
or equivalently
# ts1 @ f(x) returns z =/> ts2 @ g(y) returns c /\ x == y
```
However it is okay to call `g` after `f` with an argument different from `z`.

## Contextual Contracts

Contextual contracts inspect the calling-context/stack within the
current smart contract.

Related work: stack inspection. But we don't need to modify the runtime
of EVM, but simply record a shadow stack for necessary metadata. Is that enough?

### Positive contextual properties

### Negative contextual properties

The following program is a violation of non-reentrancy:

```
# non-reentrant
function f(uint x) { f(n) }
```

This is an example of negative contextual properties, i.e. something cannot happen
under the current calling context. Under the neath, this spec is equivalent to

```
# f ~/> f
function f(uint x) { f(n) }
```

## Unifying Temporal and Contextual Contracts

Each function invocation induces a call event and a return event.
For example, `f(a)` induces `f-call(a)` and `f(a)-ret(v)`, where `v` is the
returned value.
For two pairs of before-after function invocations `f-call`/`f-ret` and
`g-call`/`g-ret`, our temporal contracts enforce properties at event
`g-call` and `g-ret`.
However, for contextual contracts, some observations are only available
and can be checked at event `f-ret` (which is temporally happening later).

```
ts1@call[f](x1,...) from sd1
ts1@ret[f](v1) from sd1
ts2@call[g](x2,...) from sd2
  ts2@call[h](x3,...) from sd2
  ts2@ret[h](v3) from sd2
ts2@ret[g](v2) from sd2
```
