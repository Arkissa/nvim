" lua can't get filetype option on BufReadPost, because lua is so fast,
" even using vim.schedule_wrap there will be not work, will be have
" side effects for that cursor to appear in an unexpected place.
augroup MYVIMRC
    autocmd BufReadPost *
      \ let line = line("'\"")
      \ | if line >= 1 && line <= line("$") && &filetype !~# 'commit'
      \      && index(['xxd', 'gitrebase', 'tutor', 'help'], &filetype) == -1
      \ |   execute "normal! g`\""
      \ | endif
	autocmd BufReadPost *
		\ if index(['xxd', 'gitrebase', 'tutor', 'help', 'commit'], &filetype) == -1
		\	|| index(['quickfix', 'terminal'], &buftype) == -1
		\ | match Search /\s\+$/
		\ | endif
augroup END
