local opt = { silent = true }
vim.keymap.set({ "n", "v", "x" }, ";", ":")
vim.keymap.set("n", "s", "<nop>")
vim.keymap.set("n", "S", ":w<CR>", opt)
vim.keymap.set("n", "Q", ":q<CR>", opt)
vim.keymap.set("n", "<A-s>k", ":e $MYVIMRC<CR>", opt)
vim.keymap.set("n", "<A-r>", ":nohlsearch<CR>", opt)
vim.keymap.set("n", "sr", ":source $MYVIMRC<CR>", opt)
vim.keymap.set("n", "sh", ":set nosplitright<CR>:vsplit<CR>", opt)
vim.keymap.set("n", "sk", ":set splitright<CR>:split<CR>", opt)
vim.keymap.set("n", "sj", ":set nosplitright<CR>:split<CR>", opt)
vim.keymap.set("n", "st", ":tabe<CR>", opt)
vim.keymap.set("n", "si", ":+tabnext<CR>", opt)
vim.keymap.set("n", "su", ":-tabnext<CR>", opt)
vim.keymap.set("n", "<SPACE>q", ":qa<CR>", opt)
vim.keymap.set("n", "<SPACE>j", "<C-w>j", opt)
vim.keymap.set("n", "<SPACE>k", "<C-w>k", opt)
vim.keymap.set("n", "<SPACE>h", "<C-w>h", opt)
vim.keymap.set("n", "<SPACE>l", "<C-w>l", opt)
vim.keymap.set("n", "<SPACE>sp", ":set spell!<CR>", opt)
vim.keymap.set("n", "<Up>", ":res +5<CR>", opt)
vim.keymap.set("n", "<Down>", ":res -5<CR>", opt)
vim.keymap.set("n", "<Left>", ":vertical resize+5<CR>", opt)
vim.keymap.set("n", "<Right>", ":vertical resize-5<CR>", opt)
vim.keymap.set("v", "<C-c>", [["+y]], opt)
vim.keymap.set({ "n", "i" }, "<C-s>v", [["+p]], opt)
vim.keymap.set("v", ">", ">gv", opt)
vim.keymap.set("v", "<", "<gv", opt)
vim.keymap.set("v", "p", '"_dP', opt)
vim.keymap.set("n", "sD", ":bd!<CR>", opt)
