module Checker where

import Data.List (find)
import AST

--------------------------------------------------------------------------

data Type
	= T_Unknown
	| T_IntChar
	| T_Bool
	| T_Void
	| T_Comparable
	| T_Arrow [Type] Type
	deriving (Show, Eq)

data Initialised = Yes | No | Maybe deriving (Show, Eq)
type IsParam = Bool
type ScopeLevel = Int
type VariableDef = (Type, Name, ScopeLevel, Initialised, IsParam)
type BinaryOpDef = (Type, BinOp)
type FunctionDef = (Type, Name)
type Environment = ([VariableDef], [BinaryOpDef], [FunctionDef])

initialEnv = ([], [
		(T_Arrow [T_Comparable, T_Comparable] T_Bool, Eq),
		(T_Arrow [T_Comparable, T_Comparable] T_Bool, NotEq),
		(T_Arrow [T_Bool, T_Comparable] T_Bool, Or),
		(T_Arrow [T_Bool, T_Comparable] T_Bool, And),
		(T_Arrow [T_Comparable, T_Comparable] T_Bool, AST.LT),
		(T_Arrow [T_Comparable, T_Comparable] T_Bool, AST.GT),
		(T_Arrow [T_Comparable, T_Comparable] T_Bool, LTE),
		(T_Arrow [T_Comparable, T_Comparable] T_Bool, GTE),
		(T_Arrow [T_IntChar, T_IntChar] T_IntChar, Plus),
		(T_Arrow [T_IntChar, T_IntChar] T_IntChar, Minus),
		(T_Arrow [T_IntChar, T_IntChar] T_IntChar, Mult),
		(T_Arrow [T_IntChar, T_IntChar] T_IntChar, Div),
		(T_Arrow [T_IntChar, T_IntChar] T_IntChar, Mod)
	], [
		(T_Arrow [] T_Void, "exit"),
		(T_Arrow [T_IntChar] T_Void, "printc"),
		(T_Arrow [T_IntChar] T_Void, "printi")
	])

--This function is there incase the types are ever siginificantly extended
--to include things like strings and pointers, in which case it would not
--be as trivial
subtypeOf :: Type -> Type -> Bool
subtypeOf _ T_Comparable = True
subtypeOf _ _ = False

--------------------------------------------------------------------------

type ErrorMessage = String

data TC a =	TC ([ErrorMessage] -> Environment -> Name
	-> (a, [ErrorMessage], Environment, Name))

instance Monad TC where

	return x = TC (\es en fn -> (x,es,en,fn))

	st >>= f = TC (\es en fn -> let (x,es',en',fn') = apply st es en fn in
		apply (f x) es' en' fn')

apply :: TC a -> [ErrorMessage] -> Environment -> Name
	-> (a, [ErrorMessage], Environment, Name)
apply (TC f) = f

emitError :: ErrorMessage -> TC ()
emitError e = TC (\es en fn -> ((), es ++ [e], en, fn))

getEnv :: TC Environment
getEnv = TC (\es en fn -> (en, es, en, fn))

updateEnv :: Environment -> TC ()
updateEnv en' = TC (\es en fn -> ((), es, en', fn))

addVarToEnv :: Type -> Name -> ScopeLevel -> Initialised -> IsParam -> TC ()
addVarToEnv t n s i p = TC (\es (vs,bs,fs) fn -> ((), es, ((t,n,s,i,p):vs,bs,fs), fn))

addFuncToEnv :: Type -> Name -> TC ()
addFuncToEnv t n = TC (\es (vs,bs,fs) fn -> ((), es, (vs,bs,(t,n):fs), fn))

varAlreadyExists :: ScopeLevel -> Name -> TC Bool
varAlreadyExists s n = TC (\es en fn -> (f en, es, en, fn))
	where
		getVarType (vs,_,_) s n = do
			(t,_,_,_,_) <- find (\(_,n',s',_,_)-> n == n' && s == s') vs
			return t
		f en = case getVarType en s n of Nothing -> False; Just _ -> True

getVarType :: Name -> TC (Maybe Type)
getVarType n = TC (\es en fn -> (getVarType en n, es, en, fn))
	where
		getVarType (vs,_,_) n = do
			(t,_,_,_,_) <- find (\(_,n',_,_,_)-> n == n') vs
			return t

funcAlreadyExists :: Name -> TC Bool
funcAlreadyExists n = TC (\es en fn -> (f en, es, en, fn))
	where
		getFuncType (_,_,fs) n = do
			(t,_) <- find (\(_,n')-> n == n') fs
			return t
		f en = case getFuncType en n of Nothing -> False; Just _ -> True

getFuncType :: Name -> TC (Maybe Type)
getFuncType n = TC (\es en fn -> (getVarType en n, es, en, fn))
	where
		getVarType (_,_,fs) n = do
			(t,_) <- find (\(_,n')-> n == n') fs
			return t

isInitialised :: Name -> TC Initialised
isInitialised n = TC (\es en fn -> (isInitialised' en n, es, en, fn))

isParameter :: Name -> TC Bool
isParameter n = TC (\es en fn -> (isParameter' en n, es, en, fn))

getBinOpType :: BinOp -> TC (Maybe Type)
getBinOpType o = TC (\es en fn -> (getBinOpType' en o, es, en, fn))

initialise :: Name -> TC ()
initialise n' = TC (\es (vs,bs,fs) fn -> ((), es, (remake vs,bs,fs), fn))
	where
		remake :: [VariableDef] -> [VariableDef]
		remake ((t,n,s,i,p):vs)
			| n == n' = (t,n,s,Yes,p):vs
			| otherwise = (t,n,s,i,p) : (remake vs)

removeVarsAtScope :: ScopeLevel -> TC ()
removeVarsAtScope s = TC (\es (vs,bs,fs) fn -> ((), es, (filter f vs,bs,fs), fn))
	where
		f (_,_,s',_,_) = s /= s'

mergeEnvs :: Environment -> Environment -> TC ()
mergeEnvs (vs1,_,_) (vs2,_,_) = TC (\es (vs,bs,fs) fn ->
	((), es, (compareVarEnvs vs1 vs2,bs,fs), fn))

setCurrentFunctionName :: Name -> TC ()
setCurrentFunctionName n = TC (\es en fn -> ((), es, en, n))

getCurrentFunctionName :: TC Name
getCurrentFunctionName = TC (\es en fn -> (fn, es, en, fn))

--------------------------------------------------------------------------

isInitialised' :: Environment -> Name -> Initialised
isInitialised' (vs,_,_) n = case find (\(_,n',_,_,_)-> n == n') vs of
	Nothing -> No
	Just (_,_,_,i,_) -> i



isParameter' :: Environment -> Name -> Bool
isParameter' (vs,_,_) n = case find (\(_,n',_,_,_)-> n == n') vs of
	Nothing -> False
	Just (_,_,_,_,p) -> p



getBinOpType' :: Environment -> BinOp -> Maybe Type
getBinOpType' (_,bs,_) b = do
	(t,_) <- find (\(_,b')-> b == b') bs
	return t



compareVarEnvs :: [VariableDef] -> [VariableDef] -> [VariableDef]
compareVarEnvs [] [] = []
compareVarEnvs ((t,n,s,i,p):vs1) ((_,_,_,i',_):vs2)
	| i /= i' = (t,n,s,Maybe,p) : (compareVarEnvs vs1 vs2)
	| i == i  = (t,n,s,i,p) : (compareVarEnvs vs1 vs2)

--------------------------------------------------------------------------

checkStms :: ScopeLevel -> [Statement] -> TC ()
checkStms sl [] = return ()
checkStms sl (s:ss) = do
	checkStm sl s
	checkStms sl ss



checkStm :: ScopeLevel -> Statement -> TC ()
checkStm sl StmCompound { scDecls = decls, scStms = ss } = do
	checkVarDefs (sl+1) decls
	checkStms (sl+1) ss
	removeVarsAtScope (sl+1)
checkStm sl StmIf { siCond = e, siThen = s1, siElse = ms2} = do
	t <- checkExp sl e
	if (t /= T_Bool) then do
		fn <- getCurrentFunctionName
		emitError $ "Type Error: If Statement conditional expression in function '"
			++ fn ++ "' must evaluate to type T_Bool"
	 else return ()
	case ms2 of
		Nothing -> do
			en1 <- getEnv
			checkStm sl s1
			en2 <- getEnv
			mergeEnvs en1 en2
		Just s2 -> do
			originalEnv <- getEnv
			checkStm sl s2
			en1 <- getEnv
			updateEnv originalEnv
			checkStm sl s1
			en2 <- getEnv
			mergeEnvs en1 en2
checkStm sl StmWhile { swExp = e, swStm = s } = do
	t <- checkExp sl e
	if (t /= T_Bool) then do
		fn <- getCurrentFunctionName
		emitError $ "Type Error: While loop conditional expression in function '"
			++ fn ++ "' must evaluate to type T_Bool"
	 else return ()
	en1 <- getEnv
	checkStm sl s
	en2 <- getEnv
	mergeEnvs en1 en2
checkStm sl StmExpression { seExp = e } =
	case e of
		Nothing -> return ()
		Just e' -> do
			_ <- checkExp sl e'
			return ()
checkStm sl StmReturn { srExp = me } = do
	fn <- getCurrentFunctionName
	mt <- getFuncType fn
	case mt of
		Nothing -> do
			emitError $ "Implementation Error: The Function: '" ++ fn
				++ "' does not have an associated type" --Should never be called
			return ()
		Just (T_Arrow _ tr) -> do
			case me of
				Nothing -> if (tr == T_Void) then return () else emitError $
					"Error: The function '" ++ fn ++ "' is of type 'T_Void' so \
					\you cannot return a value from it"
				Just e -> do
					te <- checkExp sl e
					if (te == tr) then return () else emitError $
						"Error: This function '" ++ fn ++ "' expects a return type of '"
						++ (show tr) ++ "' but you tried to return a value of type '"
						++ (show te) ++ "'"



checkExp :: ScopeLevel -> Expression -> TC Type
checkExp s ExpId { eiVal = n } = do
	mt <- getVarType n
	case mt of
		Nothing -> do
			emitError $ "Scope Error: The Variable '" ++ n ++ "' is not in scope \
			\or does not exist"
			return T_Unknown
		Just T_Unknown -> return T_Unknown
		Just t -> do
			init <- isInitialised n
			case init of
				Yes -> return ()
				No -> emitError $ "Error: The variable " ++ n ++ " is not initialised"
				Maybe -> emitError $ "Error: The variable '" ++ n ++ "' may not be initialised"
			return t
checkExp s ExpIntLit {} = return T_IntChar
checkExp s ExpCharLit {} = return T_IntChar
checkExp s ExpBoolLit {} = return T_Bool
checkExp s ExpAssign {saId = n, saExp = e} = do
	t <- checkExp s e
	mt <- getVarType n
	case mt of
		Nothing -> do
			emitError $ "Scope Error: The Variable '" ++ n ++ "' is not in scope \
			\or does not exist"
			return T_Unknown
		Just t' ->
			if t == t' || t == T_Unknown then do
				initialise n
				return t
			 else do
				initialise n
				emitError $ "Type Error: The type of the variable '" ++ n ++ "' is '" ++
					(show t') ++ "' which does not match the type being assigned: "
					++ (show t)
				return T_Unknown
checkExp s ExpBinOpApp {arg1 = a1, arg2 = a2, op = o} = do
	mt <- getBinOpType o
	case mt of
		Nothing -> do
			emitError $ "Implementation Error: The Binary Operator: '" ++ (show o)
				++ "' does not have an associated type" --Should never be called
			return T_Unknown
		Just ta@(T_Arrow tps tr) -> do
			t1 <- checkExp s a1
			t2 <- checkExp s a2
			if (t1 == t2) then do
				t <- checkArrow (show o) ta [t1, t2]
				return t
			 else if (t1 /= T_Unknown && t2 /= T_Unknown) then do
				emitError $ "Type Error: The Binary Operator '" ++ (show o)
					++ "' requires arguments of the following types: " ++ (show tps)
				return T_Unknown
			 else
				return T_Unknown
checkExp 0 ExpCall {ecId = (ExpId {eiVal = n})} = do
	emitError $ "Error: You have attempted to call a function '" ++ n
		++ "' to assign a value to a global variable, this is not permitted"
	return T_Unknown
checkExp s ExpCall {ecId = (ExpId {eiVal = n}), ecArgs = es} = do
	mt <- getFuncType n
	case mt of
		Nothing -> do
			emitError $ "Error: The function '" ++ n ++ "' does not exist"
			return T_Unknown
		Just (T_Arrow pts rt) -> do
			if length pts == length es then
				checkParams n 1 s pts es
			 else
				emitError $ "Error: The function '" ++ n ++ "' expects "
					++ (show $ length pts) ++ " arguments, but you have supplied "
					++ (show $ length es)
			return rt
checkExp s ExpCall {ecId = _} = do
	emitError $ "Error: Cannot call an expression like a function"
	return T_Unknown



checkParams :: Name -> Int -> ScopeLevel -> [Type] -> [Expression] -> TC ()
checkParams _ _ _ [] [] = return ()
checkParams n i sl (t:ts) (e:es) = do
	te <- checkExp sl e
	if te == t then return () else emitError $ "Error: The " ++ (createStNdRdTh i)
		++ " parameter in for the function '" ++ n ++ "' expects a value of type '"
		++ (show t) ++ "' but you have supplied a value of type '" ++ (show te) ++ "'"



checkDecls :: ScopeLevel -> DataType -> [(Name, Maybe Expression)] -> TC ()
checkDecls sl dt [] = return ()
checkDecls sl dt ((n, e):decls) = do
	funcName <- getCurrentFunctionName
	let typeAndLoc = (if sl == 0 then "Global Variable" else "Local Variable in " ++ funcName) in do
		b <- varAlreadyExists sl n
		if b then
			return ()
		 else do
			case e of
				Nothing -> addVarToEnv (mapType dt) n sl No False
				Just e -> do
					t <- checkExp sl e
					if t /= (mapType dt) && t /= T_Unknown then
						emitError $ "Type Error: " ++ typeAndLoc ++ " '" ++ n ++ "' was expecting \
							\a value of type: '" ++ (show $ mapType dt) ++ "' but its \
							\initialisation expression evaluates to type: '" ++ (show t) ++ "'"
					 else
						return ()
					addVarToEnv (mapType dt) n sl Yes False
			checkDecls sl dt decls



checkVarDefs :: ScopeLevel -> [Definition] -> TC ()
checkVarDefs sl [] = return ()
checkVarDefs sl ((DefDeclaration {ddType = dt, ddDeclarations = decls}):ds) = do
	checkDecls sl dt decls
	checkVarDefs sl ds



processParams :: [(DataType, Name)] -> TC [Type]
processParams [] = return []
processParams ((dt,n):ps) = do
	addVarToEnv (mapType dt) n 1 Yes True
	ts <- processParams ps
	return $ (mapType dt):ts



checkFuncDecl :: DataType -> Declarator -> TC ()
checkFuncDecl dt DeclFunction {dfId = n, dfParams = ps} = do
	setCurrentFunctionName n
	b <- funcAlreadyExists n
	if b then
		emitError $ "Error: The function name '" ++ n ++ "' has already been used"
	 else
		return ()
	rs <- processParams ps
	addFuncToEnv (T_Arrow rs (mapType dt)) n



checkFunctions :: [Definition] -> TC ()
checkFunctions [] = return ()
checkFunctions ((DefFunction {dfType = dt, dfDeclarator = decl, dfStatement = s}):ds) = do
	checkFuncDecl dt decl
	checkStm 1 s
	removeVarsAtScope 1
	checkFunctions ds



checkAll :: [Definition] -> TC ()
checkAll ds = do
	case find matchMain ds of
		Nothing -> emitError "Structural Error: There is no main() function"
		Just (DefFunction {dfType = dt, dfDeclarator = DeclFunction {dfParams = ps}})
			| dt /= VoidType || length ps > 0 ->
				emitError "Structural Error: 'main()' should have type void and \
					\should have no parameters"
			| otherwise -> return ()
	checkVarDefs 0 $ filter onlyDecls ds
	checkFunctions $ filter onlyFuncs ds



check :: AST -> IO [ErrorMessage]
check (AST ds) = return . sndFromQuad $ apply (checkAll ds) [] initialEnv ""

--------------------------------------------------------------------------

checkArrow :: Name -> Type -> [Type] -> TC Type
checkArrow n (T_Arrow ta tr) t = do
	b <- checkTypes ta t
	if b then
		return tr
	 else do
		emitError $ "Type Error: '" ++ n ++ "' was expected parameters of type: '"
			++ (show ta) ++ "' but instead it was passed parameters of type: '"
			++ (show t) ++ "'"
		return T_Unknown



checkTypes :: [Type] -> [Type] -> TC Bool
checkTypes t1s t2s
	| length t1s == length t2s =
		return $ and [t2 `subtypeOf` t1 || t1 == t2 | t1 <- t1s, t2 <- t2s]
	| otherwise = return False

--------------------------------------------------------------------------

sndFromQuad :: (a,b,c,d) -> b
sndFromQuad (_,b,_,_) = b



mapType :: DataType -> Type
mapType VoidType = T_Void
mapType CharType = T_IntChar
mapType IntType = T_IntChar
mapType BoolType = T_Bool



createStNdRdTh :: Int -> String
createStNdRdTh i = case i `mod` 10 of
	1 -> (show i) ++ "st"
	2 -> (show i) ++ "nd"
	3 -> (show i) ++ "rd"
	_ -> (show i) ++ "th"
