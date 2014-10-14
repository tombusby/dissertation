module Scanner where

import Token
import Data.Char

dropComment :: [Char] -> [Char]
dropComment [] = []
dropComment [c] = [c]
dropComment ('*':'/':cs) = cs
dropComment (c:cs) = dropComment cs

scan :: [Char] -> [Token]
scan [] = []

--Drop white space
scan (c:cs) | isSpace c = scan cs

--Drop comments--
scan ('/':'/':cs) = scan $ dropWhile (/='\n') cs
scan ('/':'*':cs) = scan $ dropComment cs

--Scan General Syntax
scan ('(':cs) = T_LParen : scan cs
scan (')':cs) = T_RParen : scan cs
scan ('{':cs) = T_LBrace : scan cs
scan ('}':cs) = T_RBrace : scan cs
scan ('[':cs) = T_LSqBracket : scan cs
scan (']':cs) = T_RSqBracket : scan cs
scan (',':cs) = T_Comma : scan cs
scan ('?':cs) = T_QMark : scan cs
scan (':':cs) = T_Colon : scan cs
scan (';':cs) = T_SemiColon : scan cs

--Scan Binary Operators
scan ('=':'=':cs) = T_Eq : scan cs
scan ('!':'=':cs) = T_NotEq : scan cs
scan ('>':'=':cs) = T_GTE : scan cs
scan ('<':'=':cs) = T_LTE : scan cs
scan ('>':cs) = T_GT : scan cs
scan ('<':cs) = T_LT : scan cs
scan ('&':'&':cs) = T_And : scan cs
scan ('|':'|':cs) = T_Or : scan cs
scan ('=':cs) = T_Assign : scan cs
scan ('/':cs) = T_Div : scan cs
scan ('*':cs) = T_Star : scan cs
scan ('+':cs) = T_Plus : scan cs
scan ('-':cs) = T_Minus : scan cs
scan ('%':cs) = T_Mod : scan cs

--Scan Unary Operators
scan ('!':cs) = T_Not : scan cs

--Scan Literals
scan (c:cs) | isNumber c = let (l,r) = span isNumber (c:cs) in T_IntLit (read l :: Int) : scan r
scan ('\'' : '\\' : c : '\'' : cs)
	| c == '\\' = T_CharLit '\\' : scan cs
	| c == '\'' = T_CharLit '\'' : scan cs
	| c == 'r'  = T_CharLit '\r' : scan cs
	| c == 't'  = T_CharLit '\t' : scan cs
	| c == 'n'  = T_CharLit '\n' : scan cs
scan ('\'' : c : '\'' : cs)
	| ord c >= 32 && ord c <= 126 && c /= '\'' && c /= '\\' = T_CharLit c : scan cs

--Scan Keywords and Identifiers
scan (x:xs) | isAlpha x || x == '_' = mkIdOrKeyword (x:l) : scan r
	where
		(l,r) = span isIdOrKeyword xs
		isIdOrKeyword c = isAlphaNum c || c == '_'

--Token not found
scan (c:cs) | otherwise = error $ "Lexical error at character " ++ [c]


mkIdOrKeyword :: String -> Token

--Make Tokens for Data Type Declarators
mkIdOrKeyword "int" = T_IntType
mkIdOrKeyword "char" = T_CharType
mkIdOrKeyword "bool" = T_BoolType
mkIdOrKeyword "void" = T_VoidType

--Make Tokens for Literals
mkIdOrKeyword "true" = T_BoolLit True
mkIdOrKeyword "false" = T_BoolLit False

--Make Tokens for Language Keywords
mkIdOrKeyword "if" = T_If
mkIdOrKeyword "else" = T_Else
mkIdOrKeyword "do" = T_Do
mkIdOrKeyword "while" = T_While
mkIdOrKeyword "for" = T_For
mkIdOrKeyword "break" = T_Break
mkIdOrKeyword "continue" = T_Continue
mkIdOrKeyword "return" = T_Return

mkIdOrKeyword cs = T_Id cs

