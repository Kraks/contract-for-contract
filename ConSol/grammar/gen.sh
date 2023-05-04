java -jar antlr-4.12.0-complete.jar -Dlanguage=TypeScript -visitor Spec.g4

for tsfile in "SpecLexer.ts" "SpecListener.ts" "SpecParser.ts" "SpecVisitor.ts"
do
    echo "// @ts-nocheck" > ../src/lib/spec-parser/$tsfile
    cat $tsfile >> ../src/lib/spec-parser/$tsfile
done
