## Ultimate Goal
> [!NOTE]
>
> Do Anything Without Leaving Vim!

## Required
- [nvim >= 0.11](https://github.com/neovim/neovim/releases)
- [git](https://git-scm.com/downloads)
- [tree-sitter](https://github.com/tree-sitter/tree-sitter/releases)

## Install
```bash
git clone --recurse-submodules -b v3 git@github.com:Arkissa/nvim.git ~/.config/nvim && nvim --cmd "helptags ALL"
```

## TODO
- [x] Basic option, keymaps, lsp-keymaps, autocmd.
- [x] Automatic completion for lsp-code, path, keyword.
- [x] Quick fuzzy find files and word in current project on quickfix.
- [ ] Better gitsubmodule install and remove plugin.
- [ ] Better textobject.
- [x] Better built-in terminal.
- [ ] Better built-in formatter.
- [x] Better code action.
- [ ] Better engineering support for different programming language e.g code generator and lint.
  - [x] lintprg api.
- [ ] ~~Make snippets of code~~ Postponed this the neovim not yet ready.
- [ ] unicode input method
- [ ] Haskell dev environment
  - [ ] Hoogle search.
  - [ ] fix cabal hightlight document.
  - [ ] fix hlint jump to strange page
  - [ ] better ghci repl
  - [ ] better ghci DEBUG `maybe TermDebug?`
  - [ ] better format
  - [ ] better code fold
  - [ ] better indent
  - [ ] better ghci interaction
    - [ ] hover visual select expression
  - [ ] better quickfix errorformat api for vim
  - [ ] edit project file
  - [ ] support refactor
  - [ ] support Unit test
  - [ ] support Code Coverage
  - [ ] support cabalfmt
  - [ ] support ctags
  - [ ] support Haddocks
  - [ ] support profile
  - [ ] haskell textobject
  - [ ] haskell toolchains
