# U-KeyMapper — Universal key mapper for vim and neovim

- Bind your **keybindings** to vim and nvim at the same time (with nvim additional features like keymap description)
- Define **keygroups** for better configuration organization and integration with which-key.nvim
- Export your custom keybindings to csv or table with vim-table-mode and share it with community friends

## Key mappings before and after

Let's imagine what you like me use your nvim for local development and classic vim 8 or 9 for remote machines setup. So maybe you will have something like what in your `.vimrc`:

```viml
let s:nvim  = has('nvim')

if s:nvim
  call nvim_set_keymap('n', '<leader>rf', ':TestFile<CR>', {'silent': v:true, 'desc': 'Run current test file'})
else
  nmap <silent> <leader>rf :TestFile<CR>
endif
```

Now with U-KeyMapper all you have to do is:

```viml
call u_keymapper#init()

KeyMap nmap <silent> <leader>rf :TestFile<CR> "Run current test file"
```

This command will be parsed and executed in according api env (vim or nvim).

## Installation

via vim-plug like tools:

```viml
Plug 'pechorin/u-keymapper.vim'
```

after this before any KeyMap's calls:

```viml
call u_keymapper#init()

" now you can do your mappings with KeyMap command
KeyMap nmap <silent> <leader>rf :TestFile<CR> "Run current test file"
```

## Keygroups

Keygroups usable not only for csv/table export, but also for which-key.nvim integration and better config structure.

```viml
KeyMapGroup <leader>r "Tests runners"
   KeyMap nmap <silent> <leader>rf :TestFile<CR> "Test file"
   KeyMap nmap <silent> <leader>rd :TestFile -f d<CR> "Test file -f d"
   KeyMap nmap <silent> <leader>rn :TestNearest<CR> "Test nearest"
   KeyMap nmap <silent> <leader>rs :TestSuite<CR> "Test suite"
   KeyMap nmap <silent> <leader>rl :TestLast<CR> "Test last"
KeyMapGroupEnd

KeyMapGroup "Navigation"
  KeyMap nmap <leader>et :Tagbar<CR> "Tagbar"
  KeyMap nmap <leader>n :NERDTree<CR> "NERDTree for project"
  KeyMap nmap <leader>N :NERDTree %<CR> "NERDTree for current file"
KeyMapGroupEnd
```

After definitions keygroups with prefix (like `<leader>r`) will be registered in which-key.nvim.

## Export examples

### Table example with vim-table-mode

Execute `:KeyMapExportToTable` command in buffer and you will get result like this:

| mode  | key                   | command                           | description                                  | group                  |
|-------|-----------------------|-----------------------------------|----------------------------------------------|------------------------|
| c     | `<C-A>`               | <Home>                            | Bash-like CTRL+A for command line            | Bash-like keys for cmd |
| c     | `<C-E>`               | <End>                             | Bash-like CTRL+E for command line            | Bash-like keys for cmd |
| c     | `<C-K>`               | <C-U>                             | Bash-like CTRL+K for command line            | Bash-like keys for cmd |
| x     | `ga`                  | <Plug>(EasyAlign)                 | Align in visual mode (e.g. `vipga`)          | Text manipulation      |
| n     | `ga`                  | <Plug>(EasyAlign)                 | Align for a motion/text object (e.g. `gaip`) | Text manipulation      |
| n     | `<leader>et`          | :Tagbar<CR>                       | Tagbar                                       | Navigation             |
| n     | `<leader>n`           | :NERDTree<CR>                     | NERDTree for project                         | Navigation             |
| n     | `<leader>N`           | :NERDTree %<CR>                   | NERDTree for current file                    | Navigation             |
| n     | `<leader>m`           | :Neotree<CR>                      | Neotree                                      | Navigation             |
| n     | `<leader>M`           | :Neotree %<CR>                    | Neotree for current file                     | Navigation             |
| n     | `<leader>,`           | :Neotree buffers<CR>              | Neotree buffers                              | Navigation             |
| n     | `<leader>.`           | :Neotree float git_status<CR>     | Neotree git                                  | Navigation             |
| n     | `<leader>t`           | :tabnew<CR>                       | Create new tab                               | Navigation             |
| n     | `<cmd>t`              | :tabnew<CR>                       | Create new tab                               | Navigation             |
| n     | `<C-ScrollWheelUp>`   | :tabnext<CR>                      | ctrl+mousewheel for tab switching            | Navigation             |
| n     | `<C-ScrollWheelDown>` | :tabprevious<CR>                  | ctrl+mousewheel for tab switching            | Navigation             |
| n,v,o | `<leader>x`           | <cmd>bp\|bd#<CR>                  | Kill current buffer                          | Navigation             |
| n     | `<C-LeftMouse>`       | :AnyJump<CR>                      | Run AnyJump on ctrl+click                    | Navigation             |
| n     | `<leader>c`           | <Plug>CommentaryLine              | Comment current line                         | Commenting             |
| v     | `<leader>c`           | <Plug>Commentary                  | Comment visualy selected text                | Commenting             |
| n     | `<leader>b`           | :Buffers<CR>                      | FZF Buffers                                  | FZF navigation         |
| n     | `<leader>q`           | :Files<CR>                        | FZF Project files                            | FZF navigation         |
| n     | `<leader>ev`          | :Color <CR>                       | FZF Color themes                             | Vim manipulations      |
| n     | `<leader>ee`          | :so %<CR>                         | (vimrc) Eval current file as vimscript       | Vim manipulations      |
| n     | `<leader>ev`          | :e ~/.vimrc <CR>                  | (vimrc) Open $MYVIMRC in current buffer      | Vim manipulations      |
| n     | `<leader>gg`          | :Git<CR>                          | Open Git                                     | Git Mappings           |
| n     | `<leader>gb`          | :Git blame<CR>                    | Git blame for file                           | Git Mappings           |
| n,v,o | `<Leader>y`           | "*y                               | Copy to system clipboard                     | OSX clipboard          |
| n,v,o | `<Leader>p`           | "*p                               | Paste from system clipboard                  | OSX clipboard          |
| n,v,o | `<Leader>Y`           | "+y                               | Copy to editor clipboard                     | OSX clipboard          |
| n,v,o | `<Leader>P`           | "+p                               | Paste from editor clipboard                  | OSX clipboard          |
| n     | `<leader>rf`          | :TestFile<CR>                     | Test file                                    | Tests runners          |
| n     | `<leader>rd`          | :TestFile -f d<CR>                | Test file -f d                               | Tests runners          |
| n     | `<leader>rn`          | :TestNearest<CR>                  | Test nearest                                 | Tests runners          |
| n     | `<leader>rs`          | :TestSuite<CR>                    | Test suite                                   | Tests runners          |
| n     | `<leader>rl`          | :TestLast<CR>                     | Test last                                    | Tests runners          |
| v     | `//`                  | y/\V<C-R>=escape(@",'/\')<CR><CR> | Search visual selected text via //           |                        |
| n     | `<Leader>co`          | :copen<CR>                        | Show quickfix                                |                        |
| n     | `<Leader>cc`          | :cclose<CR>                       | Hide quickfix                                |                        |
| n     | `gR`                  | <CMD>Glance references<CR>        | Glance reference                             |                        |
| n     | `gD`                  | <CMD>Glance definitions<CR>       | Glance definitions                           |                        |
| n     | `gY`                  | <CMD>Glance type_definitions<CR>  | Glance type definitions                      |                        |
| n     | `gM`                  | <CMD>Glance implementations<CR>   | Glance implementations                       |                        |

### CSV example

Execute `:KeyMapExportToCSV` command in buffer and you will get result like this:

```csv
mode; key; command; description; group
c; `<C-A>`; <Home>; Bash-like CTRL+A for command line; Bash-like keys for cmd
c; `<C-E>`; <End> ; Bash-like CTRL+E for command line; Bash-like keys for cmd
c; `<C-K>`; <C-U> ; Bash-like CTRL+K for command line; Bash-like keys for cmd
x; `ga`; <Plug>(EasyAlign); Align in visual mode (e.g. `vipga`); Text manipulation
n; `ga`; <Plug>(EasyAlign); Align for a motion/text object (e.g. `gaip`); Text manipulation
n; `<leader>et`; :Tagbar<CR>; Tagbar; Navigation
n; `<leader>n`; :NERDTree<CR>; NERDTree for project; Navigation
n; `<leader>N`; :NERDTree %<CR>; NERDTree for current file; Navigation
n; `<leader>m`; :Neotree<CR>; Neotree; Navigation
n; `<leader>M`; :Neotree %<CR>; Neotree for current file; Navigation
n; `<leader>,`; :Neotree buffers<CR>; Neotree buffers; Navigation
n; `<leader>.`; :Neotree float git_status<CR>; Neotree git; Navigation
n; `<leader>t`; :tabnew<CR>; Create new tab; Navigation
n; `<cmd>t`; :tabnew<CR>; Create new tab; Navigation
n; `<C-ScrollWheelUp>`; :tabnext<CR>; ctrl+mousewheel for tab switching; Navigation
n; `<C-ScrollWheelDown>`; :tabprevious<CR>; ctrl+mousewheel for tab switching; Navigation
n,v,o; `<leader>x`; <cmd>bp\|bd#<CR>; Kill current buffer; Navigation
n; `<C-LeftMouse>`; :AnyJump<CR>; Run AnyJump on ctrl+click; Navigation
n; `<leader>c`; <Plug>CommentaryLine; Comment current line; Commenting
v; `<leader>c`; <Plug>Commentary; Comment visualy selected text; Commenting
n; `<leader>b`; :Buffers<CR>; FZF Buffers; FZF navigation
n; `<leader>q`; :Files<CR>; FZF Project files; FZF navigation
n; `<leader>ev`; :Color <CR>; FZF Color themes; Vim manipulations
n; `<leader>ee`; :so %<CR>; (vimrc) Eval current file as vimscript; Vim manipulations
n; `<leader>ev`; :e ~/.vimrc <CR>; (vimrc) Open $MYVIMRC in current buffer; Vim manipulations
n; `<leader>gg`; :Git<CR>; Open Git; Git Mappings
n; `<leader>gb`; :Git blame<CR>; Git blame for file; Git Mappings
n,v,o; `<Leader>y`; "*y; Copy to system clipboard; OSX clipboard
n,v,o; `<Leader>p`; "*p; Paste from system clipboard; OSX clipboard
n,v,o; `<Leader>Y`; "+y; Copy to editor clipboard; OSX clipboard
n,v,o; `<Leader>P`; "+p; Paste from editor clipboard; OSX clipboard
n; `<leader>rf`; :TestFile<CR>; Test file; Tests runners
n; `<leader>rd`; :TestFile -f d<CR>; Test file -f d; Tests runners
n; `<leader>rn`; :TestNearest<CR>; Test nearest; Tests runners
n; `<leader>rs`; :TestSuite<CR>; Test suite; Tests runners
n; `<leader>rl`; :TestLast<CR>; Test last; Tests runners
v; `//`; y/\V<C-R>=escape(@",'/\')<CR><CR>; Search visual selected text via //;
n; `<Leader>co`; :copen<CR>; Show quickfix;
n; `<Leader>cc`; :cclose<CR>; Hide quickfix;
n; `gR`; <CMD>Glance references<CR>; Glance reference;
n; `gD`; <CMD>Glance definitions<CR>; Glance definitions;
n; `gY`; <CMD>Glance type_definitions<CR>; Glance type definitions;
n; `gM`; <CMD>Glance implementations<CR>; Glance implementations;
```

### Full .vimrc mapping example

This is my mapping from my [vim-files](https://github.com/pechorin/vim-files):

```viml
call u_keymapper#init()

let mapleader=","

KeyMapGroup "Bash-like keys for cmd"
  KeyMap cnoremap <C-A> <Home> "Bash-like CTRL+A for command line"
  KeyMap cnoremap <C-E> <End>  "Bash-like CTRL+E for command line"
  KeyMap cnoremap <C-K> <C-U>  "Bash-like CTRL+K for command line"
KeyMapGroupEnd

KeyMapGroup "Text manipulation"
  KeyMap xmap ga <Plug>(EasyAlign) "Align in visual mode (e.g. `vipga`)"
  KeyMap nmap ga <Plug>(EasyAlign) "Align for a motion/text object (e.g. `gaip`)"
KeyMapGroupEnd

KeyMapGroup "Navigation"
  KeyMap nmap <leader>et :Tagbar<CR> "Tagbar"
  KeyMap nmap <leader>n :NERDTree<CR> "NERDTree for project"
  KeyMap nmap <leader>N :NERDTree %<CR> "NERDTree for current file"

  " Neotree
  KeyMap nmap <leader>m :Neotree<CR> "Neotree"
  KeyMap nmap <leader>M :Neotree %<CR> "Neotree for current file"
  KeyMap nmap <leader>, :Neotree buffers<CR> "Neotree buffers"
  KeyMap nmap <leader>. :Neotree float git_status<CR> "Neotree git"

  " Tabs
  KeyMap nmap <leader>t :tabnew<CR> "Create new tab"
  KeyMap nmap <cmd>t :tabnew<CR> "Create new tab"

  " ctrl+mousewheel for tab switching
  KeyMap nnoremap <C-ScrollWheelUp> :tabnext<CR> "ctrl+mousewheel for tab switching"
  KeyMap nnoremap <C-ScrollWheelDown> :tabprevious<CR> "ctrl+mousewheel for tab switching"

  KeyMap noremap <leader>x <cmd>bp\|bd#<CR> "Kill current buffer"

  " run AnyJump on ctrl+click
  KeyMap nnoremap <C-LeftMouse> :AnyJump<CR> "Run AnyJump on ctrl+click"
KeyMapGroupEnd

KeyMapGroup "Commenting"
  KeyMap nmap <leader>c <Plug>CommentaryLine "Comment current line"
  KeyMap vmap <leader>c <Plug>Commentary "Comment visualy selected text"
KeyMapGroupEnd

KeyMapGroup "FZF navigation"
  KeyMap nmap <leader>b :Buffers<CR> "FZF Buffers"
  KeyMap nmap <leader>q :Files<CR> "FZF Project files"
KeyMapGroupEnd

" eval current vimscrupt buffer
KeyMapGroup <leader>e "Vim manipulations"
  KeyMap nmap <leader>ev :Color <CR> "FZF Color themes"
  KeyMap nmap <leader>ee :so %<CR> "(vimrc) Eval current file as vimscript"
  KeyMap nmap <leader>ev :e ~/.vimrc <CR> "(vimrc) Open $MYVIMRC in current buffer"
KeyMapGroupEnd

KeyMapGroup <leader>g "Git Mappings"
  KeyMap nmap <leader>gg :Git<CR> "Open Git"
  KeyMap nmap <leader>gb :Git blame<CR> "Git blame for file"
KeyMapGroupEnd

KeyMapGroup "OSX clipboard"
  KeyMap noremap <Leader>y "*y 'Copy to system clipboard'
  KeyMap noremap <Leader>p "*p 'Paste from system clipboard'
  KeyMap noremap <Leader>Y "+y 'Copy to editor clipboard'
  KeyMap noremap <Leader>P "+p 'Paste from editor clipboard'
KeyMapGroupEnd

KeyMapGroup <leader>r "Tests runners"
  KeyMap nmap <silent> <leader>rf :TestFile<CR> "Test file"
  KeyMap nmap <silent> <leader>rd :TestFile -f d<CR> "Test file -f d"
  KeyMap nmap <silent> <leader>rn :TestNearest<CR> "Test nearest"
  KeyMap nmap <silent> <leader>rs :TestSuite<CR> "Test suite"
  KeyMap nmap <silent> <leader>rl :TestLast<CR> "Test last"
KeyMapGroupEnd

" from: https://vim.fandom.com/wiki/Search_for_visually_selected_text
KeyMap vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR> "Search visual selected text via //"

" Show the quickfix window
KeyMap nnoremap <Leader>co :copen<CR> "Show quickfix"

" Hide the quickfix window
KeyMap nnoremap <Leader>cc :cclose<CR> "Hide quickfix"
```
