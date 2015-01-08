if has('gui_macvim')
	set antialias
	set guioptions-=t	" ツールバー非表示
	set guioptions-=r	" 右スクロールバー非表示
	set guioptions-=R
	set guioptions-=l	" 左スクロールバー非表示
	set guioptions-=L
	set guifont=Osaka-Mono:h14
	set lines=90 columns=200
endif


" set transparency=220	" 透明度を指定
autocmd FocusGained * set transparency=240
autocmd FocusLost * set transparency=200
" set imdisable		" IMを無効化

"フルスクリーンモード	
" set fuoptions=maxvert,maxhorz
" autocmd GUIEnter * set fullscreen 

syntax enable
colorscheme hybrid

set autoread
