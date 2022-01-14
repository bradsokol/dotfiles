Plug 'vim-test/vim-test'

let test#strategy = "dispatch"
nmap <silent> <leader>t :TestFile<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>n :TestNearest<CR>
nmap <silent> <leader>s :TestSuite<CR>
