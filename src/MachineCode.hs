module MachineCode where

type Label = String

data Register = SB | ST | LB deriving Show

-- Machine Instructions

data Instruction
	= LABEL Label
	| LOADL Int
	| LOADA Register Int
	| LOAD Register Int
	| STORE Register Int
	| ADD
	| SUB
	| MULT
	| DIV
	| MOD
	| EQUALS
	| NOT_EQ
	| OR
	| AND
	| LESS_THAN
	| GREATER_THAN
	| LT_OR_EQ
	| GT_OR_EQ
	| POP Int Int
	| JUMP Label
	| JUMPIFZ Label
	| JUMPIFNZ Label
	| CALL String
	| RETURN Int Int
	| PRINTC
	| PRINTI
	| HALT
	deriving Show
