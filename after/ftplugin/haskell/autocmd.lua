Autocmd("BufWritePost", {
	group = Augroup("haskell", {clear = false}),
	buffer = 0,
	command = "LLint! %:p"
})
