function ssh_clipboard#Enable()
  if !executable('clipboard-provider')
    return
  endif
  let g:clipboard = {
    \ 'name': 'ssh_clipboard',
    \   'copy': {
    \     '+': 'clipboard-provider copy',
    \     '*': 'env COPY_PROVIDERS=tmux clipboard-provider copy',
    \   },
    \   'paste': {
    \     '+': 'clipboard-provider paste',
    \     '*': 'env COPY_PROVIDERS=tmux clipboard-provider paste',
    \   },
    \ }
endfunction
