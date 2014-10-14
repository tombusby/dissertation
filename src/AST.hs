module AST where

type Name = String

data DataType = VoidType | CharType | IntType | BoolType deriving (Show, Eq)

data BinOp
	= Eq	| NotEq	| Or	| And
	| LT	| GT	| LTE	| GTE
	| Plus	| Minus
	| Mult	| Div	| Mod
	deriving (Show, Eq)

data AST = AST [Definition] deriving Show

data Definition
	= DefFunction
	{
		dfType :: DataType,
		dfDeclarator :: Declarator,
		dfStatement :: Statement
	}
	| DefDeclaration
	{
		ddType :: DataType,
		ddDeclarations :: [(Name, Maybe Expression)]
	}
	deriving Show

data Declarator
	= DeclFunction
	{
		dfId :: Name,
		dfParams :: [(DataType, Name)]
	}
	deriving Show

data Statement
	= StmCompound
	{
		scDecls :: [Definition],
		scStms :: [Statement]
	}
	| StmIf
	{
		siCond :: Expression,
		siThen :: Statement,
		siElse :: Maybe Statement
	}
	| StmWhile
	{
		swExp :: Expression,
		swStm :: Statement
	}
	| StmExpression
	{
		seExp :: Maybe Expression
	}
	| StmReturn
	{
		srExp :: Maybe Expression
	}
	deriving Show

data Expression
	= ExpId
	{
		eiVal :: Name
	}
	| ExpIntLit
	{
		eilVal :: Int
	}
	| ExpCharLit
	{
		eclVal :: Char
	}
	| ExpBoolLit
	{
		eblVal :: Bool
	}
	| ExpAssign
	{
		saId :: Name,
		saExp :: Expression
	}
	| ExpBinOpApp
	{
		arg1 :: Expression,
		arg2 :: Expression,
		op :: BinOp
	}
	| ExpCall
	{
		ecId :: Expression,
		ecArgs :: [Expression]
	}
	deriving Show

onlyDecls :: Definition -> Bool
onlyDecls (DefDeclaration {}) = True
onlyDecls _ = False

onlyFuncs :: Definition -> Bool
onlyFuncs (DefFunction {}) = True
onlyFuncs _ = False

matchMain :: Definition -> Bool
matchMain (DefFunction {
	dfDeclarator = DeclFunction {dfId = "main"}}) = True
matchMain _ = False
