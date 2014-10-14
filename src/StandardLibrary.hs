module StandardLibrary where

import MachineCode

--Any additions to this, must also be reflected in the inital
--environment within Checker.hs

stdLib :: String -> [Instruction]
stdLib "exit" =
	[LABEL "label_exit", HALT]
stdLib "printc" = [
		LABEL "label_printc",
		LOAD LB (-1),
		PRINTC,
		RETURN 0 1
	]
stdLib "printi" = [
		LABEL "label_printi",
		LOAD LB (-1),
		PRINTI,
		RETURN 0 1
	]
