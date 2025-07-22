# PDF Batch Compressor Script

A simple yet powerful bash script to batch-compress PDF files in a directory using Ghostscript. It's designed to be easy to use, providing a menu to select the desired output quality, and is particularly useful for preparing PDFs for web, e-book distribution, or professional printing (like Amazon KDP).

## Features
-   **Interactive Menu**: Choose the compression quality from a simple menu.
-   **Four Predefined Quality Levels**:
    -   `/screen`: Low quality, small size (72 dpi). Ideal for web viewing.
    -   `/ebook`: Medium quality, good balance (150 dpi).
    -   `/printer`: High quality, for printing (300 dpi).
    -   `/prepress`: Maximum quality, preserving colors (300 dpi). Recommended for professional printing services.
-   **CMYK Conversion**: Automatically forces the color conversion strategy to CMYK, which is often required for print-on-demand services.
-   **Batch Processing**: Automatically finds and processes all PDF files in the current directory.
-   **Safe Operation**: Never overwrites your original files. It creates a new file with a `_compress.pdf` suffix (e.g., `my-book.pdf` becomes `my-book_compress.pdf`).
-   **Smart Detection**: Skips any files that already end with `_compress.pdf` to avoid re-compressing files.
-   **Progress Reporting**: Displays the progress of the compression and reports a final list of successfully compressed files and their new sizes.
-   **Cross-Platform**: Works on any system with a bash shell and Ghostscript (Linux, macOS, etc.).

## Requirements
The only dependency you need to have installed on your system is:
-   **Ghostscript**: This is the engine that performs the actual PDF processing.
The script also uses standard command-line utilities like `du` and `cut`, which are pre-installed on virtually all Linux and macOS systems.

## Installation
1.  **Install Ghostscript**
    You must install Ghostscript using your system's package manager.
    -   **On Debian / Ubuntu / Mint:**
        ```bash
        sudo apt update
        sudo apt install ghostscript
        ```
    -   **On Fedora / RHEL / CentOS:**
        ```bash
        sudo dnf install ghostscript
        ```
    -   **On macOS (using [Homebrew](https://brew.sh/)):**
        ```bash
        brew install ghostscript
        ```
        

## Usage
1.  **Place the Script**: Move the `compress.sh` script into the directory containing the PDF files you want to compress.
2.  **Make it Executable**: Open a terminal in that directory and give the script execution permissions. You only need to do this once.
    ```bash
    chmod +x compress.sh
    ```
3.  **Run the Script**: Execute the script from your terminal.
    ```bash
    ./compress.sh
    ```
4.  **Select Quality**: The script will prompt you to choose a compression quality. Enter the number corresponding to your choice (1-4) and press `Enter`. If you enter an invalid choice or just press `Enter`, it will default to `3` (High / Printer).
5.  **Done**: The script will then process all the PDF files. Upon completion, it will list the newly created `_compress.pdf` files and their sizes. The original files remain untouched.

## How It Works
1.  **Quality Selection**: The script first displays a menu and waits for the user to select a `PDF_QUALITY` setting. These settings (`/screen`, `/ebook`, `/printer`, `/prepress`) are pre-defined presets within Ghostscript that control things like image resolution, font embedding, and color conversion.
2.  **Ghostscript Options**: It constructs a set of options (`GS_OPTS`) to pass to the Ghostscript (`gs`) command. The key options are:
    -   `-sDEVICE=pdfwrite`: Tells Ghostscript to output a PDF file.
    -   `-sColorConversionStrategy=CMYK`: Forces colors to be converted to the CMYK color space, which is standard for printing.
    -   `-dPDFSETTINGS`: This is where your selected quality preset is applied.
    -   `-dCompatibilityLevel=1.4`: Ensures the output PDF is widely compatible.
3.  **File Processing Loop**: The script scans the directory for all files ending in `.pdf` but ignores any that already contain `_compress.pdf` in their name. It then iterates through each found file, running the `gs` command to create the new, compressed version.
