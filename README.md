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
