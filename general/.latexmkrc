$pdf_previewer = 'zathura %O';
$pdflatex = 'pdflatex -synctex=1 -interaction=nonstopmode';
@generated_exts = (@generated_exts, 'synctex.gz');

# pip install quietex
# https://blog.mje.nz/2019-07-31-quietex/
eval `quietex --latexmkrc`;
