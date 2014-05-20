# vim Notes

Just some things I discovered about vim and the vim runtime utilities I'm using while working on stuff.

## Search and Replace (Regex)
vimregex.com

Replace all occurrences of a *search patter* with a *replacement* within a visual selection.

```VimL
:'<,'>s: "search pattern" : "replacement" :g
```
### Examples
Replace all instances of ``i`` surrounded by non-alphabetic and non-numeric characters (parentheses, braces, spaces, etc.) with ``key`` and maintaining the surrounding characters.
```VimL
:'<,'>s:\([^a-z0-9]\)i\([^a-z0-9]\):\1key\2:g
```
## Mappings
```VimL
<leader> = ','
```

### Fix Indenting
- ``gg`` is to the beginning of the file
- ``=`` is the indent command which can take motions
- ``G`` is to the end of the file

Therefore...
```VimL
gg=G
```
...will fix all lines in the file.

### Folding
``zo``: Open one fold under the cursor
``zO``: Open all folds under the cursor
``zc``: Close one fold under the cursor
``zC``: Close all folds under the cursor
``zR``: Open all folds
``zM``: Close all folds

### Select occurrences
With the cursor on something, ``#`` to highlight all occurrences and cycle between occurrences from top to bottom.

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

