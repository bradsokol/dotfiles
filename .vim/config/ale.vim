Plug 'dense-analysis/ale'

let g:ale_lint_on_text_changed = 'never'
let g:ale_open_list = 1
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_linters_ignore = {
      \   'ruby': ['brakeman'],
      \}
