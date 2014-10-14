module Main where

import System.Environment(getArgs)
import System.Directory(doesFileExist)
import Data.Char
import Scanner(scan)
import Parser(parse)
import AST
import ShowAST
import Checker (check)
import CodeGenerator(generateCode)
import ShowCode
import VirtualMachine(runCode)

type Filename = String
type SourceCode = Filename
type Output = Filename
type PrintAST = Bool

data Exec
	= NoExec
	| ExecNoTrace
	| ExecWithTrace

defaults :: SourceCode -> (SourceCode, Output, PrintAST, Exec)
defaults s = (s, "a.out", False, NoExec)

main = do
	args <- getArgs
	case args of
		[] ->
			putStrLn "bcc inputFileName [ -o=filename | -Exec | \
					\-ExecTrace | -PrintAST]"
		(x:xs) -> do
			fileExists <- doesFileExist x
			if fileExists then do
				sourceCode <- readFile x
				processArgs sourceCode xs
			 else
				error $ "Error: " ++ x ++ " file doesn't exist"

processArgs :: String -> [String] -> IO ()
processArgs s ss = processArgs' (defaults s) ss

processArgs' :: (SourceCode, Output, PrintAST, Exec) -> [String] -> IO ()
processArgs' settings [] = compile settings
processArgs' (i, o, p, e) (arg:args) =
	case arg of
		('-':'o':'=':tail) ->
			processArgs' (i, tail, p, e) args
		"-Exec" ->
			processArgs' (i, o, p, ExecNoTrace) args
		"-ExecTrace" ->
			processArgs' (i, o, p, ExecWithTrace) args
		"-PrintAST" ->
			processArgs' (i, o, True, e) args
		otherwise ->
			error $ "Error: " ++ arg ++ " is not a valid argument"

compile :: (SourceCode, Output, PrintAST, Exec) -> IO ()
compile (i, o, p, e) = do
	ast <- scanparse i
	if p then printAST ast else return ()
	errors <- check ast
	if length errors > 0 then do
		putStrLn "Compilation Failed:\n"
		printErrors errors
	 else do
		code <- generateCode ast
		writeFile o $ showCode code
		case e of
			NoExec -> return ()
			ExecNoTrace -> runCode False code
			ExecWithTrace -> runCode True code

printErrors :: [String] -> IO ()
printErrors [] = return ()
printErrors (e:es) = do
	putStrLn $ e ++ "\n"
	printErrors es

scanparse :: String -> IO AST
scanparse = return . parse . scan

