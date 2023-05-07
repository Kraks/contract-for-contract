import type { Opaque } from 'type-fest';

export interface FlatSpec<T> {
  var: Array<string>;
  cond: T;
}

export interface FunSpec<T> {
  dom: ValSpec<T>;
  codom: ValSpec<T>;
}

export type ValSpec<T> =
  | Opaque<FlatSpec<T>, 'FlatSpec'>
  | Opaque<FunSpec<T>, 'FunSpec'>;

export enum TempConn {
  After,
  NotAfter,
  UnderCtx,
  NotUnderCtx,
}

export interface Call {
  funName: string;
  args: Array<string>;
  rets: Array<string>;
}

export interface TempSpec<T> {
  conn: TempConn;
  call1: Call;
  call2: Call;
  cond: T;
}

export type CSSpec<T> = ValSpec<T> | Opaque<TempSpec<T>, 'TempSpec'>;
