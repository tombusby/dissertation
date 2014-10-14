module VirtualMachine where

import Data.Char (chr)
import Data.List (findIndices)
import MachineCode

-- Machine Internals

type MemValue = Int

data Machine =
	Machine {
		prog :: ([Instruction], [Instruction]),
		stack :: [MemValue],
		st :: Int,
		lb :: Int
	}
	deriving Show

-- Instruction Execution Functions

nextInst :: Machine -> (Maybe Instruction, Machine)
nextInst (Machine {prog = (ps, []), stack = s, st = st, lb = lb}) =
	(Nothing, Machine {prog = (ps, []), stack = s, st = st, lb = lb})
nextInst (Machine {prog = (ps, i:ns), stack = s, st = st, lb = lb}) =
	(Just i, (Machine {prog = (i:ps, ns), stack = s, st = st, lb = lb}))

pushValueToStack :: Int -> Machine -> Machine
pushValueToStack n (Machine {prog = (ps, ns), stack = s, st = st, lb = lb}) =
	Machine {prog = (ps, ns), stack = n:s, st = (st+1), lb = lb}

pushAddressToStack :: Register -> Int -> Machine -> Machine
pushAddressToStack r i m@(Machine {prog = (ps, ns), stack = s, st = st, lb = lb}) =
	Machine {prog = (ps, ns), stack = (calculateAddress r i m):s, st = (st+1), lb = lb}

retrieveValueAtAddress :: Register -> Int -> Machine -> Machine
retrieveValueAtAddress r i (Machine {prog = (ps, ns), stack = s, st = st, lb = lb}) =
	case r of
		SB -> (Machine {prog = (ps, ns), stack = (getStackElement s i):s, st = (st+1), lb = lb})
		LB -> (Machine {prog = (ps, ns), stack = (getStackElement s (i+lb)):s, st = (st+1), lb = lb})
		ST -> (Machine {prog = (ps, ns), stack = (getStackElement s (i+st)):s, st = (st+1), lb = lb})

getStackElement :: [MemValue] -> Int -> MemValue
getStackElement [] i =
	error "Error: There is nothing in memory to retrieve"
getStackElement s i | i < 0 =
	error "Error: Memory address evaluates to a negative number"
getStackElement s i | (length s - 1) < i =
	error $ "Error: There is no element at " ++ (show i)
getStackElement s i = s !! ((length s) - i - 1)

storeValueToAddress :: Register -> Int -> Machine -> Machine
storeValueToAddress r i (Machine {prog = (ps, ns), stack = s, st = st, lb = lb}) =
	case r of
		SB -> (Machine {prog = (ps, ns), stack = (storeValueAt s i), st = (st-1), lb = lb})
		LB -> (Machine {prog = (ps, ns), stack = (storeValueAt s (i+lb)), st = (st-1), lb = lb})
		ST -> (Machine {prog = (ps, ns), stack = (storeValueAt s (i+st)), st = (st-1), lb = lb})
	where
		storeValueAt :: [MemValue] -> Int -> [MemValue]
		storeValueAt [] _ =
			error "Error: There is no value to pop from the stack"
		storeValueAt s i | i < 0 =
			error "Error: Memory address evaluates to a negative number"
		storeValueAt ss i | (length ss - 1) < i =
			error $ "Error: There is no element at " ++ (show i)
		storeValueAt (s:ss) i =
			let (s1, _:s2) = splitAt ((length ss) - i - 1) ss in s1 ++ (s:s2)

performBinaryOperation :: (Int -> Int -> Int) -> Machine -> Machine
performBinaryOperation op (Machine {stack = []}) =
	error "Error: Stack is empty, cannot perform operation"
performBinaryOperation op (Machine {stack = s:[]}) =
	error "Error: Not enough items on the stack, cannot perform operation"
performBinaryOperation op (Machine {prog = (ps, ns), stack = s1:s2:ss, st = st, lb = lb}) =
	Machine {prog = (ps, ns), stack = (s1 `op` s2):ss, st = (st - 1), lb = lb}

popFromStack :: Int -> Int -> Machine -> Machine
popFromStack i j (Machine {prog = (ps, ns), stack = s, st = st, lb = lb})
	| length s < i + j =
		error "Error: POP operation would run off the bottom of the stack"
	| length s >= i + j =
		Machine {prog = (ps, ns), stack = s', st = st - j, lb = lb}
	where
		s' = let (fs, ss) = splitAt i s in fs ++ (drop j ss)

jumpTo :: Label -> Machine -> Machine
jumpTo l m@(Machine {prog = (ps, ns), stack = s, st = st, lb = lb})
	| numberMatches l m <  1 =
		error $ "Error: There is no label called " ++ l
	| numberMatches l m >  1 =
		error $ "Error: There is more than one label called " ++ l
	| numberMatches l m == 1 =
		(Machine {prog = (resetAtLabel l ((reverse ps) ++ ns)), stack = s, st = st, lb = lb})
	where
		numberMatches :: Label -> Machine -> Int
		numberMatches l (Machine {prog = (ps, ns)}) =
			length $ findIndices (labelMatch l) (ps ++ ns)

maybeJump :: Bool -> Label -> Machine -> Machine
maybeJump onzero l m@(Machine {stack = s}) =
	case s of
		[] -> error "Error: Stack is empty, cannot perform conditional jump"
		s:ss -> if onzero == (s == 0) then jumpTo l m else m

callFunction :: Label -> Machine -> Machine
callFunction l m@(Machine {prog = (ps, ns), st = st, lb = lb}) =
	let (Machine {prog = (ps', ns'), stack = s}) = jumpTo l m in
		Machine {prog = (ps', ns'), stack = (ra:dl:s), st = st + 2, lb = st + 1}
			where
				ra = length ps
				dl = lb

returnFromFunction :: Int -> Int -> Machine -> Machine
returnFromFunction r a m@(Machine {prog = (ps, ns), stack = s, st = st, lb = lb})
	| length s < 2+r+a  =
		error $ "Error: Not enough values on the stack to complete the RETURN"
	| length s >= 2+r+a =
		let dl = getStackElement s lb in let ra = getStackElement s (lb+1) in
			Machine
			{
				prog = resetAtRA ra (ps, ns),
				stack = removeArgs r a lb s,
				st = lb - a + r - 1,
				lb = dl
			}

resetAtRA :: Int -> ([Instruction], [Instruction]) -> ([Instruction], [Instruction])
resetAtRA ra (ps, ns) =
	let (ps', ns') = splitAt ra ((reverse ps) ++ ns) in (reverse ps', ns')

removeArgs :: Int -> Int -> Int -> [MemValue] -> [MemValue]
removeArgs returns args lb s =
	let (record, rest) = splitAt ((length s) - lb) s in
		((take returns record) ++ (drop args rest))




-- Control Flow Functions

runCode :: Bool -> [Instruction] -> IO ()
runCode t is = let m = initialiseMachine is in do
	putStrLn "Executing Compiled Code:"
	runMachine t m

runMachine :: Bool -> Machine -> IO ()
runMachine t m@(Machine {prog = (ps, ns), stack = s, st = st, lb = lb}) =
	let (i, m') = nextInst m in do
		maybePrint t $
			"Current Stack: " ++ (show s) ++ ", ST: " ++ (show st)
				++ ", LB: " ++ (show lb) ++ "\n"
		case i of
			Nothing -> putStrLn "Execution Complete"
			Just HALT -> putStrLn "Execution Terminated by HALT"
			Just (LABEL l) -> do
				maybePrint t $ "Label \"" ++ l ++  "\": (No Action)"
				runMachine t m'
			Just i' -> do
				maybePrint t $ "Next Instruction: " ++ (show i')
				executeInstruction t i' m'

executeInstruction :: Bool -> Instruction -> Machine -> IO ()
executeInstruction t (LOADL v) m =
	let m' = pushValueToStack v m in runMachine t m'
executeInstruction t (LOADA r i) m =
	let m' = pushAddressToStack r i m in runMachine t m'
executeInstruction t (LOAD r i) m =
	let m' = retrieveValueAtAddress r i m in runMachine t m'
executeInstruction t (STORE r i) m =
	let m' = storeValueToAddress r i m in runMachine t m'
executeInstruction t ADD m =
	let m' = performBinaryOperation (+) m in runMachine t m'
executeInstruction t SUB m =
	let m' = performBinaryOperation (-) m in runMachine t m'
executeInstruction t MULT m =
	let m' = performBinaryOperation (*) m in runMachine t m'
executeInstruction t DIV m =
	let m' = performBinaryOperation div m in runMachine t m'
executeInstruction t MOD m =
	let m' = performBinaryOperation mod m in runMachine t m'
executeInstruction t EQUALS m =
	let m' = performBinaryOperation numericEQ m in runMachine t m'
executeInstruction t NOT_EQ m =
	let m' = performBinaryOperation mod m in runMachine t m'
executeInstruction t OR m =
	let m' = performBinaryOperation (numericLogical (||)) m in runMachine t m'
executeInstruction t AND m =
	let m' = performBinaryOperation (numericLogical (&&)) m in runMachine t m'
executeInstruction t LESS_THAN m =
	let m' = performBinaryOperation numericLT m in runMachine t m'
executeInstruction t GREATER_THAN m =
	let m' = performBinaryOperation numericGT m in runMachine t m'
executeInstruction t LT_OR_EQ m =
	let m' = performBinaryOperation numericLTE m in runMachine t m'
executeInstruction t GT_OR_EQ m =
	let m' = performBinaryOperation numericGTE m in runMachine t m'
executeInstruction t (POP i j) m =
	let m' = popFromStack i j m in runMachine t m'
executeInstruction t (JUMP l) m =
	let m' = jumpTo l m in runMachine t m'
executeInstruction t (JUMPIFZ l) m =
	let m' = maybeJump True l m in runMachine t m'
executeInstruction t (JUMPIFNZ l) m =
	let m' = maybeJump False l m in runMachine t m'
executeInstruction t (CALL l) m =
	let m' = callFunction l m in runMachine t m'
executeInstruction t (RETURN i j) m =
	let m' = returnFromFunction i j m in runMachine t m'
executeInstruction t PRINTC (Machine {prog = (ps, ns), stack = s, st = st, lb = lb}) =
	case s of
		[] -> error "Error: Stack is empty, nothing to print"
		i:ss -> do
			putStr [chr i]
			runMachine t (Machine {prog = (ps, ns), stack = ss, st = st - 1, lb = lb})
executeInstruction t PRINTI (Machine {prog = (ps, ns), stack = s, st = st, lb = lb}) =
	case s of
		[] -> error "Error: Stack is empty, nothing to print"
		i:ss -> do
			putStr $ show i
			runMachine t (Machine {prog = (ps, ns), stack = ss, st = st - 1, lb = lb})

-- Misc Helper Functions

initialiseMachine :: [Instruction] -> Machine
initialiseMachine is = (Machine {prog = ([], is), stack = [], st = -1, lb = 0})

maybePrint :: Bool -> String -> IO ()
maybePrint t s = if t then putStrLn s else return ()

calculateAddress :: Register -> Int -> Machine -> Int
calculateAddress r i m = case r of SB -> i; LB -> (st m) + i; ST -> (st m) + i

labelMatch :: Label -> Instruction -> Bool
labelMatch l (LABEL s) = s == l
labelMatch _ _ = False

resetAtLabel :: Label -> [Instruction] -> ([Instruction], [Instruction])
resetAtLabel l is = let (ps, ns) = break (labelMatch l) is in (reverse ps, ns)

numericEQ :: Int -> Int -> Int
numericEQ x y = if x == y then 1 else 0

numericNEQ :: Int -> Int -> Int
numericNEQ x y = if x /= y then 1 else 0

numericLogical :: (Bool -> Bool -> Bool) -> Int -> Int -> Int
numericLogical o x y = if (x /= 0) `o` (y /= 0) then 1 else 0

numericGT :: Int -> Int -> Int
numericGT x y = if x > y then 1 else 0

numericLT :: Int -> Int -> Int
numericLT x y = if x < y then 1 else 0

numericGTE :: Int -> Int -> Int
numericGTE x y = if x >= y then 1 else 0

numericLTE :: Int -> Int -> Int
numericLTE x y = if x <= y then 1 else 0
