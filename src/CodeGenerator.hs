module CodeGenerator where

import Data.List (find)
import Data.Char (ord)
import AST
import MachineCode
import StandardLibrary

--------------------------------------------------------------------------

type FreshLabel = Int
type Pops = Int
type Locals = Int
type RequiredImports = [Name]
data CG a =	CG (FreshLabel -> [Pops] -> [Locals] -> Name -> RequiredImports
	-> (a, FreshLabel, [Pops], [Locals], Name, RequiredImports))

instance Monad CG where

	return x = CG (\s p l f r -> (x,s,p,l,f,r))

	st >>= f = CG (\s p l n r ->
		let (x,s',p',l',n',r') = apply st s p l n r in apply (f x) s' p' l' n' r')

apply :: CG a -> FreshLabel -> [Pops] -> [Locals] -> Name -> RequiredImports
	-> (a, FreshLabel, [Pops], [Locals], Name, RequiredImports)
apply (CG f) = f

freshLabel :: CG String
freshLabel = CG (\n p l f r -> ("label" ++ (show n), n+1, p, l, f, r))

newBlock :: CG ()
newBlock = CG(\n p l f r -> ((), n, 0:p, 0:l, f, r))

push :: Int -> CG ()
push i = CG (\n (p:ps) l f r -> ((), n, (p + i):ps, l, f, r))

pop :: Int -> CG ()
pop i = CG (\n (p:ps) l f r -> ((), n, (p - i):ps, l, f, r))

getPops :: CG Int
getPops = CG (\n (p:ps) l f r -> (p, n, (0:ps), l, f, r))

addLocals :: Int -> CG ()
addLocals i = CG (\n p (l:ls) f r -> ((), n, p, (l + i):ls, f, r))

getLocals :: CG Int
getLocals =  CG (\n p l f r -> ((sum l), n, p, l, f, r))

endBlock :: CG Int
endBlock = CG (\n (p:ps) (l:ls) f r -> (l, n, ps, ls, f, r))

getCurrentFunctionName :: CG Name
getCurrentFunctionName = CG (\n p l f r -> (f, n, p, l, f, r))

setCurrentFunctionName :: Name -> CG ()
setCurrentFunctionName f' = CG (\n p l f r -> ((), n, p, l, f', r))

checkIfImportNeeded :: Environment -> Name -> CG ()
checkIfImportNeeded en fn = CG (\n p l f r -> ((), n, p, l, f, maybeFunc ++ r))
	where
		maybeFunc = if u then [] else [fn]
		(_,_,u) = lookupFunction en fn

--------------------------------------------------------------------------

type Args = Int
type Returns = Int
type UserDefined = Bool

type VariableLocation = (Name, Register, Int)
type FunctionDef = (Name, Args, Returns, UserDefined)
type Environment = ([VariableLocation],[FunctionDef])

initialEnv :: Environment
initialEnv = ([], [
		("exit", 0, 0, False),
		("printc", 0, 1, False),
		("printi", 0, 1, False)
	])

--------------------------------------------------------------------------

makeVarEnv :: [Definition] -> [VariableLocation]
makeVarEnv [] = []
makeVarEnv ds = [(n, SB, a) | (n, a) <- zip (getVarNames ds) [0..]]

updateEnv :: Environment -> Name -> Register -> Int -> Environment
updateEnv (vs,fs) n r i = ((n,r,i):vs, fs)

getVarNames :: [Definition] -> [Name]
getVarNames [] = []
getVarNames (DefDeclaration {ddDeclarations = decls}:ds) =
	[n | (n, _) <- decls] ++ (getVarNames ds)

makeFuncEnv :: [Definition] -> [FunctionDef]
makeFuncEnv ds = [(n, length ps, returnType dt, True) | (DefFunction {
		dfType = dt,
		dfDeclarator = (DeclFunction {
			dfId = n,
			dfParams = ps})
	}) <- ds]

returnType :: DataType -> Int
returnType VoidType = 0
returnType _ = 1

pushVariables :: Environment -> [Definition] -> CG [Instruction]
pushVariables _ [] = return []
pushVariables en (DefDeclaration {ddDeclarations = decls}:ds) = do
	code1 <- evaluateDeclarations en decls
	code2 <- pushVariables en ds
	return $ code1 ++ code2

pushLocals :: Environment -> [Definition] -> CG (Environment, [Instruction])
pushLocals (vs,fs) ds = do
	l <- getLocals
	vs' <- return $ [(n, LB, a) | (n, a) <- zip (getVarNames ds) [2 + l..]]
	addLocals $ length vs'
	newEn <- return ((vs' ++ vs, fs))
	code <- pushVariables newEn ds
	return (newEn,code)

addParamsToEnv :: Environment -> [(DataType, Name)] -> Environment
addParamsToEnv (vs,fs) ps =
	([(n, LB, 0 - (length ps) - i) | ((_, n), i) <- zip ps [0..]] ++ vs, fs)

evaluateDeclarations :: Environment -> [(Name, Maybe Expression)] -> CG [Instruction]
evaluateDeclarations _ [] = return []
evaluateDeclarations en ((_, me):ds) =
	case me of
		Nothing -> return [LOADL 0]
		Just e -> do
			pop 1
			code1 <- evaluate en e
			code2 <- evaluateDeclarations en ds
			return $ code1 ++ code2

moveMain :: [Definition] -> [Definition]
moveMain ds = case find matchMain ds of
	Nothing -> error $ "No main function found"
	Just d -> (filter onlyFuncsNoMain ds) ++ [d]
	where
		onlyFuncsNoMain :: Definition -> Bool
		onlyFuncsNoMain (DefFunction {
			dfDeclarator = DeclFunction {dfId = "main"}}) = False
		onlyFuncsNoMain (DefFunction {}) = True
		onlyFuncsNoMain _ = False


lookupVariable :: Environment -> Name -> (Register, Int)
lookupVariable (vs, _) n = case find (\(n', _, _) -> n == n') vs of
		Nothing -> error $ "Variable " ++ n ++ " does not exist"
		Just (_, r, i) -> (r, i)

lookupFunction :: Environment -> Name -> (Args, Returns, UserDefined)
lookupFunction (_, fs) n = case find (\(n', _, _, _) -> n == n') fs of
		Nothing -> error $ "Function " ++ n ++ " does not exist"
		Just (_, a, r, u) -> (a, r, u)

--------------------------------------------------------------------------

executeStatements :: Environment -> [Statement] -> CG [Instruction]
executeStatements en [] = return []
executeStatements en (s:ss) = do
	c <- execute en s
	cs <- executeStatements en ss
	return $ c ++ cs

execute :: Environment -> Statement -> CG [Instruction]
execute en StmCompound {scDecls = ds, scStms = ss} = do
	newBlock
	(en', vars) <- pushLocals en ds
	code <- executeStatements en' ss
	l <- endBlock
	return (vars ++ code ++ [POP 0 l])
execute en StmIf {siCond = e, siThen = s1, siElse = s2} =
	case s2 of
		Nothing -> do
			l <- freshLabel
			ce <- evaluate en e
			p <- getPops
			cs <- execute en s1
			return $ ce ++ [POP 1 (p - 1), JUMPIFZ l] ++ cs ++ [LABEL l, POP 0 1]
		Just s2' -> do
			l1 <- freshLabel
			l2 <- freshLabel
			ce <- evaluate en e
			p <- getPops
			cs1 <- execute en s1
			cs2 <- execute en s2'
			return $ ce ++ [JUMPIFZ l1] ++ cs1 ++ [POP 0 p, JUMP l2, LABEL l1]
				++ cs2 ++ [POP 0 p, LABEL l2]
execute en StmWhile {swExp = e, swStm = s} = do
	l1 <- freshLabel
	l2 <- freshLabel
	ce <- evaluate en e
	p <- getPops
	cs <- execute en s
	return $ [JUMP l2, LABEL l1, POP 0 1] ++ cs ++ [LABEL l2] ++ ce
		++ [POP 0 (p - 1), JUMPIFNZ l1, POP 0 1]
execute en StmExpression {seExp = e} = do
	case e of
		Nothing -> return []
		Just e' -> do
			c <- evaluate en e'
			p <- getPops
			return $ c ++ [POP 0 p]
execute en StmReturn { srExp = e } = do
	n <- getCurrentFunctionName
	(a, r, _) <- return $ lookupFunction en n
	push $ r - a
	case e of
		Nothing -> return [RETURN a r] --FIX THIS
		Just e' -> do
			c <- evaluate en e'
			return $ c ++ [RETURN a r] --FIX THIS

evaluateExpressions :: Environment -> [Expression] -> CG [Instruction]
evaluateExpressions en [] = return []
evaluateExpressions en (e:es) = do
	c <- evaluate en e
	cs <- evaluateExpressions en es
	return $ c ++ cs

evaluate :: Environment -> Expression -> CG [Instruction]
evaluate en ExpId {eiVal = n} = do
	push 1
	let (r, i) = lookupVariable en n in
		return [LOAD r i]
evaluate _ ExpIntLit {eilVal = i} = do
	push 1
	return [LOADL i]
evaluate _ ExpCharLit {eclVal = c} = do
	push 1
	return [LOADL $ ord c]
evaluate _ ExpBoolLit {eblVal = b} = do
	push 1
	let b' = if b then 1 else 0 in
		return [LOADL b']
evaluate en ExpAssign {saId = n, saExp = e} = do
	c <- evaluate en e
	let (r, i) = lookupVariable en n in
		return (c ++ [LOAD ST 0, STORE r i])
evaluate en ExpBinOpApp {arg1 = e1, arg2 = e2, op = o} = do
	c1 <- evaluate en e1
	c2 <- evaluate en e2
	pop 1
	return (c2 ++ c1 ++ (case o of
			Plus -> [ADD]
			Minus -> [SUB]
			Mult -> [MULT]
			Div -> [DIV]
			Eq -> [EQUALS]
			NotEq -> [NOT_EQ]
			Or -> [OR]
			And -> [AND]
			AST.LT -> [LESS_THAN]
			AST.GT -> [GREATER_THAN]
			LTE -> [LT_OR_EQ]
			GTE -> [GT_OR_EQ]
			Mod -> [MOD]
		))
evaluate en ExpCall {ecId = (ExpId { eiVal = n}), ecArgs = es } = do
	code <- evaluateExpressions en es
	checkIfImportNeeded en n
	return $ code ++ [CALL $ "label_" ++ n]

--------------------------------------------------------------------------

generateGlobals :: Environment -> [Definition] -> IO (Environment, [Instruction])
generateGlobals (_,fs) ds = do
	decls <- return $ filter onlyDecls ds
	funcs <- return $ filter onlyFuncs ds
	vs <- return . makeVarEnv $ decls
	code <- return $ runMonad (pushVariables (vs,[]) decls)
	fs' <- return . makeFuncEnv $ funcs
	return ((vs, fs ++ fs'), code)


generateFunctions :: Environment -> [Definition] -> CG [Instruction]
generateFunctions _ [] = return []
generateFunctions en (f:fs) = do
	c <- generateFunction en f
	cs <- generateFunctions en fs
	return $ c ++ cs

generateFunction :: Environment -> Definition -> CG [Instruction]
generateFunction en (DefFunction {dfDeclarator = d,dfStatement = s}) =
	let DeclFunction {dfId = n} = d in do
		setCurrentFunctionName n
		(a, r, _) <- return $ lookupFunction en' n
		body <- execute en' s
		maybeReturn <- return $ case r of
			0 -> [RETURN a 0]
			_ -> []
		return $ [LABEL $ "label_" ++ n] ++ body ++ maybeReturn
	where
		en' = addParamsToEnv en p
		(p, n) = let (DeclFunction { dfId = n, dfParams = p } ) = d in (p, n)

generateCode :: AST -> IO [Instruction]
generateCode (AST ds) = do
	(globalEnv, globalCode) <- generateGlobals initialEnv ds
	(functionCode, requiredImports) <-
		return $ runMonadGetImports (generateFunctions globalEnv (moveMain ds))
	return $ combinePops (globalCode ++ [CALL "label_main", HALT]
		++ (getCode requiredImports) ++ functionCode)

getCode :: [Name] -> [Instruction]
getCode [] = []
getCode (n:ns) = (stdLib n) ++ (getCode ns)


--------------------------------------------------------------------------

fstFromSix :: (a, b, c, d, e, f) -> a
fstFromSix (a, _, _, _, _, _) = a

combinePops :: [Instruction] -> [Instruction]
combinePops [] = []
combinePops ((POP _ 0):is) = combinePops is
combinePops ((POP n1 m1):(POP n2 m2):is)
	| n1 == n2 = combinePops ((POP n1 (m1 + m2)):is)
combinePops (i:is) = i : (combinePops is)

runMonad :: CG a -> a
runMonad m = fstFromSix $ apply m 0 [0] [0] "" []

runMonadGetImports :: CG a -> (a, RequiredImports)
runMonadGetImports m = (\(x,_,_,_,_,y) -> (x,y)) $ apply m 0 [0] [0] "" []
