java -jar antlr-4.12.0-complete.jar -Dlanguage=TypeScript -visitor Spec.g4
cp SpecLexer.ts SpecListener.ts SpecParser.ts SpecVisitor.ts ../src/parser/

for tsfile in "SpecLexer.ts" "SpecListener.ts" "SpecParser.ts" "SpecVisitor.ts"
do
    echo "// @ts-nocheck" > ../src/parser/$tsfile
    cat $tsfile >> ../src/parser/$tsfile
done
