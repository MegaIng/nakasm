import tables

type field_value* = object
  name*: string
  value*: uint64

type field_type* = object
  name*: string
  bit_length*: int
  fields*: seq[field_value]

type exp_kind* = enum
  exp_fail
  exp_number
  exp_operand
  exp_operation

type op_kind* = enum
  op_add
  op_sub
  op_mul
  op_div
  op_mod
  op_and
  op_or
  op_xor
  op_lsl
  op_lsr
  op_asr
  op_byte_swizzle

const OP_INDEXES* = ["+", "-", "*", "/", "%", "and", "or", "xor", "lsl", "lsr", "asr"]

type expression* = ref object
  case exp_kind*: exp_kind
    of exp_fail: discard
    of exp_number:
      value*: uint64
    of exp_operand:
      index*: int
    of exp_operation:
      op_kind*: op_kind
      lhs*: expression
      rhs*: expression

type instruction* = object
  syntax*: seq[string]
  fields*: seq[int]
  virtual_fields*: seq[expression]
  bit_types*: seq[int]
  fixed_pattern*: uint64
  wildcard_mask*: uint64
  description*: string

type assembly_spec* = object
  field_types*: seq[field_type]
  instructions*: seq[instruction]

type spec_parse_result* = object
  error_line*: int
  error*: string
  spec*: assembly_spec

type assembly_result* = object
  byte_code*: seq[uint8]
  line_to_byte*: seq[int]
  error*: string
  error_line*: int
  register_definitions*: Table[int, string]

