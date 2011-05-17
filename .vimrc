set nocompatible                " when there is a .vimrc, this is set automagically; this just for completeness

"" identing of stuff """"""""""""
set autoindent                  " ident when pressing enter.
                                " TODO " look at why smartindent does not work nicely with this .vimrc
set copyindent                  " this preserves the structure of the existing indentation, i.e. the mix of tabs and whitespaces
"set noexpandtab                 " [default value] do not replace tabs with whitespaces. one is for indentation, the other for formatting!
set shiftwidth=4                " [8] how far should >> and << (un)indent?
set smarttab                    " insert/delete a shiftwidth worth of blanks when pressing tab/backspace at the start of the line
set tabstop=4                   " [8] the only true indentation, even Larry Wall says so!

"" appearance of vim """"""""""""
set background=dark             " [light]
set backspace=indent,eol,start  " [indent,eol,start]
set display+=lastline           " [] show as much of the next line as possible instead of replacing long lines with @@@@@@
set laststatus=2                " [1] when to show status bar. 0=never, 1=if there are at least two windows, 2=always
set list                        " make newlines and tabs visible. ( http://www.vim.org/tips/tip.php?tip_id=1274 )
"set matchpairs=(:),{:},[:]      " [(:),{:},[:]] determine what 'showmatch' matches
set matchtime=1                 " [5] how many tenths of a second is 'showmatch' shown
set report=0                    " [2] treshold for reporting how many lines were affected by a change
set ruler                       " our trusty little bugger at the bottom of the screen
set scrolloff=2                 " [0] show at least 2 lines above and below cursor if possible
set shortmess=aI                " [filnxtToO] what messages to shorten
set showfulltag                 " glorified 'ins-completion'. would show a function _with_ parameters as template
set showcmd                     " show number of selected chars, lines, block ind VISUAL mode
set showmatch                   " show matching opening bracket when closing one (only if the opening is visible on screen)
"set showmode                    " [on] show in which mode we are
set textwidth=0                 " [78?] set text width to 0. this is needed because _something_ tries to impose 78 on me from time to time
set visualbell                  " force visual bell in case some terminal does not use it, anyway
set wrap                        " wrap long lines, see 'listchars'

if &encoding == "utf-8"
	set listchars=eol:$,trail:·,tab:»·,extends:>,precedes:<
else
	set listchars=eol:$,trail:-,tab:>-,extends:>,precedes:<
endif

"" searching, replacing, matching
set ignorecase                  " case insensitive search
set incsearch                   " search while you type
set hlsearch                    " hilights the searched string :nosearch to turn off

"" general stuff """"""""""""""""
set history=50                  " [20]
set nostartofline               " [1] do not move to start of line when pressing gg, G and others
"set pastetoggle=<F1>            " press F1 to toggle paste. Deactivated to enable F1 enters paste _and_ insert mode
set splitbelow                  " [off] opens split buffer below the current one, not above
set suffixes+=.info,.aux,.log,.dvi,.bbl,.out,.o,.lo,.so
" \-                            " give these suffixes lower priority for tab completion
set virtualedit=block           " Allow the cursor to move beyond EOL in visual block mode
set wildmenu                    " [off] show hilighted selections when 'wildmode's full is invoked
set wildmode=list:longest,full  " [full] sane tab completion on files
set writebackup                 " when overwriting a file, create backup, update file, remove backup if write was successful

"" no longer in use, but perhaps i want it again, at some point?
"set lazyredraw                  " makes macros faster, but is it worth it?
"set mouse=a                     " [] enable mouse support for konsole etc
"set nomodeline                  " make immune against eeevil scripts :p
"set secure                      " [off] refuse to execute :autocmd in .vimrc and .exrc
"set whichwrap=b,s,<,>           " [b,s] allow those keys to jump between lines

if version >= 600
	set foldenable
	set foldmethod=syntax
	set foldlevelstart=99
endif

if version <= 700
augroup uncompress
	au!
	au BufEnter *.gz     %!gunzip
augroup END
endif

if has('gui_running')
	colorscheme torte
	" koehler is also OK-ish.
	" http://thread.gmane.org/gmane.editors.vim/71899
endif



syntax on                        " the single most useful thing in vim. ever.
filetype indent on

" my perl includes pod
let perl_include_pod = 1

" syntax color complex things like @{${"foo"}}
let perl_extended_vars = 1



au filetype FileType :1

" always jump back to the last position when re-entering a file
if has("autocmd")
"    autocmd BufReadPost *
"      \ if line("'\"") >= 1 && line("'\"") <= line("$")
"      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'gitcommit'
"      \ |   exe "normal! g`\""
"      \ | endif

	autocmd BufReadPost *
		\ if line("'\"") > 0 && line("'\"") <= line("$") |
"		\ if line("'\"") > 0 && line("'\"") <= line("$") && &ft !~# 'commit' && &ft !~# 'rebase' |
		\   exe "normal g`\"" |
		\ endif

	" set various stuff for different filetypes
	" use 'set' to set it for the whole window, 'setlocal' to set it for the buffer
	autocmd FileType gitcommit setlocal textwidth=72
"	autocmd FileType gitcommit +1
"	autocmd FileType gitrebase exe "normal gg"
	autocmd FileType gitrebase exe "normal! g'\"g"
	autocmd FileType help wincmd L
	autocmd FileType html setlocal spell spelllang=en,de
	autocmd FileType mail setlocal spell spelllang=en,de
	autocmd FileType mail setlocal textwidth=72
	autocmd FileType mail highlight beyond_border ctermbg=lightblue
	autocmd FileType mail match     beyond_border /\%>73v.*/
	autocmd FileType mail setlocal foldmethod=expr foldlevel=1 foldminlines=2
	autocmd FileType mail setlocal foldexpr=strlen(substitute(substitute(getline(v:lnum),'\\s','','g'),'[^>].*','',''))
	autocmd FileType markdown setlocal spell spelllang=en,de
	"those claim to be equivalent:
	"setlocal foldexpr=match(substitute(getline(v:lnum),'\\s','','g'),'[^>]\\\|$')
	"setlocal foldexpr=strlen(substitute(getline(v:lnum),'\\s*\\ze>\\\|.*','','g'))
	autocmd BufNewFile,BufRead mail.google.com.* setfiletype mail " Fix for iceweasel's It's all text plugin
	autocmd FileType perl setlocal iskeyword+=:           " Add the colon to the keyword list for Perl files so you CTRL-n on DBI:: etc
	autocmd FileType svn  setlocal textwidth=72           " Even though Bram thinks .vim files needs to default to tw=79, I disagree
	autocmd FileType svn  setlocal spell spelllang=en,de
	if filereadable(expand("~/.vim/plugin/svndiff.vim"))
		autocmd FileType svn call SvnCommitReadDiff()
	else
		autocmd FileType svn echomsg " "
		autocmd FileType svn echomsg "YOU DO NOT HAVE svndiff.vim WHICH IS A VERY VERY BAD IDEA!!!"
		autocmd FileType svn echomsg " "
	endif
	autocmd FileType tex  setlocal spell spelllang=en,de
endif



" This function will check if VIM finds modelines and, if yes, will let you
" choose if you want to execute them. Edit default to enable or disable,
" according to your needs. You can use y and n, as well.
function s:CheckForModelines()
	" 'default' may only be set to e[nable], d[isable] and, for convenience, y[es] or n[o]
	let default = 'd'

	if default != 'e' && default != 'd' && default != 'y' && default != 'n'
		echoerr "Error in function CheckForModelines: Please set 'default' to 'e', 'd', 'y' or 'n'"
	endif
	if !exists('+modelines') || &modelines < 1 || ( !&modeline && !exists('b:modeline') )
		return -1
	endif
	let m=''
	if &modelines>line('$')
		sil exe '%g/\<vim:\|\<vi:\|\<ex:/let m=m."\n".getline(".")'
	else
		sil exe '1,'.&modelines.'g/\<vim:\|\<vi:\|\<ex:/let m=m."\n".getline(".")'
		sil exe '$-'.(&modelines-1).',$g/\<vim:\|\<vi:\|\<ex:/let m=m."\n".getline(".")'
	endif
	if strlen(m)
		echo m
		let j = '-'
		while j != 'e' && j != 'd' && j != 'y' && j != 'n' && j != ''
			if default == 'e' || default == 'y'
				let j = input('Modelines found! [E]nable [d]isable):','','expression')
			elseif default == 'd' || default == 'n'
				let j = input('Modelines found! [e]nable [D]isable):','','expression')
			endif
		endwhile
		let &l:modeline = (j=='e' || j=='y' || (j=='' && (default=='e' || default=='y')))
		let b:modeline = 1
	endif
endfunction
au BufReadPost * call s:CheckForModelines()


"Split a paragraph into one sentence per line
"map gqs vipJ0:call SplitLineBySentence()<CR>
function! SplitLineBySentence()
	let lastline=line('.')
	let lastcol=col('.')
	normal )
	while lastline==line('.') && lastcol!=col('.') && col('.')<col('$')-1
		exe "normal hviws\<CR>\<Esc>"
		let lastline=line('.')
		let lastcol=col('.')
		normal )
	endwhile
	normal {+
endfunction


" Comment the last selected visual area when applicable
function! Comment()
	execute "normal msHmtgg"
	if &filetype == "python" || &filetype == "zsh" || &filetype == "sh" || &filetype == "gnuplot"
		execute ":'<,'>s/^/\# /"
	elseif &filetype == "cpp" || &filetype == "c" || &filetype == "nesc" || &filetype == "java"
		execute ":'<,'>s@^@// @"
	elseif &filetype == "xml" || &filetype == "html"
		execute ":'<-1put='<!--'"
		execute ":'>put='-->'"
	elseif &filetype == "tex" || &filetype == "bib"
		execute ":'<,'>s/^/% /"
	elseif &filetype == "vim"
		execute ":'<,'>s/^/\" /"
	endif
	execute "normal 'tzt`s"
endfunction
vnoremap <silent> # <Esc>:call Comment()<CR>


" Transpose a matrix
function! Transpose() range
	echo "Transposing matrix on ',' without space"
	let array = []
	for l in getline(a:firstline,a:lastline)
		call add(array,[])
		call extend(array[-1],split(l,','))
	:d
	endfor
	for i in range(len(array[0]))
		call append(a:firstline+i-1,join(map(copy(array),'v:val[i]'),','))
	endfor
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


map <space> <S-Down>

"" map keys to stuff i like """"""
" enable [shift]-tab in visual mode
vmap <tab>   >gv
vmap <s-tab> <gv

" only search in visual range if visual is active
" this seems to keep some crud in the search buffer and fails when you try to
" repeat it :/
"vmap / y/<C-R>"<CR>


" and normal mode
nmap <tab>   >>
nmap <s-tab> <<

" This has been made unnecessary by using Vim's built-in features.
"" decent block opening - this will indent and close the block after {<CR>
"imap {<cr> {<cr><tab><cr><bs>}<up><end>

" toggle paste - I could use set pastetoggle=<F1> as well
map <F1> :set paste<CR>i
ounmap <F1>
"imap <F1> <ESC>:set invpaste<CR>a
set pastetoggle=<F1>

" toggle list
map <F2> :set invlist<CR>
ounmap <F2>
imap <F2> <ESC>:set invlist<CR>a

" toggle numbers
map <F3> :set invnumber<CR>:set invrelativenumber<CR>
ounmap <F3>
imap <F3> <ESC>:set invnumber<CR>:set invrelativenumber<CR>

" toggle cursor crosshair
set cursorline
set cursorcolumn
:hi CursorLine   cterm=NONE ctermbg=DarkGray ctermfg=white guibg=DarkGray guifg=white
:hi CursorColumn cterm=NONE ctermbg=DarkGray ctermfg=white guibg=DarkGray guifg=white
map <F4> :set invcursorline <CR>:set invcursorcolumn<CR>
ounmap <F4>
imap <F4> <ESC>:set invcursorline<CR>:set invcursorcolumn<CR>a


" map Diff to F8
map <F8> :Diff<CR>
ounmap <F8>
imap <F8> <ESC>:Diff<CR>a

" update differ info to include newly equal lines (this might not be needed with vim7 any more)
map  <F9> :diffupdate<CR>
ounmap <F9>
imap <F9> <ESC>:diffupdate<CR>a

" redraw syntax hilighting
noremap <F12> :syntax sync fromstart<cr>
inoremap <F12> <esc>:syntax sync fromstart<cr>a


" display the diff between current buffer and file on disk
function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  " new | r # | normal 1Gdd - for horizontal split
  vnew | r # | normal 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
" TODO when closing the scratch buffer, unset diff mode for the original
" window
endfunction
com! Diff call s:DiffWithSaved()


" source external files
if filereadable(expand("~/work/svn/richih/config/home/vim/cr-bs-del-space-tab.vim"))
	source ~/work/svn/richih/config/home/vim/cr-bs-del-space-tab.vim
endif

" This script can align stuff according to various rules.
" See 'documentation' at http://drchip.0sites.net/astronaut/vim/align.html
" It is very important to note that one first sets the behaviour with
" :AlignCtrl, then marks or selects a range and then executes :Align
" Else it will just not work without any sane error message (well, it does
" make sense afterwards..)
" Use :AlignCtrl I= =>      :Align
" to ident new object instantaions in Perl
if filereadable("/usr/share/vim-scripts/plugin/Align.vim")
	source /usr/share/vim-scripts/plugin/Align.vim
endif


"""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""
" Little helpers:
"   When browsing a directory, use X to split the file into a new window/tab:
"   o	horizontal
"   v	vertical
"   P	previous window
"   t	new tab
"
"   When trying to find out about where a variable was set, use the 'verbose' keyword
"   :verbose set iskeyword
"
"   When searching
"   <C-l> while doing incremental search adds the next char of current match to search string
"
"   When in normal mode
"   <C-a> increments numbers
"   <C-x> decreases  numbers
"   gf opens file {name} under cursor
"
"   When you want to redirect output of a command within vim, use redir
"   :help redir
"
"   Edit binary files
"   vi somefile
"   :%!xxd
"   (editing)
"   :%!xxd -r
"
"   Show all chars after column 78 as TODO
"   :match Todo /\%>77v.*/
"
"   Sort on /match/
"   :%sort /match/ r
"
"   Bitflipping
"   :%s/[01]/\=1-submatch(0)/g
"
"   Funstuff
"   :help!
"   :help 42
"   :help holy-grail

" Custom leaders

let mapleader = ","
map ,m :!make<Enter><Enter>
map ,M :write<Enter>:!make<Enter><Enter>

"" useless funstuff """"""""""""""
" set revins rightleft rightleftcmd "use rl instead of rightleft to disguise it
" ggVGg? (as key sequence) rot13s the file

" source any local vimrc which might or might not be existant
if filereadable(expand("~/.vimrc.local"))
	source ~/.vimrc.local
endif

"" useful stuff:
" replace on lines     matching identstring: :g/identstring/s/pattern/replacement/
" replace on lines NOT matching identstring: :v/identstring/s/pattern/replacement/
" split a line (note that i do not enter insert mode!)   exec "normal i\<cr>"
