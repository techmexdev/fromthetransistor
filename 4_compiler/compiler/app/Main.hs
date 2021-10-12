module Main where

import Lib

main :: IO ()
main = do
  putStrLn "Hello"
  putStrLn "World"


data TokenType = NUMBER | STRING | KEYWORD | IDENTIFIER | SYMBOL | OPERATOR
    deriving (Show)

data Token = Token { token :: TokenType, lexeme :: String, literal :: String }
    deriving (Show)


takeWhile' :: [a] -> (a -> Bool) -> [a]
takeWhile' [] _ = []
takeWhile' (x:xs) c = if c x then x : takeWhile' xs c else []

takeWhileApplyAll :: [a] -> (a -> [a] -> Bool) -> [a]
takeWhileApplyAll [] _ = []
takeWhileApplyAll (x:xs) c = if c x xs then x : takeWhileApplyAll xs c else []

dropWhile' :: [a] -> (a -> Bool) -> [a]
dropWhile' [] _ = []
dropWhile' (x:xs) c = if c x then dropWhile' xs c else x : xs


isWhiteSpace :: Char -> Bool
isWhiteSpace c = c == ' '

isOperator :: Char -> Bool
isOperator '+' = True
isOperator '-' = True
isOperator '=' = True
isOperator '*' = True
isOperator '/' = True
isOperator '?' = True
isOperator '!' = True
isOperator '%' = True
isOperator '>' = True
isOperator '<' = True
isOperator _ = False

isSymbol :: Char -> Bool
isSymbol '(' = True
isSymbol ')' = True
isSymbol '{' = True
isSymbol '}' = True
isSymbol '.' = True
isSymbol ',' = True
isSymbol ';' = True
isSymbol '"' = True
isSymbol _ = False

isDigit :: Char -> Bool
isDigit '0' = True
isDigit '1' = True
isDigit '2' = True
isDigit '3' = True
isDigit '4' = True
isDigit '5' = True
isDigit '6' = True
isDigit '7' = True
isDigit '8' = True
isDigit '9' = True
isDigit _ = False

isNumber :: Char -> String -> Bool
isNumber n ns | isDigit n = True
              | isSymbol n  && n == '.' = (length ns > 0) && isDigit (ns!!0)
              | isSymbol n && n == ',' = length ns >= 3 && isDigit (ns!!0) && isDigit (ns!!1) && isDigit (ns!!2)
              | otherwise = False

isKeyword :: String -> Bool
isKeyword "var" = True
isKeyword "class" = True
isKeyword "func" = True
isKeyword "let" = True
isKeyword "if" = True
isKeyword "else" = True
isKeyword "try" = True
isKeyword "catch" = True
isKeyword "switch" = True
isKeyword "case" = True
isKeyword "default" = True
isKeyword "export" = True
isKeyword "import" = True
isKeyword _ = False

isAlpha :: Char -> Bool
isAlpha c = not (isSymbol c || isOperator c || isWhiteSpace c)




parseOperator :: String -> Token
parseOperator o = Token { token = OPERATOR, lexeme = o, literal = o }

parseString :: String -> Token
parseString s = Token { token = STRING, lexeme = s, literal = s }

parseSymbol :: String -> Token
parseSymbol s = Token { token = SYMBOL, lexeme = s, literal = s }

parseNumber :: String -> Token
parseNumber n = Token { token = NUMBER, lexeme = n, literal = n }

parseIdentifier :: String -> Token
parseIdentifier i = Token { token = IDENTIFIER, lexeme = i, literal = i }

parseKeyword :: String -> Token
parseKeyword kw = Token { token = KEYWORD, lexeme = kw, literal = kw }

parseWord :: String -> Token
parseWord w | isKeyword w = parseKeyword w
            | otherwise = parseIdentifier w




-- Tokenizer --
tokenize :: String -> [Token]
tokenize "" = []
tokenize (x:xs) | isWhiteSpace x = tokenize xs
                | isOperator x = let operator = x : takeWhile' xs isOperator
                                     rest = drop ((length operator) - 1) xs
                                 in (parseOperator operator) : tokenize rest
                | isSymbol x && x == '"' = let string = takeWhile' xs (\x -> x /= '"')
                                               rest = drop (length string + 1) xs
                                           in (parseString string) : tokenize rest
                | isSymbol x = (parseSymbol [x]) : tokenize xs
                | isDigit x = let number = x : takeWhileApplyAll xs isNumber
                                  rest = drop ((length number) - 1) xs
                              in (parseNumber number) : tokenize rest
                | otherwise = let word = x : takeWhile' xs isAlpha
                                  rest = drop ((length word) - 1) xs
                              in (parseWord word) : tokenize rest


parse :: String -> [[Token]]
parse "" = []
parse input = map (\l -> tokenize (dropWhile' l isWhiteSpace)) (lines input)
