#! /usr/bin/env zsh

DIR=${0:a:h}
GRAMMAR_DIR="$DIR"/../grammar
OUT_DIR="$DIR"/../src/parser

if [ ! "$(command -v java)" ]; then
    echo "java command cannot be found. Please install java."
    exit 1
fi

cd "$GRAMMAR_DIR" || exit 1
java -jar antlr-4.12.0-complete.jar -Dlanguage=TypeScript -o "$GRAMMAR_DIR" -visitor Spec.g4

for tsfile in "SpecLexer.ts" "SpecListener.ts" "SpecParser.ts" "SpecVisitor.ts"
do
    echo "// @ts-nocheck" > "$OUT_DIR/$tsfile"
    cat "$GRAMMAR_DIR/$tsfile" >> "$OUT_DIR/$tsfile"
done
