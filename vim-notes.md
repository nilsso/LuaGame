# vim Notes

Just some things I discovered about vim and the vim runtime utilities I'm using while working on stuff.

## Mappings
```VimL
<leader> = ','
```

### Windows
```VimL
<C-W>h  " Focus left
<C-W>j  " Focus down
<C-W>k  " Focus up
<C-W>l  " Focus right
<C-W>x  " Exchange focused with next
```

### Tabs
```VimL
<leader>tn :tabnew<cr>
<leader>to :tabonly<cr>
<leader>tc :tabclose<cr>
<leader>tm :tabmove
" Open tab with current buffer's path
<leader>te :tabedit <c-r>=expand("%:p:h")<cr>/
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

