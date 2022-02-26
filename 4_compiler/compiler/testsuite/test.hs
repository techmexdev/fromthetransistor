import Test.Framework
import Test.Framework.Providers.HUnit
import System.Exit (exitFailure)
import Test.HUnit
import Lexer
import AST

-- test1 = TestLabel "label "
lexerTests = TestLabel "Lexer tests" (TestList [
      TestCase (assertEqual "var name = \"bb\";"
        [[
          Token KEYWORD "var" (String "var") 1,
          Token IDENTIFIER  "name" (String "name") 1,
          Token OPERATOR "=" (String "=") 1,
          Token STRING "bb" (String "bb") 1,
          Token SYMBOL  ";" (String ";") 1
        ]]
        (
          parse  "var name = \"bb\";"
        )
      )
  ])


astTests = TestLabel "AST tests" (TestList [
      TestCase (assertEqual "Unary expression"
        "!a"
        (
         showAST (Unary
           (Token OPERATOR "!" (String "!") 1)
           (Literal (Token IDENTIFIER "a" (String "a") 1))
          )
        )
      ),
      TestCase (assertEqual "Binary expression"
        "-123 * 45"
        (
          showAST (Binary
            (Unary
              (Token OPERATOR "-" (String "-") 1)
              (Literal (Token NUMBER "123" (Number 123) 1))
            )
            (Token OPERATOR "*" (String "*") 1)
            (Literal (Token NUMBER "45" (Number 45) 1))
          )
        )
      ),
      TestCase (assertEqual "Grouping expression"
        "(a + (b - c))"
        (
          showAST (Grouping
            (Binary
              (Literal (Token IDENTIFIER "a" (String "a") 1))
              (Token OPERATOR "+" (String "+") 1)
              (Grouping
                (Binary
                  (Literal (Token IDENTIFIER "b" (String "b") 1))
                  (Token OPERATOR "-" (String "-") 1)
                  (Literal (Token IDENTIFIER "c" (String "c") 1))
              )
            )
          )
        )
      )
    )
  ])

tests = TestList [lexerTests, astTests]
--main = do
--    defaultMain tests

main = do
    runTestTT tests
--
-- 
-- -- Token types in lox
-- 
-- 
-- // Single-character tokens.
-- LEFT_PAREN, RIGHT_PAREN, LEFT_BRACE, RIGHT_BRACE,
-- COMMA, DOT, MINUS, PLUS, SEMICOLON, SLASH, STAR,
-- 
-- // One or two character tokens.
-- BANG, BANG_EQUAL,
-- EQUAL, EQUAL_EQUAL,
-- GREATER, GREATER_EQUAL,
-- LESS, LESS_EQUAL,
-- 
-- // Literals.
-- IDENTIFIER, STRING, NUMBER,
-- 
-- // Keywords.
-- AND, CLASS, ELSE, FALSE, FUN, FOR, IF, NIL, OR,
-- PRINT, RETURN, SUPER, THIS, TRUE, VAR, WHILE,
-- 
-- EOF
-- 
-- Haskell implementation
-- 
-- Input
-- ```javascript
-- var name = "loxi";
-- makeBreakfast(bacon, eggs, toast);
-- for (var a = 1; a < 10; a = a + 1) {
--   print a;
-- }
-- while (a < 10) {
--   print a;
--   a = a + 1;
-- }
-- fun printSum(a, b) {
--   print a + b;
-- }
-- ```
-- 
-- Output
-- ```
-- VAR{var}, IDENTIFIER{name}, EQUALS{=}, String{"loxi"}, SEMICOLIN{;}
-- ```
--
