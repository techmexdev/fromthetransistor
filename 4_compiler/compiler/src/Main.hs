import AST
import Lexer

main = putStrLn $ showAST (Binary
            (Unary
              (Token OPERATOR "-" (String "-") 1)
              (Literal (Token NUMBER "123" (Number 123) 1))
            )
            (Token OPERATOR "*" (String "*") 1)
            (Literal (Token NUMBER "45" (Number 45) 1))
          )
      
