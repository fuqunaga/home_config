if has('gui_macvim')
	set transparency=10	" 透明度を指定
	set antialias
	set guioptions-=t	" ツールバー非表示
	set guioptions-=r	" 右スクロールバー非表示
	set guioptions-=R
	set guioptions-=l	" 左スクロールバー非表示
	set guioptions-=L
	set guifont=Osaka-Mono:h14

	set imdisable		" IMを無効化
	
	"フルスクリーンモード	
	" set fuoptions=maxvert,maxhorz
  	" autocmd GUIEnter * set fullscreen 
	
	colorscheme wombat256
endif

