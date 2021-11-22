

" There is only one instance/window of Mundo. Whenever a Mundo window is open, Autosave should be off
" nnoremap you :MundoToggle<cr>:AutoSaveToggle<cr>
" There may be muliple Magit windows. Only when the focus is on any of there Autosave should be off
" nnoremap yog :Magit<cr>:call AttachAutosaveStopEvents()<cr>:let g:auto_save = 0<cr>
" nnoremap yoG :tabe<cr>:MagitOnly<cr>:call AttachAutosaveStopEvents()<cr>:let g:auto_save = 0<cr>

" nnoremap yot :TagbarToggle<cr>

" Note: have to copy these maps to ~/.vim/after/plugin/zmaps.vim because EasyClip is diffcult to control
" nnoremap Y :call rpcnotify( 0, 'mini-browser:scrollBy', 0, -50)<cr>
" nnoremap E :call rpcnotify( 0, 'mini-browser:scrollBy', 0, 50)<cr>
" Worked. But not persuing NyaoVim any more
" nnoremap <silent> Y :call NyaoSplitScroll('up')<cr>
" nnoremap <silent> E :call NyaoSplitScroll('down')<cr>

" Issue: this seems needed to prevent the cursor from jumping to the beginning of the line on the first vertical motion after commenting
nnoremap <silent> gcc :TComment<cr>lh

" .. again, unimpaired overwriting this
" now using: 
" let g:nremap = {'[b': '', ']b': '', '[t': '', ']t': '', '[T': '', ']T': ''}
" obsolete?
" nnoremap <silent> ]t :call BracketStartForw()<cr>
" vnoremap <silent> ]t <esc>:call ChangeVisSel(function('BracketStartForw'))<cr>
" nnoremap <silent> [t :call BracketStartBackw()<cr>
" vnoremap <silent> [t <esc>:call ChangeVisSel(function('BracketStartBackw'))<cr>
" nnoremap <silent> ]T :call BracketEndForw()<cr>
" vnoremap <silent> ]T <esc>:call ChangeVisSel(function('BracketEndForw'))<cr>h
