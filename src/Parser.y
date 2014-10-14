{

module Parser where

import Data.Char
import Token
import AST

}

%name parse
%tokentype { Token }
%error { parseError }

%token
	id			{ T_Id $$ }
	intlit		{ T_IntLit $$ }
	charlit		{ T_CharLit $$ }
	boollit		{ T_BoolLit $$ }
	inttype 	{ T_IntType }
	chartype	{ T_CharType }
	booltype	{ T_BoolType }
	voidtype	{ T_VoidType }
	if			{ T_If }
	else		{ T_Else }
	do			{ T_Do }
	while		{ T_While }
	for			{ T_For }
	break		{ T_Break }
	continue	{ T_Continue }
	return		{ T_Return }
	'('			{ T_LParen }
	')'			{ T_RParen }
	'{'			{ T_LBrace }
	'}'			{ T_RBrace }
	'['			{ T_LSqBracket }
	']'			{ T_RSqBracket }
	','			{ T_Comma }
	'?'			{ T_QMark }
	':'			{ T_Colon }
	';'			{ T_SemiColon }
	'!'			{ T_Not }
	'=='		{ T_Eq }
	'!='		{ T_NotEq }
	'>='		{ T_GTE }
	'<='		{ T_LTE }
	'>'			{ T_GT }
	'<'			{ T_LT }
	'&&'		{ T_And }
	'||'		{ T_Or }
	'='			{ T_Assign }
	'/'			{ T_Div }
	'*'			{ T_Star }
	'+'			{ T_Plus }
	'-'			{ T_Minus }
	'%'			{ T_Mod }

%%

TranslationUnit1 :: { AST }
TranslationUnit1
	: TranslationUnit2
		{ AST $1 }

TranslationUnit2 :: { [Definition] }
TranslationUnit2
	: ExternalDeclaration
		{ [$1] }
	| ExternalDeclaration TranslationUnit2
		{ $1 : $2 }

ExternalDeclaration :: { Definition }
ExternalDeclaration
	: FunctionDefinition
		{ $1 }
	| Declaration
		{ $1 }

Declaration :: { Definition }
Declaration
	: TypeSpecifier InitDeclaratorList ';'
		{ DefDeclaration { ddType = $1, ddDeclarations = $2 } }

DeclarationList :: { [Definition] }
	: Declaration
		{ [$1] }
	| Declaration DeclarationList
		{ $1 : $2 }

InitDeclaratorList :: { [(AST.Name, Maybe Expression)] }
InitDeclaratorList
	: InitDeclarator
		{ [$1] }
	| InitDeclarator  ',' InitDeclaratorList
		{ $1 : $3 }

InitDeclarator :: { (AST.Name, Maybe Expression) }
InitDeclarator
	: id
		{ ($1, Nothing) }
	| id '=' Expression
		{ ($1, Just $3) }

FunctionDefinition :: { Definition }
FunctionDefinition
	: Declarator CompoundStatement
	{
		DefFunction
		{
			dfType = VoidType,
			dfDeclarator = $1,
			dfStatement = $2
		}
	}
    | TypeSpecifier Declarator CompoundStatement
	{
		DefFunction
		{
			dfType = $1,
			dfDeclarator = $2,
			dfStatement = $3
		}
	}


TypeSpecifier :: { DataType }
TypeSpecifier
	: voidtype
		{ VoidType }
	| inttype
		{ IntType }
	| chartype
		{ CharType }
	| booltype
		{ BoolType }

Declarator :: { Declarator }
Declarator
	: id '(' ')'
	{
		DeclFunction
		{
			dfId = $1,
			dfParams = []
		}
	}
	| id '(' ParameterList ')'
	{
		DeclFunction
		{
			dfId = $1,
			dfParams = $3
		}
	}

ParameterList :: { [(DataType, AST.Name)] }
ParameterList
	: ParameterDeclaration
		{ [$1] }
	| ParameterDeclaration ',' ParameterList
		{ $1 : $3 }

ParameterDeclaration :: { (DataType, AST.Name) }
ParameterDeclatation
	: TypeSpecifier id
		{ ($1, $2) }

CompoundStatement :: { Statement }
CompoundStatement
	: '{' '}'
		{ StmCompound { scDecls = [], scStms = [] } }
	| '{' StatementList '}'
		{ StmCompound { scDecls = [], scStms = $2 } }
	| '{' DeclarationList '}'
		{ StmCompound { scDecls = $2, scStms = [] } }
	| '{' DeclarationList StatementList '}'
		{ StmCompound { scDecls = $2, scStms = $3 } }

StatementList :: { [Statement] }
StatementList
	: Statement
		{ [$1] }
	| Statement StatementList
		{ $1 : $2 }

Statement :: { Statement }
Statement
	: CompoundStatement
		{ $1 }
	| SelectionStatement
		{ $1 }
	| IterationStatement
		{ $1 }
	| ExpressionStatement
		{ $1 }
	| JumpStatement
		{ $1 }

JumpStatement :: { Statement }
JumpStatement
	: return ';'
		{ StmReturn { srExp = Nothing } }
	| return Expression ';'
		{ StmReturn { srExp = Just $2 } }

SelectionStatement :: { Statement }
SelectionStatement
	: if '(' Expression ')' Statement
		{ StmIf {siCond = $3, siThen = $5, siElse = Nothing} }
	| if '(' Expression ')' Statement else Statement
		{ StmIf {siCond = $3, siThen = $5, siElse = Just $7} }

IterationStatement :: { Statement }
IterationStatement
	: while '(' Expression ')' Statement
		{ StmWhile {swExp = $3, swStm = $5} }

ExpressionStatement :: { Statement }
ExpressionStatement
	: ';'
		{ StmExpression { seExp = Nothing } }
	| Expression ';'
		{ StmExpression { seExp = Just $1 } }

Expression :: { Expression }
Expression
	: AssignmentExpression
		{ $1 }

AssignmentExpression :: { Expression }
AssignmentExpression
	: LogicalORExpression
		{ $1 }
	| id '=' AssignmentExpression
		{ ExpAssign { saId = $1, saExp = $3 } }

LogicalORExpression :: { Expression }
LogicalORExpression
	: LogicalANDExpression
		{ $1 }
	| LogicalORExpression '||' LogicalANDExpression
		{ ExpBinOpApp {arg1 = $1, arg2 = $3, op = Or} }

LogicalANDExpression :: { Expression }
LogicalANDExpression
	: EqualityExpression
		{ $1 }
	| LogicalANDExpression '&&' EqualityExpression
		{ ExpBinOpApp {arg1 = $1, arg2 = $3, op = And} }

EqualityExpression :: { Expression }
EqualityExpression
	: RelationalExpression
		{ $1 }
	| EqualityExpression '==' RelationalExpression
		{ ExpBinOpApp {arg1 = $1, arg2 = $3, op = Eq} }
	| EqualityExpression '!=' RelationalExpression
		{ ExpBinOpApp {arg1 = $1, arg2 = $3, op = NotEq} }

RelationalExpression :: { Expression }
RelationalExpression
	: AddativeExpression
		{ $1 }
	| RelationalExpression '<' AddativeExpression
		{ ExpBinOpApp {arg1 = $1, arg2 = $3, op = AST.LT} }
	| RelationalExpression '>' AddativeExpression
		{ ExpBinOpApp {arg1 = $1, arg2 = $3, op = AST.GT} }
	| RelationalExpression '<=' AddativeExpression
		{ ExpBinOpApp {arg1 = $1, arg2 = $3, op = LTE} }
	| RelationalExpression '>=' AddativeExpression
		{ ExpBinOpApp {arg1 = $1, arg2 = $3, op = GTE} }

AddativeExpression :: { Expression }
AddativeExpression
	: MultiplicativeExpression
		{ $1 }
	| AddativeExpression '+' MultiplicativeExpression
		{ ExpBinOpApp {arg1 = $1, arg2 = $3, op = Plus} }
	| AddativeExpression '-' MultiplicativeExpression
		{ ExpBinOpApp {arg1 = $1, arg2 = $3, op = Minus} }

MultiplicativeExpression :: { Expression }
MultiplicativeExpression
	: PostfixExpression
		{ $1 }
	| MultiplicativeExpression '*' PostfixExpression
		{ ExpBinOpApp {arg1 = $1, arg2 = $3, op = Mult} }
	| MultiplicativeExpression '/' PostfixExpression
		{ ExpBinOpApp {arg1 = $1, arg2 = $3, op = Div} }
	| MultiplicativeExpression '%' PostfixExpression
		{ ExpBinOpApp {arg1 = $1, arg2 = $3, op = Mod} }

PostfixExpression :: { Expression }
PostfixExpression
	: PrimaryExpression
		{ $1 }
	| PostfixExpression '(' ')'
		{ ExpCall {	ecId = $1, ecArgs = [] } }
	| PostfixExpression '(' ArgumentExpressionList ')'
		{ ExpCall {	ecId = $1, ecArgs = $3 } }

ArgumentExpressionList :: { [Expression] }
ArgumentExpressionList
	: Expression
		{ [$1] }
	| Expression ',' ArgumentExpressionList
		{ $1 : $3 }

PrimaryExpression :: { Expression }
PrimaryExpression
	: id
		{ ExpId { eiVal = $1 } }
	| intlit
		{ ExpIntLit { eilVal = $1 } }
	| charlit
		{ ExpCharLit { eclVal = $1 } }
	| boollit
		{ ExpBoolLit { eblVal = $1 } }
	| '(' Expression ')'
		{ $2 }

{

parseError :: [Token] -> a
parseError [] = error "Parse Error: Unexpected EOF"
parseError (x:xs) = error $ "Parse Error at " ++ (show x)

}
