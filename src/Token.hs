module Token where

import Data.Char

type Name = String

data Token

	--NAME				-- REGEX (T_Star, T_Or to be viewed as literals)

	--General IDs (of function names, variables, etc)
	= T_Id Name			-- ([a-z] | [A-Z] | _)([a-z] | [A-Z] | [0-9] | _)*

	--Literals
	| T_IntLit Int		-- [0-9]+
	| T_CharLit Char	-- '.' | '\x' (where \x is a valid escape sequence)
	| T_BoolLit Bool	-- true | false

	--Data Types
	| T_IntType			-- int
	| T_CharType		-- char
	| T_BoolType		-- bool
	| T_VoidType		-- void

	--Language Keywords
	| T_If				-- if
	| T_Else			-- else
	| T_Do				-- do
	| T_While			-- while
	| T_For				-- for
	| T_Break			-- break
	| T_Continue		-- continue
	| T_Return			-- return

	--General Syntax
	| T_LParen			-- (
	| T_RParen			-- )
	| T_LBrace			-- {
	| T_RBrace			-- }
	| T_LSqBracket		-- [
	| T_RSqBracket		-- ]
	| T_Comma			-- ,
	| T_QMark			-- ?
	| T_Colon			-- :
	| T_SemiColon		-- ;

	--Unary Operators
	| T_Not				-- !

	--Binary Operators
	| T_Eq				-- ==
	| T_NotEq			-- !=
	| T_GTE				-- >=
	| T_LTE				-- <=
	| T_GT				-- >
	| T_LT				-- <
	| T_And				-- &&	(Logical, not bitwise)
	| T_Or				-- ||	(Logical, not bitwise)
	| T_Assign			-- =
	| T_Div				-- /
	| T_Star			-- *	(Can also be a unary operator when used to
						--		 dereference a pointer, but this is not
						--		 currently implemented)
	| T_Plus			-- +
	| T_Minus			-- -	(Also a unary operator for negative number)
	| T_Mod				-- %
	deriving (Eq, Show)
