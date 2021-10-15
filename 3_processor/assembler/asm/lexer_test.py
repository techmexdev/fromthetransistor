from lexer import Lexer, Token, TokenType

input = '''
    mov r0, #10
    mov r1, r0
    num: .short 010
    msg: .string "Hello, arm"
    addlt r0, r0, #1
'''

expected = [
    Token(token_type=TokenType.EOL, literal= '\n'),

    Token(token_type=TokenType.MNEMONIC, literal= 'mov'),
    Token(token_type=TokenType.REGISTER, literal= 'r0'),
    Token(token_type=TokenType.COMMA, literal= ','),
    Token(token_type=TokenType.CONSTANT, literal= '#10'),
    Token(token_type=TokenType.EOL, literal= '\n'),

    Token(token_type=TokenType.MNEMONIC, literal= 'mov'),
    Token(token_type=TokenType.REGISTER, literal= 'r1'),
    Token(token_type=TokenType.COMMA, literal= ','),
    Token(token_type=TokenType.REGISTER, literal= 'r0'),
    Token(token_type=TokenType.EOL, literal= '\n'),

    Token(token_type=TokenType.VARIABLE_NAME, literal= 'num'),
    Token(token_type=TokenType.VARIABLE_TYPE, literal= 'short'),
    Token(token_type=TokenType.NUMBER, literal= '010'),
    Token(token_type=TokenType.EOL, literal= '\n'),

    Token(token_type=TokenType.VARIABLE_NAME, literal= 'msg'),
    Token(token_type=TokenType.VARIABLE_TYPE, literal= 'string'),
    Token(token_type=TokenType.STRING, literal= 'Hello, arm'),
    Token(token_type=TokenType.EOL, literal= '\n'),

    Token(token_type=TokenType.MNEMONIC, literal= "add"),
    Token(token_type=TokenType.CONDITION, literal= "lt"),
    Token(token_type=TokenType.REGISTER, literal= "r0"),
    Token(token_type=TokenType.COMMA, literal= ","),
    Token(token_type=TokenType.REGISTER, literal= "r0"),
    Token(token_type=TokenType.COMMA, literal= ","),
    Token(token_type=TokenType.CONSTANT, literal= "#1"),
    Token(token_type=TokenType.EOL, literal= "\n"),
]



def test():
    lexer = Lexer()
    tokens = lexer.tokenize_instructions(input)

    print("Testing the coins...")

    expect(f'Tokens should have a length of {len(expected)}', len(tokens) == len(expected))

    for i in range(len(tokens)):
        expect(f'Token {tokens[i]} should be same as {expected[i]}', tokens[i].__str__() == expected[i].__str__())

    print("Good coins :3 Tests Passed!")



def expect(description, cond):
    if not cond:
        print(f'FAILURE: {description}')
        exit()
    else:
        print(f'PASS: {description}')

test()
