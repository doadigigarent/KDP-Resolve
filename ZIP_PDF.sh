#!/bin/bash

# --- Quality Selection Menu ---
echo "Choose the compression quality for the PDFs:"
echo "  1) Low        (/screen)  - 72 dpi, ideal for screen viewing."
echo "  2) Medium     (/ebook)   - 150 dpi, a good balance between quality and size."
echo "  3) High       (/printer) - 300 dpi, great quality for printing (KDP Recommended)."
echo "  4) Maximum    (/prepress)- 300 dpi, maximum color fidelity (KDP Recommended)."

read -p "Enter your choice (1-4) [default: 3]: " choice

# Set the quality based on the choice
case "$choice" in
  1) PDF_QUALITY="/screen" ;;
  2) PDF_QUALITY="/ebook" ;;
  3) PDF_QUALITY="/printer" ;;
  4) PDF_QUALITY="/prepress" ;;
  *)
    echo "Invalid choice. Using high quality (/printer)."
    PDF_QUALITY="/printer"
    ;;
esac

echo "Quality set to: $PDF_QUALITY"
echo "Forced CMYK conversion."
echo "----------------------------------------"


# Set Ghostscript options with quality and forced CMYK
GS_OPTS="-sDEVICE=pdfwrite \
         -sColorConversionStrategy=CMYK \
         -dCompatibilityLevel=1.4 \
         -dPDFSETTINGS=$PDF_QUALITY \
         -dNOPAUSE \
         -dQUIET \
         -dBATCH"

# Find all PDF files that are not already compressed
files=()
for f in *.pdf; do
  [[ "$f" != *_compress.pdf ]] && files+=("$f")
done

total_files=${#files[@]}
compressed_files=()

if [[ $total_files -eq 0 ]]; then
  echo "No PDF files to compress found in the current directory."
  exit 1
fi

# Counter for progress
processed_files=0

# Loop through all found .pdf files
for input in "${files[@]}"; do
  # Build the output name
  base="${input%.pdf}"
  output="${base}_compress.pdf"

  # Perform the compression
  echo "Compressing '$input' → '$output'…"
  gs $GS_OPTS -sOutputFile="$output" "$input"

  # Success check
  if [[ $? -eq 0 ]]; then
    echo "  → Compression of '$input' complete."
    compressed_files+=("$output")
  else
    echo "  → Error compressing '$input'!" >&2
  fi

  # Increment the counter and calculate the percentage
  ((processed_files++))
  percent=$((processed_files * 100 / total_files))
  echo "  → Status: $percent% complete."
done

# Show the list of compressed files and their sizes
if [[ ${#compressed_files[@]} -gt 0 ]]; then
  echo -e "\nFiles compressed successfully:\n"
  for file in "${compressed_files[@]}"; do
    size=$(du -h "$file" | cut -f1)
    echo "  - $file (${size})"
  done
else
  echo -e "\nNo new files were compressed."
fi

# Prevent the screen from closing
read -p "Press Enter to exit..."
