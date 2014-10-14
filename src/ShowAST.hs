module ShowAST where

import AST

printAST :: AST -> IO ()
printAST (AST ds) = do
	putStrLn "AST:\n{"
	printDefinitions 1 ds
	putStrLn "}"

printDefinitions :: Int -> [Definition] -> IO ()
printDefinitions i [] = return ()
printDefinitions i (d:ds) = do
	printDefinition i d
	printDefinitions i ds

printDefinition :: Int -> Definition -> IO ()
printDefinition i DefFunction {dfType = t, dfDeclarator = d, dfStatement = s} = do
	putIndentedStrLn i "Function Definition:"
	putIndentedStrLn i "{"
	printDataType (i+1) t
	printDeclarator (i+1) d
	printStatement (i+1) s
	putIndentedStrLn i "}"
printDefinition i DefDeclaration {ddType = t, ddDeclarations = ds} = do
	putIndentedStrLn i "Variable Definition:"
	putIndentedStrLn i "{"
	printDataType (i+1) t
	printDeclarations (i+1) ds
	putIndentedStrLn i "}"

printDataType :: Int -> DataType -> IO ()
printDataType i VoidType = putIndentedStrLn i "Type: Void"
printDataType i CharType = putIndentedStrLn i "Type: Char"
printDataType i IntType = putIndentedStrLn i "Type: Int"
printDataType i BoolType = putIndentedStrLn i "Type: Bool"

printDeclarator :: Int -> Declarator -> IO ()
printDeclarator i DeclFunction {dfId = id, dfParams = []} = do
	putIndentedStrLn i $ "ID: " ++ id
	putIndentedStrLn i "Parameters: (Empty)"
printDeclarator i DeclFunction {dfId = id, dfParams = ps} = do
	putIndentedStrLn i $ "ID: " ++ id
	putIndentedStrLn i "Parameters:"
	putIndentedStrLn i "{"
	printParams (i+1) ps
	putIndentedStrLn i "}"

printStatements :: Int -> [Statement] -> IO ()
printStatements i [] = return ()
printStatements i (s:ss) = do
	printStatement (i+1) s
	printStatements i ss

printStatement :: Int -> Statement -> IO ()
printStatement i (StmCompound {scStms = []}) = do
	putIndentedStrLn i "Compound Statement: (Empty)"
printStatement i (StmCompound {scDecls = ds, scStms = ss}) = do
	putIndentedStrLn i "Compound Statement:"
	putIndentedStrLn i "{"
	printDefinitions (i+1) ds
	printStatements i ss
	putIndentedStrLn i "}"
printStatement i (StmIf {siCond = e, siThen = s1, siElse = s2}) = do
	putIndentedStrLn i "If Statement:"
	putIndentedStrLn i "{"
	putIndentedStrLn (i+1) "Conditional Expression:"
	putIndentedStrLn (i+1) "{"
	printExpression (i+2) e
	putIndentedStrLn (i+1) "}"
	putIndentedStrLn (i+1) "Then Branch:"
	putIndentedStrLn (i+1) "{"
	printStatement (i+2) s1
	putIndentedStrLn (i+1) "}"
	case s2 of
		Nothing -> putIndentedStrLn (i+1) "Else Branch: (Empty)"
		Just s2' -> do
			putIndentedStrLn (i+1) "Else Branch:"
			putIndentedStrLn (i+1) "{"
			printStatement (i+2) s2'
			putIndentedStrLn (i+1) "}"
	putIndentedStrLn i "}"
printStatement i (StmWhile {swExp = e, swStm = s}) = do
	putIndentedStrLn i "While Statement:"
	putIndentedStrLn i "{"
	putIndentedStrLn (i+1) "Conditional Expression:"
	putIndentedStrLn (i+1) "{"
	printExpression (i+2) e
	putIndentedStrLn (i+1) "}"
	putIndentedStrLn (i+1) "Loop Body:"
	putIndentedStrLn (i+1) "{"
	printStatement (i+2) s
	putIndentedStrLn (i+1) "}"
	putIndentedStrLn i "}"
printStatement i (StmExpression {seExp = Nothing}) = do
	putIndentedStrLn i "Expression Statement: (Empty)"
printStatement i (StmExpression {seExp = Just e}) = do
	putIndentedStrLn i "Expression Statement:"
	putIndentedStrLn i "{"
	printExpression (i+1) e
	putIndentedStrLn i "}"
printStatement i (StmReturn {srExp = Nothing}) = do
	putIndentedStrLn i "Return Statement: (Empty)"
printStatement i (StmReturn {srExp = Just e}) = do
	putIndentedStrLn i "Return Statement:"
	putIndentedStrLn i "{"
	printExpression (i+1) e
	putIndentedStrLn i "}"


printDeclarations :: Int -> [(Name, Maybe Expression)] -> IO ()
printDeclarations i [] = return ()
printDeclarations i ((id, Nothing):ds) = do
	putIndentedStrLn i "Declaration:"
	putIndentedStrLn i "{"
	putIndentedStrLn (i+1) $ "ID: " ++ id
	putIndentedStrLn (i+1) $ "(Uninitialised)"
	putIndentedStrLn i "}"
	printDeclarations i ds
printDeclarations i ((id, Just e):ds) = do
	putIndentedStrLn i "Declaration:"
	putIndentedStrLn i "{"
	putIndentedStrLn (i+1) $ "ID: " ++ id
	printExpression (i+1) e
	putIndentedStrLn i "}"
	printDeclarations i ds

printExpression :: Int -> Expression -> IO ()
printExpression i (ExpId {eiVal = id}) = do
	putIndentedStrLn i $ "ID: " ++ id
printExpression i (ExpIntLit {eilVal = il}) = do
	putIndentedStrLn i $ "Int Literal: " ++ (show il)
printExpression i (ExpCharLit {eclVal = cl}) = do
	putIndentedStrLn i $ "Char Literal: " ++ (show cl)
printExpression i (ExpBoolLit {eblVal = bl}) = do
	putIndentedStrLn i $ "Bool Literal: " ++ (show bl)
printExpression i (ExpAssign {saId = id, saExp = e}) = do
	putIndentedStrLn i "Assignment Expression:"
	putIndentedStrLn i "{"
	putIndentedStrLn (i+1) $ "ID: " ++ id
	printExpression (i+1) e
	putIndentedStrLn i "}"
printExpression i (ExpBinOpApp {arg1 = a1, arg2 = a2, op = o}) = do
	putIndentedStrLn i "Binary Operator Expression:"
	putIndentedStrLn i "{"
	putIndentedStrLn (i+1) "Argument 1:"
	putIndentedStrLn (i+1) "{"
	printExpression (i+2) a1
	putIndentedStrLn (i+1) "}"
	putIndentedStrLn (i+1) "Argument 2:"
	putIndentedStrLn (i+1) "{"
	printExpression (i+2) a2
	putIndentedStrLn (i+1) "}"
	putIndentedStrLn (i+1) $ "Operator: " ++ (show o)
	putIndentedStrLn i "}"
printExpression i (ExpCall {ecId = n, ecArgs = args}) = do
	putIndentedStrLn i "Function Call Expression:"
	putIndentedStrLn i "{"
	printExpression (i+1) n
	case args of
		[] -> putIndentedStrLn (i+1) "Arguments: (Empty)"
		es -> do
			putIndentedStrLn (i+1) "Arguments:"
			putIndentedStrLn (i+1) "{"
			printExpressions (i+2) es
			putIndentedStrLn (i+1) "}"
	putIndentedStrLn i "}"

printExpressions :: Int -> [Expression] -> IO ()
printExpressions _ [] = return ()
printExpressions i (e:es) = do
	printExpression i e
	printExpressions i es

printParams :: Int -> [(DataType, Name)] -> IO ()
printParams i [] = return ()
printParams i ((t, id):ps) = do
	putIndentedStrLn i "Parameter:"
	putIndentedStrLn i "{"
	printDataType (i+1) t
	putIndentedStrLn (i+1) $ "ID: " ++ id
	putIndentedStrLn i "}"
	printParams i ps

putIndentedStrLn :: Int -> String -> IO ()
putIndentedStrLn i s = putStrLn $ (replicate (i*4) ' ') ++ s
