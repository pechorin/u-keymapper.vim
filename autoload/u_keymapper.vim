let s:nvim  = has('nvim')

" TODO:
" - vim-which-key integration

let g:u_keymapper#debug         = 0
let g:u_keymapper#mappings      = []
let g:u_keymapper#current_group = 0


" Load plugin api, should be called before any KeyMap declaration
fu! u_keymapper#init()
  command! -nargs=* KeyMap call s:map_key(<q-args>)
  command! -nargs=* KeyMapGroup call s:map_key_group(<q-args>)
  command! KeyMapGroupEnd call s:map_key_group_end()
  command! KeyMapExportToCSV call u_keymapper#export()
  command! KeyMapExportToTable call u_keymapper#export({'tableize': v:true})
endfu

" Safe and universal keybind mapper
" for vim: regular mapping
" for nvim: mapping with desc attribute
let s:modes_mapping = {
      \"map":      [''],
      \"nmap":     ['n'],
      \"vmap":     ['v'],
      \"xmap":     ['x'],
      \"cmap":     ['c'],
      \"smap":     ['s'],
      \"omap":     ['o'],
      \"imap":     ['i'],
      \"lmap":     ['l'],
      \"tmap":     ['t'],
      \"noremap":  ['',  { "noremap": v:true }],
      \"nnoremap": ['n', { "noremap": v:true }],
      \"vnoremap": ['v', { "noremap": v:true }],
      \"xnoremap": ['x', { "noremap": v:true }],
      \"cnoremap": ['c', { "noremap": v:true }],
      \"snoremap": ['s', { "noremap": v:true }],
      \"onoremap": ['o', { "noremap": v:true }],
      \"inoremap": ['i', { "noremap": v:true }],
      \"lnoremap": ['l', { "noremap": v:true }],
      \"tnoremap": ['t', { "noremap": v:true }],
      \}

" NOTE:
"   Maybe in furute for reverse mapping line <silent> `n <leader>x something`
"   not sure is it legal

" let s:short_modes_mapping = {
"       \'': 'map',
"       \'n': 'nmap',
"       \'v': 'vmap',
"       \'x': 'xmap',
"       \'c': 'cmap',
"       \'s': 'smap',
"       \'i': 'imap',
"       \'l': 'lmap',
"       \'t': 'tmap',
"       \}

" let s:short_modes_noremapping = {
"       \'':  'noremap',
"       \'n': 'nnoremap',
"       \'v': 'vnoremap',
"       \'x': 'xnoremap',
"       \'c': 'cnoremap',
"       \'s': 'snoremap',
"       \'i': 'inoremap',
"       \'l': 'lnoremap',
"       \'t': 'tnoremap',
"       \}

let s:modes_aliases =  {
      \'': ['n', 'v', 'o'],
      \'n': ['n'],
      \'v': ['v'],
      \'x': ['x'],
      \'c': ['c'],
      \}

let s:mapping_args = ["<buffer>", "<nowait>", "<silent>", "<script>", "<expr>", "<unique>"]

" NOTE:
" `!#$%&()*+,./:;<=>?@\^_`{|}~-` -> posix [:punct] without `'` and '"'
let s:command_desc_regexp = "[\"|\'][[:alnum:][:blank:]!#$%&()*+,./:;<=>?@\^_`{|}~—-]\*[\"|\']$"

fu! s:new_mapping() abort
  let obj = {
        \'desc':         0,
        \'without_desc': 0,
        \'lhs':          0,
        \'rhs':          0,
        \'mode':         0,
        \'group':        0,
        \'group_prefix': 0,
        \'options':      {},
        \}

  return obj
endfu

fu! u_keymapper#parse_command_to_mapping(raw_command) abort
  let l:options = {}

  " extract description from all command
  let l:maybe_desc = matchstr(a:raw_command, s:command_desc_regexp)

  " remove quotes and double quotes
  if len(l:maybe_desc)
    let l:maybe_desc = substitute(l:maybe_desc, "'", '', 'g')
    let l:maybe_desc = substitute(l:maybe_desc, "\"", '', 'g')
    let l:options['desc'] = l:maybe_desc
  endif

  " var for command without description (for classic vim map commands
  " style)
  let l:without_desc = substitute(a:raw_command, s:command_desc_regexp, '', '')

  " remove <silent> like args, and store them into object
  let l:without_args = l:without_desc
  for map_opt in s:mapping_args
    let l:m = matchstr(l:without_args, map_opt)

    if len(l:m)
      let l:opt_name = substitute(map_opt, '<', '', '')
      let l:opt_name = substitute(l:opt_name, '>', '', '')
      let l:without_args  = substitute(l:without_args, map_opt, '', '')
      let l:without_args  = substitute(l:without_args, '  ', ' ', '')

      let l:options[l:opt_name] = v:true
    endif
  endfor

  " get cmd
  let l:cmd = matchstr(l:without_args, "^[[:alnum:]]\*")
  let l:without_cmd = substitute(l:without_args, l:cmd, '', '')

  " get mode
  let l:mode_mapping = get(s:modes_mapping, l:cmd)
  let l:mode = l:mode_mapping[0]

  if type(l:mode) != v:t_string
    echoerr 'mode mapping not defined for [' .. l:cmd .. ']'
  endif

  if len(l:mode_mapping) > 1
    let l:options = extend(l:options, l:mode_mapping[1])
  endif

  " get lhs/rhs
  let l:splitted = split(l:without_cmd, ' ')
  let l:lhs = l:splitted[0]
  let l:rhs = l:splitted[1:-1]

  " build virtual mapping dict
  let l:result              = s:new_mapping()
  let l:result.desc         = l:maybe_desc
  let l:result.without_desc = l:without_desc
  let l:result.options      = l:options
  let l:result.lhs          = l:lhs
  let l:result.rhs          = l:rhs
  let l:result.mode         = l:mode
  let l:result.group        = g:u_keymapper#current_group
  let l:result.group_prefix = g:u_keymapper#current_group_prefix

  return l:result
endfu

fu! s:map_key(...) abort
  let l:mapping = g:u_keymapper#parse_command_to_mapping(a:1)

  if g:u_keymapper#debug
    echo 'KeyMap -> ' . string(l:mapping)
  end

  call add(g:u_keymapper#mappings, l:mapping)

  if s:nvim
    call nvim_set_keymap(l:mapping.mode, l:mapping.lhs, join(l:mapping.rhs, ' '), l:mapping.options)
  else
    execute l:mapping.without_desc
  endif
endfu

fu! s:map_key_group(...) abort
  if a:0
    " extract group name
    let l:group_name = matchstr(a:1, s:command_desc_regexp)

    if len(l:group_name)
      " extract prefix
      let l:prefix = substitute(a:1, s:command_desc_regexp, '', '')
      let l:prefix = substitute(l:prefix, ' ', '', 'g')

      " remove " and '
      let l:group_name = substitute(l:group_name, "'", '', 'g')
      let l:group_name = substitute(l:group_name, "\"", '', 'g')

      " assign this group for all followed mappings
      let g:u_keymapper#current_group        = l:group_name
      let g:u_keymapper#current_group_prefix = l:prefix

      " add group to which-key.nvim if installed
      if s:nvim
lua << EOF
        if string.len(vim.g['u_keymapper#current_group_prefix']) > 0 then
          local ok, wk = pcall(require, 'which-key')
          if ok then
            wk.register({
              [ vim.g['u_keymapper#current_group_prefix'] ] = {
                name = vim.g['u_keymapper#current_group']
              }
            })
          end
        end
EOF
      endif
    else
      call s:map_key_group_end()
    endif
  else
    call s:map_key_group_end()
  endif
endfu

fu! s:map_key_group_end() abort
  let g:u_keymapper#current_group = 0
  let g:u_keymapper#current_group_prefix = 0
endfu

fu! s:any_mapping_has_group() abort
  let l:has = v:false

  for m in g:u_keymapper#mappings
    if len(m.group)
      let l:has = v:true
      break
    endif
  endfor

  return l:has
endfu

" Write all your mappings table to current buffer starting current line
"
" options:
"   `{ "write_to_buffer": v:false }` - do not write anything to buffer, just return result
"   `{ "tabelize": v:true }` - use vim-table-mode plugin to format result table
"
" returns:
"   csv string formatter with `;` delimiter
"
" notes:
"
"   you can use return result for any external integration
"
fu! u_keymapper#export(...) abort
  if len(g:u_keymapper#mappings) == 0
    echoerr 'Key mappings not defined via KeyMap command'
    return
  endif

  " where to starte writing
  let initial_line = line('.')

  " cur line to write
  let cur_line = initial_line

  " writed lines counter
  let writed = 0

  " default options
  let options         = {}
  let write_to_buffer = v:true
  let tableize        = v:false

  " parse options
  if a:0 && type(a:1) == v:t_dict
    let options = a:1

    if has_key(options, 'tableize')
      let tableize = options.tableize
    end

    if has_key(options, 'write_to_buffer')
      let write_to_buffer = options.write_to_buffer
    end
  endif

  let with_group = s:any_mapping_has_group()

  let csv = ""
  let header = 'mode; key; command; description'

  if with_group
    let header = header .. '; group'
  endif

  let csv = csv .. header .. "\n"
  if write_to_buffer
    call append(cur_line, header)
    let writed = writed + 1
    let cur_line = cur_line + 1
  end

  if tableize
    call append(cur_line, '|-|')
    let writed = writed + 1
    let cur_line = cur_line + 1
  end

  for vm in g:u_keymapper#mappings
    let line = [
          \join(s:modes_aliases[vm.mode], ','),
          \'`' .. vm.lhs .. '`',
          \join(vm.rhs, ' '),
          \len(vm.desc) ? vm.desc : ''
          \]

    if with_group
      let l:group_name = vm.group

      if type(l:group_name) == v:t_number
        let l:group_name = ''
      endif

      call add(line, l:group_name)
    endif

    let final_line = join(line, '; ')

    let csv = csv .. final_line .. "\n"
    if write_to_buffer
      call append(cur_line, final_line)
      let cur_line = cur_line + 1
      let writed = writed + 1
    end
  endfor

  if tableize
    execute initial_line .. ',' .. cur_line .. 'Tableize/;'
  end

  return csv
endfu
