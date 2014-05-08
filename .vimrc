"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" for Vundle
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('vim_starting')
   set nocompatible               " Be iMproved
   set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))

 " Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'tpope/vim-surround'
NeoBundle 'vim-scripts/actionscript.vim--Leider'
" NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'Align'
NeoBundle 'w0ng/vim-hybrid'

filetype plugin indent on     " required! 

NeoBundleCheck
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Unite.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 起動時にインサートモードで開始
let g:unite_enable_start_insert = 1

" インサート／ノーマルどちらからでも呼び出せるようにキーマップ
nnoremap <silent> <C-f> :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
inoremap <silent> <C-f> <ESC>:<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> <C-b> :<C-u>Unite buffer file_mru<CR>
inoremap <silent> <C-b> <ESC>:<C-u>Unite buffer file_mru<CR>

" unite.vim上でのキーマッピング
autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()
  " 単語単位からパス単位で削除するように変更
  imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
  " ESCキーを2回押すと終了する
  nmap <silent><buffer> <ESC><ESC> q
  imap <silent><buffer> <ESC><ESC> <ESC>q
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" neocomplcache
let g:neocomplcache_enable_at_startup = 1 " 起動時に有効化


" 行番号表示
set nu

" 文字を回り込ませない
set nowrap

set tabstop=4
set shiftwidth=4
" set hid

"コメント行で改行すると次の行の先頭に自動的にコメント記号が入らないように
"set formatoptions-=ro

set clipboard=unnamed,autoselect

" QuickFix
noremap <C-n> :cn<CR>
noremap <C-p> :cp<CR>

" filetype
au BufNewFile,BufRead *.as set filetype=actionscript


" for Xcode
" http://www.st-prestage.jp/blog/tag/cocoa-vim
augroup MyObjcAutoCmd

autocmd!
"autocmd FileType objc setlocal makeprg=xcodebuild\ -activetarget\ -activeconfiguration\ \\|\ grep\ -e\ "^/.*"\ \\|\ sort\ -u
autocmd FileType objc setlocal makeprg=xcodebuild\ -activetarget\ -activeconfiguration\ \\\|\ grep\ -e\ \"^/.*\"\ \\\|\ sort\ -u

autocmd FileType objc nnoremap <buffer> <d-b> :call XcodeBuildCheck()<CR>
" autocmd FileType objc inoremap <buffer> <d-9> <C-o>:call XcodeBuildCheck()<CR>

function! XcodeBuildCheck() "{{{
	let proj_dir = substitute(b:cocoa_proj, '(.*)/.*' , '1', '')
	let current_dir = getcwd()
	execute ":lcd " . escape(expand(proj_dir), " #\\")
	make
	execute ":lcd " . escape(expand(current_dir), " #\\")
endfunction

augroup END


" http://d.hatena.ne.jp/yuroyoro/20101104/1288879591
" より
"-------------------------------------------------------------------------------
"" ステータスライン StatusLine
"-------------------------------------------------------------------------------
set laststatus=2 " 常にステータスラインを表示

"カーソルが何行目の何列目に置かれているかを表示する
set ruler

" ステータスラインに文字コードと改行文字を表示する
if winwidth(0) >= 120
	set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %F%=[%{GetB()}]\ %l,%c%V%8P
else
	set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %f%=[%{GetB()}]\ %l,%c%V%8P
endif

"入力モード時、ステータスラインのカラーを変更
augroup InsertHook
	autocmd!
	autocmd InsertEnter * highlight StatusLine guifg=#ccdc90 guibg=#2E4340
	autocmd InsertLeave * highlight StatusLine guifg=#2E4340 guibg=#ccdc90
augroup END

function! GetB()
	let c = matchstr(getline('.'), '.', col('.') - 1)
	let c = iconv(c, &enc, &fenc)
	return String2Hex(c)
endfunction
" help eval-examples
" The function Nr2Hex() returns the Hex string of a number.
func! Nr2Hex(nr)
	let n = a:nr
	let r = ""
	while n
		let r = '0123456789ABCDEF'[n % 16] . r
		let n = n / 16
	endwhile
	return r
endfunc
" The function String2Hex() converts each character in a string
" to a two character Hex string.
func! String2Hex(str)
	let out = ''
	let ix = 0
	while ix < strlen(a:str)
		let out = out . Nr2Hex(char2nr(a:str[ix]))
		let ix = ix + 1
	endwhile
	return out
endfunc


"-------------------------------------------------------------------------------
"" 補完・履歴 Complete
"-------------------------------------------------------------------------------
set wildmenu               " コマンド補完を強化
set wildchar=<tab>         " コマンド補完を開始するキー
set wildmode=list:longest  " リスト表示，最長マッチ
set history=1000           " コマンド・検索パターンの履歴数
set complete+=k            " 補完に辞書ファイル追加


"<c-space>でomni補完
imap <c-space> <c-x><c-o>

" -- tabでオムニ補完
function! InsertTabWrapper()
	if pumvisible()
		return "\<c-n>"
	endif
	let col = col('.') - 1
	if !col || getline('.')[col -1] !~ '\k\|<\|/'
		return "\<tab>"
	elseif exists('&omnifunc') && &omnifunc == ''
		return "\<c-n>"
	else
		return "\<c-x>\<c-o>"
	endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>

"-------------------------------------------------------------------------------
"" nerdcommenter
"-------------------------------------------------------------------------------
" コメントした後に挿入するスペースの数
let NERDSpaceDelims = 1
" キーマップの変更。<Leader>=\+cでコメント化と解除を行う。
" コメントされていれば、コメントを外し、コメントされてなければコメント化する。
vmap ./ <Plug>NERDCommenterToggle
