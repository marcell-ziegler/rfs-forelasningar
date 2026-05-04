#!/usr/bin/env bash
set -euo pipefail

SRC="hello.cpp"
BASE="hello"

# 1) Preprocessing: expands #include and macros

g++ -E "$SRC" -o "$BASE.ii"

# 2) Compilation: turns preprocessed code into assembly

g++ -S "$BASE.ii" -o "$BASE.s"

# 3) Assembly: turns assembly into object code

g++ -c "$BASE.s" -o "$BASE.o"

# 4) Linking: creates the final executable

g++ "$BASE.o" -o "$BASE"

# Human-readable views of object/executable internals

objdump -d -M intel "$BASE.o" > "$BASE.object.disassembly.txt"
objdump -d -M intel "$BASE" > "$BASE.executable.disassembly.txt"
objdump -h "$BASE.o" > "$BASE.object.sections.txt"
objdump -t "$BASE.o" > "$BASE.object.symbols.txt"
file "$BASE.o" > "$BASE.object.filetype.txt"
file "$BASE" > "$BASE.executable.filetype.txt"

# Save a tiny preview file for lecture-friendly reading
{
  echo "===== SOURCE (hello.cpp) ====="
  sed -n '1,120p' "$SRC"
  echo
  echo "===== ASSEMBLY (hello.s, first 120 lines) ====="
  sed -n '1,120p' "$BASE.s"
  echo
  echo "===== OBJECT DISASSEMBLY (first 120 lines) ====="
  sed -n '1,120p' "$BASE.object.disassembly.txt"
} > "$BASE.preview.txt"

echo "Generated artifacts in: $(pwd)"
