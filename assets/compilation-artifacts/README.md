# C++ compilation artifacts (Hello, World)

This folder demonstrates every major C++ build stage with a tiny program.

## Source

- `hello.cpp`: original C++ source code

## Build pipeline

1. Preprocess
   - Command: `g++ -E hello.cpp -o hello.ii`
   - Output: `hello.ii` (headers and macros expanded)
2. Compile to assembly
   - Command: `g++ -S hello.ii -o hello.s`
   - Output: `hello.s` (human-readable assembly)
3. Assemble to object code
   - Command: `g++ -c hello.s -o hello.o`
   - Output: `hello.o` (ELF relocatable object)
4. Link to executable
   - Command: `g++ hello.o -o hello`
   - Output: `hello` (ELF executable)

## Human-readable object/executable views

- `hello.object.disassembly.txt`: disassembly of `hello.o`
- `hello.object.sections.txt`: section table for `hello.o`
- `hello.object.symbols.txt`: symbol table for `hello.o`
- `hello.object.filetype.txt`: file type summary for `hello.o`
- `hello.executable.disassembly.txt`: disassembly of final executable
- `hello.executable.filetype.txt`: file type summary for executable
- `hello.preview.txt`: compact lecture-friendly preview of source + assembly + object disassembly

## Rebuild everything

From this directory:

```bash
./build.sh
```

This regenerates all artifacts.
