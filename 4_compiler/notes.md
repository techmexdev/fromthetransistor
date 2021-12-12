### Compiler

Overview: Tokenize -> Parse -> Build AST -> Generate ARM

Compiler explanation
High level overview: source code -> executable
Compilation outside of programming?: structure text, act on it.
Before compilation, program (code) is nothing more than a list of characters
We need a way to structure these characters, make sense of them, and execute them

/* programmer code
name = "john"
print("hello", name)
*/
->
/* arm code
name string
mov "john", name
...
*/
Compiler needs to transform the source code into something useful, executable. In this case, executable is ASM (assembly) code

assembler
asm: mov r1, #5 -> bin: 0100110101001101


Compilation steps:

1. Tokenize
Source code -> List of tokens
Ex: 'var name = "hello" ' -> [Token{Type: 'identifier', literal: 'name'}, Token{Type: 'equals', literal: '='}, ...]

2. Build AST
Ex: [Token{Type: 'identifier', literal: 'name'}, Token{Type: 'equals', literal: '='}, ...] ->

Something like this???
Root{
  FunctionCall(
    Expression(Literal: 4),
    Expression(
      Operation(
        Type: SUM,
        A: Expression(Literal: 4),
        B: Expression(Literal: 10)
      )
    )
Let's figure out the structure of an AST...

3. Transform AST

4. Generate ASM



