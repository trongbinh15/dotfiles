 " These commands will navigate through buffers in order regardless of which mode you are using
" e.g. if you change the order of buffers :bnext and :bprevious will not respect the custom ordering
nnoremap <silent><space>b :BufferLineCycleNext<CR>
nnoremap <silent>b<space> :BufferLineCyclePrev<CR>

" These commands will move the current buffer backwards or forwards in the bufferline
nnoremap <silent>bn :BufferLineMoveNext<CR>
nnoremap <silent>bp :BufferLineMovePrev<CR>

" These commands will sort buffers by directory, language, or a custom criteria
nnoremap <silent>be :BufferLineSortByExtension<CR>
nnoremap <silent>bd :BufferLineSortByDirectory<CR>
" nnoremap <silent><mymap> :lua require'bufferline'.sort_buffers_by(function (buf_a, buf_b) return buf_a.id < buf_b.id end)<CR>

nnoremap <silent> gb :BufferLinePick<CR>
nnoremap <silent> bo :BufOnly<CR>
" nnoremap <C-1> :lua require"bufferline".go_to_buffer(1)<CR>
" nnoremap <C-2> :lua require"bufferline".go_to_buffer(2)<CR>
" nnoremap <C-3> :lua require"bufferline".go_to_buffer(3)<CR>
set termguicolors
