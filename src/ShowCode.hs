module ShowCode where

import MachineCode

showCode :: [Instruction] -> String
showCode [] = []
showCode (i:is) = (show i) ++ "\n" ++ (showCode is)
