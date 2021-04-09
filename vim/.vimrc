" }}}
" General: Plugin Install --------------------- {{{

call plug#begin('~/.vim/plugged')

" Indentation
Plug 'hynek/vim-python-pep8-indent'
Plug 'vim-scripts/groovyindent-unix'

" Autocomplete
Plug 'marijnh/tern_for_vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
for coc_plugin in [
      \ 'git@github.com:coc-extensions/coc-svelte.git',
      \ 'git@github.com:fannheyward/coc-markdownlint.git',
      \ 'git@github.com:josa42/coc-docker.git',
      \ 'git@github.com:neoclide/coc-css.git',
      \ 'git@github.com:neoclide/coc-pairs.git',
      \ 'git@github.com:neoclide/coc-html.git',
      \ 'git@github.com:neoclide/coc-json.git',
      \ 'git@github.com:neoclide/coc-python.git',
      \ 'git@github.com:neoclide/coc-rls.git',
      \ 'git@github.com:neoclide/coc-snippets.git',
      \ 'git@github.com:neoclide/coc-tsserver.git',
      \ 'git@github.com:neoclide/coc-yaml.git',
      \ 'git@github.com:iamcco/coc-diagnostic.git',
      \ 'git@github.com:davidroeca/coc-svelte-language-tools.git'
      \ ]
  Plug coc_plugin, {'do': 'yarn install --frozen-lockfile && yarn build'}
endfor

Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install' }

call plug#end()

