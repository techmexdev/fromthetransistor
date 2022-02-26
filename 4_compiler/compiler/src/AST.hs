module AST where
import Lexer
data Expression e = Literal Token
            |  Binary (Expression e) Token (Expression e)
            |  Unary Token (Expression e)
            | Grouping (Expression e)
            deriving (Show)

-- data Binary = (Expression LeftExpression) Token (Expression RightExpression)

showAST :: Expression t -> String
showAST (Unary unaryOperator right) = lexeme unaryOperator ++ showAST right
showAST (Binary left binaryOperator right) = showAST left  ++ " " ++ lexeme binaryOperator ++ " " ++ showAST right
showAST (Literal t) = lexeme t
showAST (Grouping e) = "(" ++ showAST e ++ ")"
-- -5
-- !isValid
-- !false
-- data Unary = EXCLAMATION Boolean | UnaryOperator Number
-- data Binary =  Expression BinaryOperator Expression

-- data BinaryOperator = Addition | Subtraction | Division | Multiplication | Modulo

illegalize :: Token -> Token
illegalize (Token token lexeme literal line) = Token {token = ILLEGAL, literal=literal, lexeme=lexeme, line=line}

isUnaryOperator :: Token -> Bool
isUnaryOperator (Token token lexeme literal line) = show literal ==  "!" || show literal ==  "-"

isPrimary :: Token -> Bool
isPrimary (Token token lexeme literal line) = token == NUMBER || token == STRING || token == BOOLEAN 


primary :: Token -> Expression Token
primary t = if isPrimary t then Literal t else Literal (illegalize t)

unary :: [Token] -> Expression Token -> Expression Token
unary _ (t:[]) = primary t
unary prev (t:ts) = if isUnaryOperator t then Unary t (unary ts) else if isFactorOperator t then Factor (prev t (unary t ts)) else primary t

-- factor :: [Token] -> Expression Token
-- factor (t:ts) = let leftUnary = unary (t:ts)
--                     afterUnary = dropWhile' (t:ts) isPartOfUnary (leftUnary)
--                     operator = getOperator afterUnary
--                     afterOperator = dropWhile' afterUnary isPartOfOperator (operator)
--                     rightUnary = unary (afterOperator)
--                 in Factor (Unary leftUnary operator Unary rightUnary)
