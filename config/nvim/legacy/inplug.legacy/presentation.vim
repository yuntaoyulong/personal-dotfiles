Plug '3rd/image.nvim'

function! s:MarpEnsure() abort
  if executable('marp')
    return v:true
  endif
  echohl WarningMsg
  echom 'marp not found. Install with: yay -S marp-cli-bin (or marp-cli)'
  echohl None
  return v:false
endfunction

function! s:MarpExport(ext) abort
  if !s:MarpEnsure()
    return
  endif
  if &modified
    silent update
  endif
  let l:src = expand('%:p')
  if empty(l:src)
    echohl WarningMsg | echom 'No file to export.' | echohl None
    return
  endif
  let l:out = expand('%:p:r') . '.' . a:ext
  let l:format_flag = ''
  if a:ext ==# 'pptx'
    let l:format_flag = '--pptx'
  elseif a:ext ==# 'pdf'
    let l:format_flag = '--pdf'
  endif
  execute 'silent !marp --allow-local-files ' . l:format_flag . ' -- ' . shellescape(l:src) . ' -o ' . shellescape(l:out)
  redraw!
  if v:shell_error != 0
    echohl ErrorMsg
    echom 'Marp export failed (exit ' . v:shell_error . '): ' . l:out
    echohl None
    return
  endif
  echom 'Marp exported: ' . l:out
endfunction

function! s:MarpPreview() abort
  if !s:MarpEnsure()
    return
  endif
  if &modified
    silent update
  endif
  let l:src = expand('%:p')
  if empty(l:src)
    echohl WarningMsg | echom 'No file to preview.' | echohl None
    return
  endif
  execute 'terminal marp --preview --allow-local-files -- ' . shellescape(l:src)
endfunction

command! -nargs=0 MarpPPT call <SID>MarpExport('pptx')
command! -nargs=0 MarpPDF call <SID>MarpExport('pdf')
command! -nargs=0 MarpPreview call <SID>MarpPreview()

nnoremap <silent> <leader>mp :MarpPPT<CR>
nnoremap <silent> <leader>mP :MarpPreview<CR>
nnoremap <silent> <leader>md :MarpPDF<CR>
