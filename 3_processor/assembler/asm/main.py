import sys
import os

from assembler import Assembler
from lexer import Lexer

def main():
    file_text = read_file()

    lexer = Lexer()
    assembler = Assembler()

    tokens = lexer.tokenize_instructions(file_text)

    print("look at my coins")
    map(lambda t: t.__str__(), tokens)

    bin_instructions = assembler.assemble_instructions(tokens)

    print("look at my binaries")
    print("\n".join(bin_instructions))

    write_file("\n".join(bin_instructions))



def checkError(cond, err):
    if cond:
        print(err)
        exit()



def read_file():
    checkError(len(sys.argv) < 2, "should specify asm filename. example: python3 main.py asm.a")

    path = os.path.join(os.getcwd(), f'{sys.argv[1]}')
    asm_file = open(path, 'r')
    file_text = asm_file.read()

    return file_text

def write_file(text):
    fileName = sys.argv[1]
    f = open(f'{fileName.split(".")[0]}.bin', "w")
    f.write(text)
    f.close()

if __name__ == "__main__":
    main()
