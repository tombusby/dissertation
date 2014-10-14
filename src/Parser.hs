{-# OPTIONS_GHC -w #-}
module Parser where

import Data.Char
import Token
import AST

-- parser produced by Happy Version 1.18.9

data HappyAbsSyn 
	= HappyTerminal (Token)
	| HappyErrorToken Int
	| HappyAbsSyn4 (AST)
	| HappyAbsSyn5 ([Definition])
	| HappyAbsSyn6 (Definition)
	| HappyAbsSyn9 ([(AST.Name, Maybe Expression)])
	| HappyAbsSyn10 ((AST.Name, Maybe Expression))
	| HappyAbsSyn12 (DataType)
	| HappyAbsSyn13 (Declarator)
	| HappyAbsSyn14 ([(DataType, AST.Name)])
	| HappyAbsSyn15 ((DataType, AST.Name))
	| HappyAbsSyn16 (Statement)
	| HappyAbsSyn17 ([Statement])
	| HappyAbsSyn23 (Expression)
	| HappyAbsSyn32 ([Expression])

{- to allow type-synonyms as our monads (likely
 - with explicitly-specified bind and return)
 - in Haskell98, it seems that with
 - /type M a = .../, then /(HappyReduction M)/
 - is not allowed.  But Happy is a
 - code-generator that can just substitute it.
type HappyReduction m = 
	   Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> m HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> m HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> m HappyAbsSyn
-}

action_0,
 action_1,
 action_2,
 action_3,
 action_4,
 action_5,
 action_6,
 action_7,
 action_8,
 action_9,
 action_10,
 action_11,
 action_12,
 action_13,
 action_14,
 action_15,
 action_16,
 action_17,
 action_18,
 action_19,
 action_20,
 action_21,
 action_22,
 action_23,
 action_24,
 action_25,
 action_26,
 action_27,
 action_28,
 action_29,
 action_30,
 action_31,
 action_32,
 action_33,
 action_34,
 action_35,
 action_36,
 action_37,
 action_38,
 action_39,
 action_40,
 action_41,
 action_42,
 action_43,
 action_44,
 action_45,
 action_46,
 action_47,
 action_48,
 action_49,
 action_50,
 action_51,
 action_52,
 action_53,
 action_54,
 action_55,
 action_56,
 action_57,
 action_58,
 action_59,
 action_60,
 action_61,
 action_62,
 action_63,
 action_64,
 action_65,
 action_66,
 action_67,
 action_68,
 action_69,
 action_70,
 action_71,
 action_72,
 action_73,
 action_74,
 action_75,
 action_76,
 action_77,
 action_78,
 action_79,
 action_80,
 action_81,
 action_82,
 action_83,
 action_84,
 action_85,
 action_86,
 action_87,
 action_88,
 action_89,
 action_90,
 action_91,
 action_92,
 action_93,
 action_94,
 action_95,
 action_96,
 action_97,
 action_98,
 action_99,
 action_100,
 action_101,
 action_102,
 action_103,
 action_104,
 action_105,
 action_106,
 action_107,
 action_108,
 action_109,
 action_110,
 action_111,
 action_112,
 action_113,
 action_114,
 action_115,
 action_116,
 action_117,
 action_118,
 action_119,
 action_120,
 action_121,
 action_122,
 action_123,
 action_124 :: () => Int -> ({-HappyReduction (HappyIdentity) = -}
	   Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (HappyIdentity) HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (HappyIdentity) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> (HappyIdentity) HappyAbsSyn)

happyReduce_1,
 happyReduce_2,
 happyReduce_3,
 happyReduce_4,
 happyReduce_5,
 happyReduce_6,
 happyReduce_7,
 happyReduce_8,
 happyReduce_9,
 happyReduce_10,
 happyReduce_11,
 happyReduce_12,
 happyReduce_13,
 happyReduce_14,
 happyReduce_15,
 happyReduce_16,
 happyReduce_17,
 happyReduce_18,
 happyReduce_19,
 happyReduce_20,
 happyReduce_21,
 happyReduce_22,
 happyReduce_23,
 happyReduce_24,
 happyReduce_25,
 happyReduce_26,
 happyReduce_27,
 happyReduce_28,
 happyReduce_29,
 happyReduce_30,
 happyReduce_31,
 happyReduce_32,
 happyReduce_33,
 happyReduce_34,
 happyReduce_35,
 happyReduce_36,
 happyReduce_37,
 happyReduce_38,
 happyReduce_39,
 happyReduce_40,
 happyReduce_41,
 happyReduce_42,
 happyReduce_43,
 happyReduce_44,
 happyReduce_45,
 happyReduce_46,
 happyReduce_47,
 happyReduce_48,
 happyReduce_49,
 happyReduce_50,
 happyReduce_51,
 happyReduce_52,
 happyReduce_53,
 happyReduce_54,
 happyReduce_55,
 happyReduce_56,
 happyReduce_57,
 happyReduce_58,
 happyReduce_59,
 happyReduce_60,
 happyReduce_61,
 happyReduce_62,
 happyReduce_63,
 happyReduce_64,
 happyReduce_65,
 happyReduce_66,
 happyReduce_67,
 happyReduce_68,
 happyReduce_69,
 happyReduce_70,
 happyReduce_71,
 happyReduce_72,
 happyReduce_73 :: () => ({-HappyReduction (HappyIdentity) = -}
	   Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (HappyIdentity) HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (HappyIdentity) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> (HappyIdentity) HappyAbsSyn)

action_0 (34) = happyShift action_8
action_0 (38) = happyShift action_9
action_0 (39) = happyShift action_10
action_0 (40) = happyShift action_11
action_0 (41) = happyShift action_12
action_0 (4) = happyGoto action_13
action_0 (5) = happyGoto action_2
action_0 (6) = happyGoto action_3
action_0 (7) = happyGoto action_4
action_0 (11) = happyGoto action_5
action_0 (12) = happyGoto action_6
action_0 (13) = happyGoto action_7
action_0 _ = happyFail

action_1 (34) = happyShift action_8
action_1 (38) = happyShift action_9
action_1 (39) = happyShift action_10
action_1 (40) = happyShift action_11
action_1 (41) = happyShift action_12
action_1 (5) = happyGoto action_2
action_1 (6) = happyGoto action_3
action_1 (7) = happyGoto action_4
action_1 (11) = happyGoto action_5
action_1 (12) = happyGoto action_6
action_1 (13) = happyGoto action_7
action_1 _ = happyFail

action_2 _ = happyReduce_1

action_3 (34) = happyShift action_8
action_3 (38) = happyShift action_9
action_3 (39) = happyShift action_10
action_3 (40) = happyShift action_11
action_3 (41) = happyShift action_12
action_3 (5) = happyGoto action_21
action_3 (6) = happyGoto action_3
action_3 (7) = happyGoto action_4
action_3 (11) = happyGoto action_5
action_3 (12) = happyGoto action_6
action_3 (13) = happyGoto action_7
action_3 _ = happyReduce_2

action_4 _ = happyReduce_5

action_5 _ = happyReduce_4

action_6 (34) = happyShift action_20
action_6 (9) = happyGoto action_17
action_6 (10) = happyGoto action_18
action_6 (13) = happyGoto action_19
action_6 _ = happyFail

action_7 (52) = happyShift action_16
action_7 (16) = happyGoto action_15
action_7 _ = happyFail

action_8 (50) = happyShift action_14
action_8 _ = happyFail

action_9 _ = happyReduce_16

action_10 _ = happyReduce_17

action_11 _ = happyReduce_18

action_12 _ = happyReduce_15

action_13 (75) = happyAccept
action_13 _ = happyFail

action_14 (38) = happyShift action_9
action_14 (39) = happyShift action_10
action_14 (40) = happyShift action_11
action_14 (41) = happyShift action_12
action_14 (51) = happyShift action_59
action_14 (12) = happyGoto action_56
action_14 (14) = happyGoto action_57
action_14 (15) = happyGoto action_58
action_14 _ = happyFail

action_15 _ = happyReduce_13

action_16 (34) = happyShift action_46
action_16 (35) = happyShift action_47
action_16 (36) = happyShift action_48
action_16 (37) = happyShift action_49
action_16 (38) = happyShift action_9
action_16 (39) = happyShift action_10
action_16 (40) = happyShift action_11
action_16 (41) = happyShift action_12
action_16 (42) = happyShift action_50
action_16 (45) = happyShift action_51
action_16 (49) = happyShift action_52
action_16 (50) = happyShift action_53
action_16 (52) = happyShift action_16
action_16 (53) = happyShift action_54
action_16 (59) = happyShift action_55
action_16 (7) = happyGoto action_26
action_16 (8) = happyGoto action_27
action_16 (12) = happyGoto action_28
action_16 (16) = happyGoto action_29
action_16 (17) = happyGoto action_30
action_16 (18) = happyGoto action_31
action_16 (19) = happyGoto action_32
action_16 (20) = happyGoto action_33
action_16 (21) = happyGoto action_34
action_16 (22) = happyGoto action_35
action_16 (23) = happyGoto action_36
action_16 (24) = happyGoto action_37
action_16 (25) = happyGoto action_38
action_16 (26) = happyGoto action_39
action_16 (27) = happyGoto action_40
action_16 (28) = happyGoto action_41
action_16 (29) = happyGoto action_42
action_16 (30) = happyGoto action_43
action_16 (31) = happyGoto action_44
action_16 (33) = happyGoto action_45
action_16 _ = happyFail

action_17 (59) = happyShift action_25
action_17 _ = happyFail

action_18 (56) = happyShift action_24
action_18 _ = happyReduce_9

action_19 (52) = happyShift action_16
action_19 (16) = happyGoto action_23
action_19 _ = happyFail

action_20 (50) = happyShift action_14
action_20 (69) = happyShift action_22
action_20 _ = happyReduce_11

action_21 _ = happyReduce_3

action_22 (34) = happyShift action_46
action_22 (35) = happyShift action_47
action_22 (36) = happyShift action_48
action_22 (37) = happyShift action_49
action_22 (50) = happyShift action_53
action_22 (23) = happyGoto action_91
action_22 (24) = happyGoto action_37
action_22 (25) = happyGoto action_38
action_22 (26) = happyGoto action_39
action_22 (27) = happyGoto action_40
action_22 (28) = happyGoto action_41
action_22 (29) = happyGoto action_42
action_22 (30) = happyGoto action_43
action_22 (31) = happyGoto action_44
action_22 (33) = happyGoto action_45
action_22 _ = happyFail

action_23 _ = happyReduce_14

action_24 (34) = happyShift action_86
action_24 (9) = happyGoto action_90
action_24 (10) = happyGoto action_18
action_24 _ = happyFail

action_25 _ = happyReduce_6

action_26 (38) = happyShift action_9
action_26 (39) = happyShift action_10
action_26 (40) = happyShift action_11
action_26 (41) = happyShift action_12
action_26 (7) = happyGoto action_26
action_26 (8) = happyGoto action_89
action_26 (12) = happyGoto action_28
action_26 _ = happyReduce_7

action_27 (34) = happyShift action_46
action_27 (35) = happyShift action_47
action_27 (36) = happyShift action_48
action_27 (37) = happyShift action_49
action_27 (42) = happyShift action_50
action_27 (45) = happyShift action_51
action_27 (49) = happyShift action_52
action_27 (50) = happyShift action_53
action_27 (52) = happyShift action_16
action_27 (53) = happyShift action_88
action_27 (59) = happyShift action_55
action_27 (16) = happyGoto action_29
action_27 (17) = happyGoto action_87
action_27 (18) = happyGoto action_31
action_27 (19) = happyGoto action_32
action_27 (20) = happyGoto action_33
action_27 (21) = happyGoto action_34
action_27 (22) = happyGoto action_35
action_27 (23) = happyGoto action_36
action_27 (24) = happyGoto action_37
action_27 (25) = happyGoto action_38
action_27 (26) = happyGoto action_39
action_27 (27) = happyGoto action_40
action_27 (28) = happyGoto action_41
action_27 (29) = happyGoto action_42
action_27 (30) = happyGoto action_43
action_27 (31) = happyGoto action_44
action_27 (33) = happyGoto action_45
action_27 _ = happyFail

action_28 (34) = happyShift action_86
action_28 (9) = happyGoto action_17
action_28 (10) = happyGoto action_18
action_28 _ = happyFail

action_29 _ = happyReduce_30

action_30 (53) = happyShift action_85
action_30 _ = happyFail

action_31 (34) = happyShift action_46
action_31 (35) = happyShift action_47
action_31 (36) = happyShift action_48
action_31 (37) = happyShift action_49
action_31 (42) = happyShift action_50
action_31 (45) = happyShift action_51
action_31 (49) = happyShift action_52
action_31 (50) = happyShift action_53
action_31 (52) = happyShift action_16
action_31 (59) = happyShift action_55
action_31 (16) = happyGoto action_29
action_31 (17) = happyGoto action_84
action_31 (18) = happyGoto action_31
action_31 (19) = happyGoto action_32
action_31 (20) = happyGoto action_33
action_31 (21) = happyGoto action_34
action_31 (22) = happyGoto action_35
action_31 (23) = happyGoto action_36
action_31 (24) = happyGoto action_37
action_31 (25) = happyGoto action_38
action_31 (26) = happyGoto action_39
action_31 (27) = happyGoto action_40
action_31 (28) = happyGoto action_41
action_31 (29) = happyGoto action_42
action_31 (30) = happyGoto action_43
action_31 (31) = happyGoto action_44
action_31 (33) = happyGoto action_45
action_31 _ = happyReduce_28

action_32 _ = happyReduce_34

action_33 _ = happyReduce_31

action_34 _ = happyReduce_32

action_35 _ = happyReduce_33

action_36 (59) = happyShift action_83
action_36 _ = happyFail

action_37 _ = happyReduce_42

action_38 (68) = happyShift action_82
action_38 _ = happyReduce_43

action_39 (67) = happyShift action_81
action_39 _ = happyReduce_45

action_40 (61) = happyShift action_79
action_40 (62) = happyShift action_80
action_40 _ = happyReduce_47

action_41 (63) = happyShift action_75
action_41 (64) = happyShift action_76
action_41 (65) = happyShift action_77
action_41 (66) = happyShift action_78
action_41 _ = happyReduce_49

action_42 (72) = happyShift action_73
action_42 (73) = happyShift action_74
action_42 _ = happyReduce_52

action_43 (70) = happyShift action_70
action_43 (71) = happyShift action_71
action_43 (74) = happyShift action_72
action_43 _ = happyReduce_57

action_44 (50) = happyShift action_69
action_44 _ = happyReduce_60

action_45 _ = happyReduce_64

action_46 (69) = happyShift action_68
action_46 _ = happyReduce_69

action_47 _ = happyReduce_70

action_48 _ = happyReduce_71

action_49 _ = happyReduce_72

action_50 (50) = happyShift action_67
action_50 _ = happyFail

action_51 (50) = happyShift action_66
action_51 _ = happyFail

action_52 (34) = happyShift action_46
action_52 (35) = happyShift action_47
action_52 (36) = happyShift action_48
action_52 (37) = happyShift action_49
action_52 (50) = happyShift action_53
action_52 (59) = happyShift action_65
action_52 (23) = happyGoto action_64
action_52 (24) = happyGoto action_37
action_52 (25) = happyGoto action_38
action_52 (26) = happyGoto action_39
action_52 (27) = happyGoto action_40
action_52 (28) = happyGoto action_41
action_52 (29) = happyGoto action_42
action_52 (30) = happyGoto action_43
action_52 (31) = happyGoto action_44
action_52 (33) = happyGoto action_45
action_52 _ = happyFail

action_53 (34) = happyShift action_46
action_53 (35) = happyShift action_47
action_53 (36) = happyShift action_48
action_53 (37) = happyShift action_49
action_53 (50) = happyShift action_53
action_53 (23) = happyGoto action_63
action_53 (24) = happyGoto action_37
action_53 (25) = happyGoto action_38
action_53 (26) = happyGoto action_39
action_53 (27) = happyGoto action_40
action_53 (28) = happyGoto action_41
action_53 (29) = happyGoto action_42
action_53 (30) = happyGoto action_43
action_53 (31) = happyGoto action_44
action_53 (33) = happyGoto action_45
action_53 _ = happyFail

action_54 _ = happyReduce_24

action_55 _ = happyReduce_40

action_56 (34) = happyShift action_62
action_56 _ = happyFail

action_57 (51) = happyShift action_61
action_57 _ = happyFail

action_58 (56) = happyShift action_60
action_58 _ = happyReduce_21

action_59 _ = happyReduce_19

action_60 (38) = happyShift action_9
action_60 (39) = happyShift action_10
action_60 (40) = happyShift action_11
action_60 (41) = happyShift action_12
action_60 (12) = happyGoto action_56
action_60 (14) = happyGoto action_115
action_60 (15) = happyGoto action_58
action_60 _ = happyFail

action_61 _ = happyReduce_20

action_62 _ = happyReduce_23

action_63 (51) = happyShift action_114
action_63 _ = happyFail

action_64 (59) = happyShift action_113
action_64 _ = happyFail

action_65 _ = happyReduce_35

action_66 (34) = happyShift action_46
action_66 (35) = happyShift action_47
action_66 (36) = happyShift action_48
action_66 (37) = happyShift action_49
action_66 (50) = happyShift action_53
action_66 (23) = happyGoto action_112
action_66 (24) = happyGoto action_37
action_66 (25) = happyGoto action_38
action_66 (26) = happyGoto action_39
action_66 (27) = happyGoto action_40
action_66 (28) = happyGoto action_41
action_66 (29) = happyGoto action_42
action_66 (30) = happyGoto action_43
action_66 (31) = happyGoto action_44
action_66 (33) = happyGoto action_45
action_66 _ = happyFail

action_67 (34) = happyShift action_46
action_67 (35) = happyShift action_47
action_67 (36) = happyShift action_48
action_67 (37) = happyShift action_49
action_67 (50) = happyShift action_53
action_67 (23) = happyGoto action_111
action_67 (24) = happyGoto action_37
action_67 (25) = happyGoto action_38
action_67 (26) = happyGoto action_39
action_67 (27) = happyGoto action_40
action_67 (28) = happyGoto action_41
action_67 (29) = happyGoto action_42
action_67 (30) = happyGoto action_43
action_67 (31) = happyGoto action_44
action_67 (33) = happyGoto action_45
action_67 _ = happyFail

action_68 (34) = happyShift action_46
action_68 (35) = happyShift action_47
action_68 (36) = happyShift action_48
action_68 (37) = happyShift action_49
action_68 (50) = happyShift action_53
action_68 (24) = happyGoto action_110
action_68 (25) = happyGoto action_38
action_68 (26) = happyGoto action_39
action_68 (27) = happyGoto action_40
action_68 (28) = happyGoto action_41
action_68 (29) = happyGoto action_42
action_68 (30) = happyGoto action_43
action_68 (31) = happyGoto action_44
action_68 (33) = happyGoto action_45
action_68 _ = happyFail

action_69 (34) = happyShift action_46
action_69 (35) = happyShift action_47
action_69 (36) = happyShift action_48
action_69 (37) = happyShift action_49
action_69 (50) = happyShift action_53
action_69 (51) = happyShift action_109
action_69 (23) = happyGoto action_107
action_69 (24) = happyGoto action_37
action_69 (25) = happyGoto action_38
action_69 (26) = happyGoto action_39
action_69 (27) = happyGoto action_40
action_69 (28) = happyGoto action_41
action_69 (29) = happyGoto action_42
action_69 (30) = happyGoto action_43
action_69 (31) = happyGoto action_44
action_69 (32) = happyGoto action_108
action_69 (33) = happyGoto action_45
action_69 _ = happyFail

action_70 (34) = happyShift action_94
action_70 (35) = happyShift action_47
action_70 (36) = happyShift action_48
action_70 (37) = happyShift action_49
action_70 (50) = happyShift action_53
action_70 (31) = happyGoto action_106
action_70 (33) = happyGoto action_45
action_70 _ = happyFail

action_71 (34) = happyShift action_94
action_71 (35) = happyShift action_47
action_71 (36) = happyShift action_48
action_71 (37) = happyShift action_49
action_71 (50) = happyShift action_53
action_71 (31) = happyGoto action_105
action_71 (33) = happyGoto action_45
action_71 _ = happyFail

action_72 (34) = happyShift action_94
action_72 (35) = happyShift action_47
action_72 (36) = happyShift action_48
action_72 (37) = happyShift action_49
action_72 (50) = happyShift action_53
action_72 (31) = happyGoto action_104
action_72 (33) = happyGoto action_45
action_72 _ = happyFail

action_73 (34) = happyShift action_94
action_73 (35) = happyShift action_47
action_73 (36) = happyShift action_48
action_73 (37) = happyShift action_49
action_73 (50) = happyShift action_53
action_73 (30) = happyGoto action_103
action_73 (31) = happyGoto action_44
action_73 (33) = happyGoto action_45
action_73 _ = happyFail

action_74 (34) = happyShift action_94
action_74 (35) = happyShift action_47
action_74 (36) = happyShift action_48
action_74 (37) = happyShift action_49
action_74 (50) = happyShift action_53
action_74 (30) = happyGoto action_102
action_74 (31) = happyGoto action_44
action_74 (33) = happyGoto action_45
action_74 _ = happyFail

action_75 (34) = happyShift action_94
action_75 (35) = happyShift action_47
action_75 (36) = happyShift action_48
action_75 (37) = happyShift action_49
action_75 (50) = happyShift action_53
action_75 (29) = happyGoto action_101
action_75 (30) = happyGoto action_43
action_75 (31) = happyGoto action_44
action_75 (33) = happyGoto action_45
action_75 _ = happyFail

action_76 (34) = happyShift action_94
action_76 (35) = happyShift action_47
action_76 (36) = happyShift action_48
action_76 (37) = happyShift action_49
action_76 (50) = happyShift action_53
action_76 (29) = happyGoto action_100
action_76 (30) = happyGoto action_43
action_76 (31) = happyGoto action_44
action_76 (33) = happyGoto action_45
action_76 _ = happyFail

action_77 (34) = happyShift action_94
action_77 (35) = happyShift action_47
action_77 (36) = happyShift action_48
action_77 (37) = happyShift action_49
action_77 (50) = happyShift action_53
action_77 (29) = happyGoto action_99
action_77 (30) = happyGoto action_43
action_77 (31) = happyGoto action_44
action_77 (33) = happyGoto action_45
action_77 _ = happyFail

action_78 (34) = happyShift action_94
action_78 (35) = happyShift action_47
action_78 (36) = happyShift action_48
action_78 (37) = happyShift action_49
action_78 (50) = happyShift action_53
action_78 (29) = happyGoto action_98
action_78 (30) = happyGoto action_43
action_78 (31) = happyGoto action_44
action_78 (33) = happyGoto action_45
action_78 _ = happyFail

action_79 (34) = happyShift action_94
action_79 (35) = happyShift action_47
action_79 (36) = happyShift action_48
action_79 (37) = happyShift action_49
action_79 (50) = happyShift action_53
action_79 (28) = happyGoto action_97
action_79 (29) = happyGoto action_42
action_79 (30) = happyGoto action_43
action_79 (31) = happyGoto action_44
action_79 (33) = happyGoto action_45
action_79 _ = happyFail

action_80 (34) = happyShift action_94
action_80 (35) = happyShift action_47
action_80 (36) = happyShift action_48
action_80 (37) = happyShift action_49
action_80 (50) = happyShift action_53
action_80 (28) = happyGoto action_96
action_80 (29) = happyGoto action_42
action_80 (30) = happyGoto action_43
action_80 (31) = happyGoto action_44
action_80 (33) = happyGoto action_45
action_80 _ = happyFail

action_81 (34) = happyShift action_94
action_81 (35) = happyShift action_47
action_81 (36) = happyShift action_48
action_81 (37) = happyShift action_49
action_81 (50) = happyShift action_53
action_81 (27) = happyGoto action_95
action_81 (28) = happyGoto action_41
action_81 (29) = happyGoto action_42
action_81 (30) = happyGoto action_43
action_81 (31) = happyGoto action_44
action_81 (33) = happyGoto action_45
action_81 _ = happyFail

action_82 (34) = happyShift action_94
action_82 (35) = happyShift action_47
action_82 (36) = happyShift action_48
action_82 (37) = happyShift action_49
action_82 (50) = happyShift action_53
action_82 (26) = happyGoto action_93
action_82 (27) = happyGoto action_40
action_82 (28) = happyGoto action_41
action_82 (29) = happyGoto action_42
action_82 (30) = happyGoto action_43
action_82 (31) = happyGoto action_44
action_82 (33) = happyGoto action_45
action_82 _ = happyFail

action_83 _ = happyReduce_41

action_84 _ = happyReduce_29

action_85 _ = happyReduce_25

action_86 (69) = happyShift action_22
action_86 _ = happyReduce_11

action_87 (53) = happyShift action_92
action_87 _ = happyFail

action_88 _ = happyReduce_26

action_89 _ = happyReduce_8

action_90 _ = happyReduce_10

action_91 _ = happyReduce_12

action_92 _ = happyReduce_27

action_93 (67) = happyShift action_81
action_93 _ = happyReduce_46

action_94 _ = happyReduce_69

action_95 (61) = happyShift action_79
action_95 (62) = happyShift action_80
action_95 _ = happyReduce_48

action_96 (63) = happyShift action_75
action_96 (64) = happyShift action_76
action_96 (65) = happyShift action_77
action_96 (66) = happyShift action_78
action_96 _ = happyReduce_51

action_97 (63) = happyShift action_75
action_97 (64) = happyShift action_76
action_97 (65) = happyShift action_77
action_97 (66) = happyShift action_78
action_97 _ = happyReduce_50

action_98 (72) = happyShift action_73
action_98 (73) = happyShift action_74
action_98 _ = happyReduce_53

action_99 (72) = happyShift action_73
action_99 (73) = happyShift action_74
action_99 _ = happyReduce_54

action_100 (72) = happyShift action_73
action_100 (73) = happyShift action_74
action_100 _ = happyReduce_55

action_101 (72) = happyShift action_73
action_101 (73) = happyShift action_74
action_101 _ = happyReduce_56

action_102 (70) = happyShift action_70
action_102 (71) = happyShift action_71
action_102 (74) = happyShift action_72
action_102 _ = happyReduce_59

action_103 (70) = happyShift action_70
action_103 (71) = happyShift action_71
action_103 (74) = happyShift action_72
action_103 _ = happyReduce_58

action_104 (50) = happyShift action_69
action_104 _ = happyReduce_63

action_105 (50) = happyShift action_69
action_105 _ = happyReduce_61

action_106 (50) = happyShift action_69
action_106 _ = happyReduce_62

action_107 (56) = happyShift action_119
action_107 _ = happyReduce_67

action_108 (51) = happyShift action_118
action_108 _ = happyFail

action_109 _ = happyReduce_65

action_110 _ = happyReduce_44

action_111 (51) = happyShift action_117
action_111 _ = happyFail

action_112 (51) = happyShift action_116
action_112 _ = happyFail

action_113 _ = happyReduce_36

action_114 _ = happyReduce_73

action_115 _ = happyReduce_22

action_116 (34) = happyShift action_46
action_116 (35) = happyShift action_47
action_116 (36) = happyShift action_48
action_116 (37) = happyShift action_49
action_116 (42) = happyShift action_50
action_116 (45) = happyShift action_51
action_116 (49) = happyShift action_52
action_116 (50) = happyShift action_53
action_116 (52) = happyShift action_16
action_116 (59) = happyShift action_55
action_116 (16) = happyGoto action_29
action_116 (18) = happyGoto action_122
action_116 (19) = happyGoto action_32
action_116 (20) = happyGoto action_33
action_116 (21) = happyGoto action_34
action_116 (22) = happyGoto action_35
action_116 (23) = happyGoto action_36
action_116 (24) = happyGoto action_37
action_116 (25) = happyGoto action_38
action_116 (26) = happyGoto action_39
action_116 (27) = happyGoto action_40
action_116 (28) = happyGoto action_41
action_116 (29) = happyGoto action_42
action_116 (30) = happyGoto action_43
action_116 (31) = happyGoto action_44
action_116 (33) = happyGoto action_45
action_116 _ = happyFail

action_117 (34) = happyShift action_46
action_117 (35) = happyShift action_47
action_117 (36) = happyShift action_48
action_117 (37) = happyShift action_49
action_117 (42) = happyShift action_50
action_117 (45) = happyShift action_51
action_117 (49) = happyShift action_52
action_117 (50) = happyShift action_53
action_117 (52) = happyShift action_16
action_117 (59) = happyShift action_55
action_117 (16) = happyGoto action_29
action_117 (18) = happyGoto action_121
action_117 (19) = happyGoto action_32
action_117 (20) = happyGoto action_33
action_117 (21) = happyGoto action_34
action_117 (22) = happyGoto action_35
action_117 (23) = happyGoto action_36
action_117 (24) = happyGoto action_37
action_117 (25) = happyGoto action_38
action_117 (26) = happyGoto action_39
action_117 (27) = happyGoto action_40
action_117 (28) = happyGoto action_41
action_117 (29) = happyGoto action_42
action_117 (30) = happyGoto action_43
action_117 (31) = happyGoto action_44
action_117 (33) = happyGoto action_45
action_117 _ = happyFail

action_118 _ = happyReduce_66

action_119 (34) = happyShift action_46
action_119 (35) = happyShift action_47
action_119 (36) = happyShift action_48
action_119 (37) = happyShift action_49
action_119 (50) = happyShift action_53
action_119 (23) = happyGoto action_107
action_119 (24) = happyGoto action_37
action_119 (25) = happyGoto action_38
action_119 (26) = happyGoto action_39
action_119 (27) = happyGoto action_40
action_119 (28) = happyGoto action_41
action_119 (29) = happyGoto action_42
action_119 (30) = happyGoto action_43
action_119 (31) = happyGoto action_44
action_119 (32) = happyGoto action_120
action_119 (33) = happyGoto action_45
action_119 _ = happyFail

action_120 _ = happyReduce_68

action_121 (43) = happyShift action_123
action_121 _ = happyReduce_37

action_122 _ = happyReduce_39

action_123 (34) = happyShift action_46
action_123 (35) = happyShift action_47
action_123 (36) = happyShift action_48
action_123 (37) = happyShift action_49
action_123 (42) = happyShift action_50
action_123 (45) = happyShift action_51
action_123 (49) = happyShift action_52
action_123 (50) = happyShift action_53
action_123 (52) = happyShift action_16
action_123 (59) = happyShift action_55
action_123 (16) = happyGoto action_29
action_123 (18) = happyGoto action_124
action_123 (19) = happyGoto action_32
action_123 (20) = happyGoto action_33
action_123 (21) = happyGoto action_34
action_123 (22) = happyGoto action_35
action_123 (23) = happyGoto action_36
action_123 (24) = happyGoto action_37
action_123 (25) = happyGoto action_38
action_123 (26) = happyGoto action_39
action_123 (27) = happyGoto action_40
action_123 (28) = happyGoto action_41
action_123 (29) = happyGoto action_42
action_123 (30) = happyGoto action_43
action_123 (31) = happyGoto action_44
action_123 (33) = happyGoto action_45
action_123 _ = happyFail

action_124 _ = happyReduce_38

happyReduce_1 = happySpecReduce_1  4 happyReduction_1
happyReduction_1 (HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn4
		 (AST happy_var_1
	)
happyReduction_1 _  = notHappyAtAll 

happyReduce_2 = happySpecReduce_1  5 happyReduction_2
happyReduction_2 (HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn5
		 ([happy_var_1]
	)
happyReduction_2 _  = notHappyAtAll 

happyReduce_3 = happySpecReduce_2  5 happyReduction_3
happyReduction_3 (HappyAbsSyn5  happy_var_2)
	(HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn5
		 (happy_var_1 : happy_var_2
	)
happyReduction_3 _ _  = notHappyAtAll 

happyReduce_4 = happySpecReduce_1  6 happyReduction_4
happyReduction_4 (HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn6
		 (happy_var_1
	)
happyReduction_4 _  = notHappyAtAll 

happyReduce_5 = happySpecReduce_1  6 happyReduction_5
happyReduction_5 (HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn6
		 (happy_var_1
	)
happyReduction_5 _  = notHappyAtAll 

happyReduce_6 = happySpecReduce_3  7 happyReduction_6
happyReduction_6 _
	(HappyAbsSyn9  happy_var_2)
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn6
		 (DefDeclaration { ddType = happy_var_1, ddDeclarations = happy_var_2 }
	)
happyReduction_6 _ _ _  = notHappyAtAll 

happyReduce_7 = happySpecReduce_1  8 happyReduction_7
happyReduction_7 (HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn5
		 ([happy_var_1]
	)
happyReduction_7 _  = notHappyAtAll 

happyReduce_8 = happySpecReduce_2  8 happyReduction_8
happyReduction_8 (HappyAbsSyn5  happy_var_2)
	(HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn5
		 (happy_var_1 : happy_var_2
	)
happyReduction_8 _ _  = notHappyAtAll 

happyReduce_9 = happySpecReduce_1  9 happyReduction_9
happyReduction_9 (HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn9
		 ([happy_var_1]
	)
happyReduction_9 _  = notHappyAtAll 

happyReduce_10 = happySpecReduce_3  9 happyReduction_10
happyReduction_10 (HappyAbsSyn9  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn9
		 (happy_var_1 : happy_var_3
	)
happyReduction_10 _ _ _  = notHappyAtAll 

happyReduce_11 = happySpecReduce_1  10 happyReduction_11
happyReduction_11 (HappyTerminal (T_Id happy_var_1))
	 =  HappyAbsSyn10
		 ((happy_var_1, Nothing)
	)
happyReduction_11 _  = notHappyAtAll 

happyReduce_12 = happySpecReduce_3  10 happyReduction_12
happyReduction_12 (HappyAbsSyn23  happy_var_3)
	_
	(HappyTerminal (T_Id happy_var_1))
	 =  HappyAbsSyn10
		 ((happy_var_1, Just happy_var_3)
	)
happyReduction_12 _ _ _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_2  11 happyReduction_13
happyReduction_13 (HappyAbsSyn16  happy_var_2)
	(HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn6
		 (DefFunction
		{
			dfType = VoidType,
			dfDeclarator = happy_var_1,
			dfStatement = happy_var_2
		}
	)
happyReduction_13 _ _  = notHappyAtAll 

happyReduce_14 = happySpecReduce_3  11 happyReduction_14
happyReduction_14 (HappyAbsSyn16  happy_var_3)
	(HappyAbsSyn13  happy_var_2)
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn6
		 (DefFunction
		{
			dfType = happy_var_1,
			dfDeclarator = happy_var_2,
			dfStatement = happy_var_3
		}
	)
happyReduction_14 _ _ _  = notHappyAtAll 

happyReduce_15 = happySpecReduce_1  12 happyReduction_15
happyReduction_15 _
	 =  HappyAbsSyn12
		 (VoidType
	)

happyReduce_16 = happySpecReduce_1  12 happyReduction_16
happyReduction_16 _
	 =  HappyAbsSyn12
		 (IntType
	)

happyReduce_17 = happySpecReduce_1  12 happyReduction_17
happyReduction_17 _
	 =  HappyAbsSyn12
		 (CharType
	)

happyReduce_18 = happySpecReduce_1  12 happyReduction_18
happyReduction_18 _
	 =  HappyAbsSyn12
		 (BoolType
	)

happyReduce_19 = happySpecReduce_3  13 happyReduction_19
happyReduction_19 _
	_
	(HappyTerminal (T_Id happy_var_1))
	 =  HappyAbsSyn13
		 (DeclFunction
		{
			dfId = happy_var_1,
			dfParams = []
		}
	)
happyReduction_19 _ _ _  = notHappyAtAll 

happyReduce_20 = happyReduce 4 13 happyReduction_20
happyReduction_20 (_ `HappyStk`
	(HappyAbsSyn14  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (T_Id happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn13
		 (DeclFunction
		{
			dfId = happy_var_1,
			dfParams = happy_var_3
		}
	) `HappyStk` happyRest

happyReduce_21 = happySpecReduce_1  14 happyReduction_21
happyReduction_21 (HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn14
		 ([happy_var_1]
	)
happyReduction_21 _  = notHappyAtAll 

happyReduce_22 = happySpecReduce_3  14 happyReduction_22
happyReduction_22 (HappyAbsSyn14  happy_var_3)
	_
	(HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn14
		 (happy_var_1 : happy_var_3
	)
happyReduction_22 _ _ _  = notHappyAtAll 

happyReduce_23 = happySpecReduce_2  15 happyReduction_23
happyReduction_23 (HappyTerminal (T_Id happy_var_2))
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn15
		 ((happy_var_1, happy_var_2)
	)
happyReduction_23 _ _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_2  16 happyReduction_24
happyReduction_24 _
	_
	 =  HappyAbsSyn16
		 (StmCompound { scDecls = [], scStms = [] }
	)

happyReduce_25 = happySpecReduce_3  16 happyReduction_25
happyReduction_25 _
	(HappyAbsSyn17  happy_var_2)
	_
	 =  HappyAbsSyn16
		 (StmCompound { scDecls = [], scStms = happy_var_2 }
	)
happyReduction_25 _ _ _  = notHappyAtAll 

happyReduce_26 = happySpecReduce_3  16 happyReduction_26
happyReduction_26 _
	(HappyAbsSyn5  happy_var_2)
	_
	 =  HappyAbsSyn16
		 (StmCompound { scDecls = happy_var_2, scStms = [] }
	)
happyReduction_26 _ _ _  = notHappyAtAll 

happyReduce_27 = happyReduce 4 16 happyReduction_27
happyReduction_27 (_ `HappyStk`
	(HappyAbsSyn17  happy_var_3) `HappyStk`
	(HappyAbsSyn5  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn16
		 (StmCompound { scDecls = happy_var_2, scStms = happy_var_3 }
	) `HappyStk` happyRest

happyReduce_28 = happySpecReduce_1  17 happyReduction_28
happyReduction_28 (HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn17
		 ([happy_var_1]
	)
happyReduction_28 _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_2  17 happyReduction_29
happyReduction_29 (HappyAbsSyn17  happy_var_2)
	(HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn17
		 (happy_var_1 : happy_var_2
	)
happyReduction_29 _ _  = notHappyAtAll 

happyReduce_30 = happySpecReduce_1  18 happyReduction_30
happyReduction_30 (HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn16
		 (happy_var_1
	)
happyReduction_30 _  = notHappyAtAll 

happyReduce_31 = happySpecReduce_1  18 happyReduction_31
happyReduction_31 (HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn16
		 (happy_var_1
	)
happyReduction_31 _  = notHappyAtAll 

happyReduce_32 = happySpecReduce_1  18 happyReduction_32
happyReduction_32 (HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn16
		 (happy_var_1
	)
happyReduction_32 _  = notHappyAtAll 

happyReduce_33 = happySpecReduce_1  18 happyReduction_33
happyReduction_33 (HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn16
		 (happy_var_1
	)
happyReduction_33 _  = notHappyAtAll 

happyReduce_34 = happySpecReduce_1  18 happyReduction_34
happyReduction_34 (HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn16
		 (happy_var_1
	)
happyReduction_34 _  = notHappyAtAll 

happyReduce_35 = happySpecReduce_2  19 happyReduction_35
happyReduction_35 _
	_
	 =  HappyAbsSyn16
		 (StmReturn { srExp = Nothing }
	)

happyReduce_36 = happySpecReduce_3  19 happyReduction_36
happyReduction_36 _
	(HappyAbsSyn23  happy_var_2)
	_
	 =  HappyAbsSyn16
		 (StmReturn { srExp = Just happy_var_2 }
	)
happyReduction_36 _ _ _  = notHappyAtAll 

happyReduce_37 = happyReduce 5 20 happyReduction_37
happyReduction_37 ((HappyAbsSyn16  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn23  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn16
		 (StmIf {siCond = happy_var_3, siThen = happy_var_5, siElse = Nothing}
	) `HappyStk` happyRest

happyReduce_38 = happyReduce 7 20 happyReduction_38
happyReduction_38 ((HappyAbsSyn16  happy_var_7) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn16  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn23  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn16
		 (StmIf {siCond = happy_var_3, siThen = happy_var_5, siElse = Just happy_var_7}
	) `HappyStk` happyRest

happyReduce_39 = happyReduce 5 21 happyReduction_39
happyReduction_39 ((HappyAbsSyn16  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn23  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn16
		 (StmWhile {swExp = happy_var_3, swStm = happy_var_5}
	) `HappyStk` happyRest

happyReduce_40 = happySpecReduce_1  22 happyReduction_40
happyReduction_40 _
	 =  HappyAbsSyn16
		 (StmExpression { seExp = Nothing }
	)

happyReduce_41 = happySpecReduce_2  22 happyReduction_41
happyReduction_41 _
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn16
		 (StmExpression { seExp = Just happy_var_1 }
	)
happyReduction_41 _ _  = notHappyAtAll 

happyReduce_42 = happySpecReduce_1  23 happyReduction_42
happyReduction_42 (HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 (happy_var_1
	)
happyReduction_42 _  = notHappyAtAll 

happyReduce_43 = happySpecReduce_1  24 happyReduction_43
happyReduction_43 (HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 (happy_var_1
	)
happyReduction_43 _  = notHappyAtAll 

happyReduce_44 = happySpecReduce_3  24 happyReduction_44
happyReduction_44 (HappyAbsSyn23  happy_var_3)
	_
	(HappyTerminal (T_Id happy_var_1))
	 =  HappyAbsSyn23
		 (ExpAssign { saId = happy_var_1, saExp = happy_var_3 }
	)
happyReduction_44 _ _ _  = notHappyAtAll 

happyReduce_45 = happySpecReduce_1  25 happyReduction_45
happyReduction_45 (HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 (happy_var_1
	)
happyReduction_45 _  = notHappyAtAll 

happyReduce_46 = happySpecReduce_3  25 happyReduction_46
happyReduction_46 (HappyAbsSyn23  happy_var_3)
	_
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 (ExpBinOpApp {arg1 = happy_var_1, arg2 = happy_var_3, op = Or}
	)
happyReduction_46 _ _ _  = notHappyAtAll 

happyReduce_47 = happySpecReduce_1  26 happyReduction_47
happyReduction_47 (HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 (happy_var_1
	)
happyReduction_47 _  = notHappyAtAll 

happyReduce_48 = happySpecReduce_3  26 happyReduction_48
happyReduction_48 (HappyAbsSyn23  happy_var_3)
	_
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 (ExpBinOpApp {arg1 = happy_var_1, arg2 = happy_var_3, op = And}
	)
happyReduction_48 _ _ _  = notHappyAtAll 

happyReduce_49 = happySpecReduce_1  27 happyReduction_49
happyReduction_49 (HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 (happy_var_1
	)
happyReduction_49 _  = notHappyAtAll 

happyReduce_50 = happySpecReduce_3  27 happyReduction_50
happyReduction_50 (HappyAbsSyn23  happy_var_3)
	_
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 (ExpBinOpApp {arg1 = happy_var_1, arg2 = happy_var_3, op = Eq}
	)
happyReduction_50 _ _ _  = notHappyAtAll 

happyReduce_51 = happySpecReduce_3  27 happyReduction_51
happyReduction_51 (HappyAbsSyn23  happy_var_3)
	_
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 (ExpBinOpApp {arg1 = happy_var_1, arg2 = happy_var_3, op = NotEq}
	)
happyReduction_51 _ _ _  = notHappyAtAll 

happyReduce_52 = happySpecReduce_1  28 happyReduction_52
happyReduction_52 (HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 (happy_var_1
	)
happyReduction_52 _  = notHappyAtAll 

happyReduce_53 = happySpecReduce_3  28 happyReduction_53
happyReduction_53 (HappyAbsSyn23  happy_var_3)
	_
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 (ExpBinOpApp {arg1 = happy_var_1, arg2 = happy_var_3, op = AST.LT}
	)
happyReduction_53 _ _ _  = notHappyAtAll 

happyReduce_54 = happySpecReduce_3  28 happyReduction_54
happyReduction_54 (HappyAbsSyn23  happy_var_3)
	_
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 (ExpBinOpApp {arg1 = happy_var_1, arg2 = happy_var_3, op = AST.GT}
	)
happyReduction_54 _ _ _  = notHappyAtAll 

happyReduce_55 = happySpecReduce_3  28 happyReduction_55
happyReduction_55 (HappyAbsSyn23  happy_var_3)
	_
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 (ExpBinOpApp {arg1 = happy_var_1, arg2 = happy_var_3, op = LTE}
	)
happyReduction_55 _ _ _  = notHappyAtAll 

happyReduce_56 = happySpecReduce_3  28 happyReduction_56
happyReduction_56 (HappyAbsSyn23  happy_var_3)
	_
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 (ExpBinOpApp {arg1 = happy_var_1, arg2 = happy_var_3, op = GTE}
	)
happyReduction_56 _ _ _  = notHappyAtAll 

happyReduce_57 = happySpecReduce_1  29 happyReduction_57
happyReduction_57 (HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 (happy_var_1
	)
happyReduction_57 _  = notHappyAtAll 

happyReduce_58 = happySpecReduce_3  29 happyReduction_58
happyReduction_58 (HappyAbsSyn23  happy_var_3)
	_
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 (ExpBinOpApp {arg1 = happy_var_1, arg2 = happy_var_3, op = Plus}
	)
happyReduction_58 _ _ _  = notHappyAtAll 

happyReduce_59 = happySpecReduce_3  29 happyReduction_59
happyReduction_59 (HappyAbsSyn23  happy_var_3)
	_
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 (ExpBinOpApp {arg1 = happy_var_1, arg2 = happy_var_3, op = Minus}
	)
happyReduction_59 _ _ _  = notHappyAtAll 

happyReduce_60 = happySpecReduce_1  30 happyReduction_60
happyReduction_60 (HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 (happy_var_1
	)
happyReduction_60 _  = notHappyAtAll 

happyReduce_61 = happySpecReduce_3  30 happyReduction_61
happyReduction_61 (HappyAbsSyn23  happy_var_3)
	_
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 (ExpBinOpApp {arg1 = happy_var_1, arg2 = happy_var_3, op = Mult}
	)
happyReduction_61 _ _ _  = notHappyAtAll 

happyReduce_62 = happySpecReduce_3  30 happyReduction_62
happyReduction_62 (HappyAbsSyn23  happy_var_3)
	_
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 (ExpBinOpApp {arg1 = happy_var_1, arg2 = happy_var_3, op = Div}
	)
happyReduction_62 _ _ _  = notHappyAtAll 

happyReduce_63 = happySpecReduce_3  30 happyReduction_63
happyReduction_63 (HappyAbsSyn23  happy_var_3)
	_
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 (ExpBinOpApp {arg1 = happy_var_1, arg2 = happy_var_3, op = Mod}
	)
happyReduction_63 _ _ _  = notHappyAtAll 

happyReduce_64 = happySpecReduce_1  31 happyReduction_64
happyReduction_64 (HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 (happy_var_1
	)
happyReduction_64 _  = notHappyAtAll 

happyReduce_65 = happySpecReduce_3  31 happyReduction_65
happyReduction_65 _
	_
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 (ExpCall {	ecId = happy_var_1, ecArgs = [] }
	)
happyReduction_65 _ _ _  = notHappyAtAll 

happyReduce_66 = happyReduce 4 31 happyReduction_66
happyReduction_66 (_ `HappyStk`
	(HappyAbsSyn32  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn23  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn23
		 (ExpCall {	ecId = happy_var_1, ecArgs = happy_var_3 }
	) `HappyStk` happyRest

happyReduce_67 = happySpecReduce_1  32 happyReduction_67
happyReduction_67 (HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn32
		 ([happy_var_1]
	)
happyReduction_67 _  = notHappyAtAll 

happyReduce_68 = happySpecReduce_3  32 happyReduction_68
happyReduction_68 (HappyAbsSyn32  happy_var_3)
	_
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn32
		 (happy_var_1 : happy_var_3
	)
happyReduction_68 _ _ _  = notHappyAtAll 

happyReduce_69 = happySpecReduce_1  33 happyReduction_69
happyReduction_69 (HappyTerminal (T_Id happy_var_1))
	 =  HappyAbsSyn23
		 (ExpId { eiVal = happy_var_1 }
	)
happyReduction_69 _  = notHappyAtAll 

happyReduce_70 = happySpecReduce_1  33 happyReduction_70
happyReduction_70 (HappyTerminal (T_IntLit happy_var_1))
	 =  HappyAbsSyn23
		 (ExpIntLit { eilVal = happy_var_1 }
	)
happyReduction_70 _  = notHappyAtAll 

happyReduce_71 = happySpecReduce_1  33 happyReduction_71
happyReduction_71 (HappyTerminal (T_CharLit happy_var_1))
	 =  HappyAbsSyn23
		 (ExpCharLit { eclVal = happy_var_1 }
	)
happyReduction_71 _  = notHappyAtAll 

happyReduce_72 = happySpecReduce_1  33 happyReduction_72
happyReduction_72 (HappyTerminal (T_BoolLit happy_var_1))
	 =  HappyAbsSyn23
		 (ExpBoolLit { eblVal = happy_var_1 }
	)
happyReduction_72 _  = notHappyAtAll 

happyReduce_73 = happySpecReduce_3  33 happyReduction_73
happyReduction_73 _
	(HappyAbsSyn23  happy_var_2)
	_
	 =  HappyAbsSyn23
		 (happy_var_2
	)
happyReduction_73 _ _ _  = notHappyAtAll 

happyNewToken action sts stk [] =
	action 75 75 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	T_Id happy_dollar_dollar -> cont 34;
	T_IntLit happy_dollar_dollar -> cont 35;
	T_CharLit happy_dollar_dollar -> cont 36;
	T_BoolLit happy_dollar_dollar -> cont 37;
	T_IntType -> cont 38;
	T_CharType -> cont 39;
	T_BoolType -> cont 40;
	T_VoidType -> cont 41;
	T_If -> cont 42;
	T_Else -> cont 43;
	T_Do -> cont 44;
	T_While -> cont 45;
	T_For -> cont 46;
	T_Break -> cont 47;
	T_Continue -> cont 48;
	T_Return -> cont 49;
	T_LParen -> cont 50;
	T_RParen -> cont 51;
	T_LBrace -> cont 52;
	T_RBrace -> cont 53;
	T_LSqBracket -> cont 54;
	T_RSqBracket -> cont 55;
	T_Comma -> cont 56;
	T_QMark -> cont 57;
	T_Colon -> cont 58;
	T_SemiColon -> cont 59;
	T_Not -> cont 60;
	T_Eq -> cont 61;
	T_NotEq -> cont 62;
	T_GTE -> cont 63;
	T_LTE -> cont 64;
	T_GT -> cont 65;
	T_LT -> cont 66;
	T_And -> cont 67;
	T_Or -> cont 68;
	T_Assign -> cont 69;
	T_Div -> cont 70;
	T_Star -> cont 71;
	T_Plus -> cont 72;
	T_Minus -> cont 73;
	T_Mod -> cont 74;
	_ -> happyError' (tk:tks)
	}

happyError_ 75 tk tks = happyError' tks
happyError_ _ tk tks = happyError' (tk:tks)

newtype HappyIdentity a = HappyIdentity a
happyIdentity = HappyIdentity
happyRunIdentity (HappyIdentity a) = a

instance Monad HappyIdentity where
    return = HappyIdentity
    (HappyIdentity p) >>= q = q p

happyThen :: () => HappyIdentity a -> (a -> HappyIdentity b) -> HappyIdentity b
happyThen = (>>=)
happyReturn :: () => a -> HappyIdentity a
happyReturn = (return)
happyThen1 m k tks = (>>=) m (\a -> k a tks)
happyReturn1 :: () => a -> b -> HappyIdentity a
happyReturn1 = \a tks -> (return) a
happyError' :: () => [(Token)] -> HappyIdentity a
happyError' = HappyIdentity . parseError

parse tks = happyRunIdentity happySomeParser where
  happySomeParser = happyThen (happyParse action_0 tks) (\x -> case x of {HappyAbsSyn4 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


parseError :: [Token] -> a
parseError [] = error "Parse Error: Unexpected EOF"
parseError (x:xs) = error $ "Parse Error at " ++ (show x)
{-# LINE 1 "templates/GenericTemplate.hs" #-}
{-# LINE 1 "templates/GenericTemplate.hs" #-}
{-# LINE 1 "<built-in>" #-}
{-# LINE 1 "<command-line>" #-}
{-# LINE 1 "templates/GenericTemplate.hs" #-}
-- Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp 

{-# LINE 30 "templates/GenericTemplate.hs" #-}








{-# LINE 51 "templates/GenericTemplate.hs" #-}

{-# LINE 61 "templates/GenericTemplate.hs" #-}

{-# LINE 70 "templates/GenericTemplate.hs" #-}

infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is (1), it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept (1) tk st sts (_ `HappyStk` ans `HappyStk` _) =
	happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
	 (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action

{-# LINE 148 "templates/GenericTemplate.hs" #-}

-----------------------------------------------------------------------------
-- HappyState data type (not arrays)



newtype HappyState b c = HappyState
        (Int ->                    -- token number
         Int ->                    -- token number (yes, again)
         b ->                           -- token semantic value
         HappyState b c ->              -- current state
         [HappyState b c] ->            -- state stack
         c)



-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state (1) tk st sts stk@(x `HappyStk` _) =
     let (i) = (case x of { HappyErrorToken (i) -> i }) in
--     trace "shifting the error token" $
     new_state i i tk (HappyState (new_state)) ((st):(sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state ((st):(sts)) ((HappyTerminal (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_0 nt fn j tk st@((HappyState (action))) sts stk
     = action nt j tk st ((st):(sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@(((st@(HappyState (action))):(_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_2 nt fn j tk _ ((_):(sts@(((st@(HappyState (action))):(_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_3 nt fn j tk _ ((_):(((_):(sts@(((st@(HappyState (action))):(_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k - ((1) :: Int)) sts of
	 sts1@(((st1@(HappyState (action))):(_))) ->
        	let r = fn stk in  -- it doesn't hurt to always seq here...
       		happyDoSeq r (action nt j tk st1 sts1 r)

happyMonadReduce k nt fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
        happyThen1 (fn stk tk) (\r -> action nt j tk st1 sts1 (r `HappyStk` drop_stk))
       where (sts1@(((st1@(HappyState (action))):(_)))) = happyDrop k ((st):(sts))
             drop_stk = happyDropStk k stk

happyMonad2Reduce k nt fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
       happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))
       where (sts1@(((st1@(HappyState (action))):(_)))) = happyDrop k ((st):(sts))
             drop_stk = happyDropStk k stk





             new_state = action


happyDrop (0) l = l
happyDrop n ((_):(t)) = happyDrop (n - ((1) :: Int)) t

happyDropStk (0) l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n - ((1)::Int)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction

{-# LINE 246 "templates/GenericTemplate.hs" #-}
happyGoto action j tk st = action j j tk (HappyState action)


-----------------------------------------------------------------------------
-- Error recovery ((1) is the error token)

-- parse error if we are in recovery and we fail again
happyFail (1) tk old_st _ stk@(x `HappyStk` _) =
     let (i) = (case x of { HappyErrorToken (i) -> i }) in
--	trace "failing" $ 
        happyError_ i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  (1) tk old_st (((HappyState (action))):(sts)) 
						(saved_tok `HappyStk` _ `HappyStk` stk) =
--	trace ("discarding state, depth " ++ show (length stk))  $
	action (1) (1) tk (HappyState (action)) sts ((saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail  i tk (HappyState (action)) sts stk =
--      trace "entering error recovery" $
	action (1) (1) tk (HappyState (action)) sts ( (HappyErrorToken (i)) `HappyStk` stk)

-- Internal happy errors:

notHappyAtAll :: a
notHappyAtAll = error "Internal Happy error\n"

-----------------------------------------------------------------------------
-- Hack to get the typechecker to accept our action functions







-----------------------------------------------------------------------------
-- Seq-ing.  If the --strict flag is given, then Happy emits 
--	happySeq = happyDoSeq
-- otherwise it emits
-- 	happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.

{-# LINE 312 "templates/GenericTemplate.hs" #-}
{-# NOINLINE happyShift #-}
{-# NOINLINE happySpecReduce_0 #-}
{-# NOINLINE happySpecReduce_1 #-}
{-# NOINLINE happySpecReduce_2 #-}
{-# NOINLINE happySpecReduce_3 #-}
{-# NOINLINE happyReduce #-}
{-# NOINLINE happyMonadReduce #-}
{-# NOINLINE happyGoto #-}
{-# NOINLINE happyFail #-}

-- end of Happy Template.
