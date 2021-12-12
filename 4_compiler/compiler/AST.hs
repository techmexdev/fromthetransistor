module AST where
import Lexer
data Expression e = Literal Token
            |  Binary (Expression e) Token (Expression e)
            |  Unary Token (Expression e)
            deriving (Show)

-- data Binary = (Expression LeftExpression) Token (Expression RightExpression)

showAST :: Expression t -> String
showAST (Unary unaryOperator right) = lexeme unaryOperator ++ showAST right
showAST (Binary left binaryOperator right) = showAST left  ++ " " ++ lexeme binaryOperator ++ " " ++ showAST right
showAST (Literal t) = lexeme t
-- -5
-- !isValid
-- !false
-- data Unary = EXCLAMATION Boolean | UnaryOperator Number
-- data Binary =  Expression BinaryOperator Expression

-- data BinaryOperator = Addition | Subtraction | Division | Multiplication | Modulo