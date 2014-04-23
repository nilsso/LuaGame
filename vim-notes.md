# vim Notes

Just some things I discovered about vim and the vim runtime utilities I'm using while working on stuff.

## Mappings
```VimL
<leader> = ','
```

### Windows
```VimL
map <C-h> <C-W>h
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-l> <C-W>l
```

### Tabs
```VimL
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
" Open tab with current buffer's path
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/
```

## Plugins

### Goyo
Distraction free editing (close just as you would any split, tab or window, ``:q``)
```VimL
map <leader>z :Goyo<cr>
```

### NERD Tree
```VimL
map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark
map <leader>nf :NERDTreeFind<cr>
```

