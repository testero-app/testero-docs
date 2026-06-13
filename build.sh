#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT_DIR="$SCRIPT_DIR/output"
TYPST_DIR="$SCRIPT_DIR/typst"
DOCS_DIR="$SCRIPT_DIR/docs"
GENERATED="$SCRIPT_DIR/typst/generated.typ"

echo "==> Rendering Mermaid diagrams..."
while IFS= read -r -d '' mmd; do
  png="${mmd%.mmd}.png"
  if [ ! -f "$png" ] || [ "$mmd" -nt "$png" ]; then
    echo "    $mmd -> $png"
    mmdc -i "$mmd" -o "$png" -w 800 -b transparent 2>/dev/null
  fi
done < <(find "$DOCS_DIR" -name "*.mmd" -print0 2>/dev/null)

echo "==> Converting Markdown to Typst..."

# Ordered list of markdown files
MD_FILES=(
  "$DOCS_DIR/00_introduzione.md"
  "$DOCS_DIR/architettura/01_stack_tecnologico.md"
  "$DOCS_DIR/architettura/02_architettura_generale.md"
  "$DOCS_DIR/architettura/03_modello_dati.md"
  "$DOCS_DIR/03_funzionalita.md"
)

# Add use-cases in sorted order
for uc in "$DOCS_DIR/use-cases/"UC_*.md; do
  [ -f "$uc" ] || continue
  MD_FILES+=("$uc")
done

# Convert all MD files into a single Typst fragment
> "$GENERATED"
for md in "${MD_FILES[@]}"; do
  [ -f "$md" ] || continue
  echo "    $(basename "$md")"
  pandoc "$md" -t typst --wrap=none 2>/dev/null >> "$GENERATED"
  echo "" >> "$GENERATED"
done

# Post-process: replace Pandoc column percentages with auto sizing
sed -i '' 's/columns: ([0-9.]*%[^)]*)/columns: auto/g' "$GENERATED"

# Build main.typ = template + generated content
MAIN_TYP="$TYPST_DIR/main.typ"
cat "$TYPST_DIR/template.typ" > "$MAIN_TYP"
echo "" >> "$MAIN_TYP"
cat "$GENERATED" >> "$MAIN_TYP"

echo "==> Compiling PDF..."
mkdir -p "$OUTPUT_DIR"
typst compile "$MAIN_TYP" "$OUTPUT_DIR/testero-docs.pdf" \
  --root "$SCRIPT_DIR"

# Cleanup generated files
rm -f "$GENERATED"

echo "==> Done: $OUTPUT_DIR/testero-docs.pdf"
