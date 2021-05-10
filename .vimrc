":finish

"set smarttab
"set smartindent
" set lbr ；linebreak,应该关闭，否则中文显示时折行不会在一句话的内部，只会在空格的地方断开
set fo+=mB
set sm
set selection=inclusive
set wildmenu
set mousemodel=popup
" renyong
set fdm=syntax
au FileType text set fdm=marker fo+=mM
"sometimes open a txt, then open a cpp in the same vim
au BufNewFile,BufRead *.{cpp,c,cc,cxx,h,hpp} setlocal fdm=syntax
" json file and elzr/vim-json plugin. did_indent=1, otherwise will very slow opening a 10M file
au BufNewFile,BufRead *.json set fdm=indent syntax=json 
au BufNewFile,BufRead *.json let b:did_indent=1
"avoid namespace content indent, ref: http://stackoverflow.com/questions/2549019/how-to-avoid-namespace-content-indentation-in-vim
set cino=N-s
au BufNewFile,BufRead *.{md,markdown,MD} :command! Mp MarkdownPreview
au BufNewFile,BufRead *.{md,markdown,MD} :command! Lp LivedownPreview
au BufNewFile,BufRead *.{md,markdown,MD} :command! Lk LivedownKill

" back to the parent when in tree/blob.
autocmd User fugitive 
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif

" Don't indent template
" ref: http://stackoverflow.com/questions/2549019/how-to-avoid-namespace-content-indentation-in-vim
" http://stackoverflow.com/questions/387792/vim-indentation-for-c-templates -- this code not work for me
function! CppNoTemplateIndent()
  let l:cline_num = line('.')
  let l:pline_num = prevnonblank(l:cline_num - 1)
  let l:pline = getline(l:pline_num)
  let l:retv = cindent('.')
  while l:pline =~# '\(^\s*{\s*\|^\s*//\|^\s*/\*\|\*/\s*$\)'
    let l:pline_num = prevnonblank(l:pline_num - 1)
    let l:pline = getline(l:pline_num)
  endwhile
  if l:pline =~# '^\s*template.*'
    let l:retv = 0
  endif
  return l:retv
endfunction

if has("autocmd")
    autocmd BufEnter *.{cc,cxx,cpp,h,hh,hpp,hxx} setlocal indentexpr=CppNoTemplateIndent()
endif

" help formatoptions 有
" m：在多字节字符处可以折行，对中文特别有效（否则只在空白字符处折行）； --  这应该指的是输入模式下
" M：在拼接两行时（重新格式化，或者是手工使用“J”命令），如果前一行的结尾或后一行的开头是多字节字符，则不插入空格，非常适合中文
" 我想解决刚打开cpp文件时c-support有些功能没有调用的bug，然而下面的语句并没有作用,参考vim.txt 2016.07.28
"au FileType cpp source ~/.vim/ftplugin/c.vim
au BufNewFile,BufRead *.{cpp,c,h,hpp,cc} set filetype=cpp
"au BufNewFile,BufRead *.{cpp,c,h,hpp,cc} set textwidth=80
au BufNewFile,BufRead *.{log,LOG,info,INFO} set filetype=text

"csupport
"let g:C_InsertFileHeader='no'
let g:C_MapLeader='\'

let mapleader = ","
let g:mapleader = ","
let maplocalleader = ","
nmap <leader>w :w!<cr>
"set clipboard=unnamedplus "on mac, seems to not recognize this, and yy cmd
"not copy to the reg *
"共享剪贴板  
set clipboard=unnamed 
set go+=a "从vim中能复制到系统剪贴板
set go+=b "水平滚动条
map <C-F12> <esc>:!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<cr><cr>
" insert current time
"imap <F3> <C-R>=strftime("%Y%m%d %H:%M")<CR>
imap <F3> <C-R>=strftime("%Y.%m.%d")<CR>
" 让vimrc配置变更在vimrc中立即生效
" autocmd BufWritePost $MYVIMRC source $MYVIMRC

au FileType php setlocal dict+=~/.vim/dict/php_funclist.dict
au FileType css setlocal dict+=~/.vim/dict/css.dict
au FileType c setlocal dict+=~/.vim/dict/c.dict
au FileType cpp setlocal dict+=~/.vim/dict/cpp.dict
au FileType scale setlocal dict+=~/.vim/dict/scale.dict
au FileType javascript setlocal dict+=~/.vim/dict/javascript.dict
au FileType html setlocal dict+=~/.vim/dict/javascript.dict
au FileType html setlocal dict+=~/.vim/dict/css.dict
"
let g:pathogen_disabled = []

"syntastic相关
execute pathogen#infect()
let g:syntastic_python_checkers=['pylint']
let g:syntastic_php_checkers=['php', 'phpcs', 'phpmd']
"golang
"Processing... % (ctrl+c to stop)
"let g:fencview_autodetect=0
"set rtp+=$GOROOT/misc/vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 显示相关  
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on
"set cul "高亮光标所在行
"set cuc
set shortmess=atI   " 启动的时候不显示那个援助乌干达儿童的提示  
"set go=             " 不要图形按钮  
color desert     " 设置背景主题  
"color ron     " 设置背景主题  
"color torte     " 设置背景主题  
"set guifont=Courier_New:h10:cANSI   " 设置字体  
if has("gui_macvim")
  set guifont=Monaco:h13
else
  set guifont=Monospace\ 13
endif
"autocmd InsertLeave * se nocul  " 用浅色高亮当前行  
autocmd InsertEnter * se cul    " 用浅色高亮当前行  
set ruler           " 显示标尺  
set showcmd         " 输入的命令显示出来，看的清楚些  
"set whichwrap+=<,>,h,l   " 允许backspace和光标键跨越行边界(不建议)  
set scrolloff=3     " 光标移动到buffer的顶部和底部时保持3行距离  
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}   "状态行显示的内容  
set laststatus=2    " 启动显示状态行(1),总是显示状态行(2)  
"set foldenable      " 允许折叠  
""set foldmethod=manual   " 手动折叠  
set nocompatible  "去掉讨厌的有关vi一致性模式，避免以前版本的一些bug和局限  
" 显示中文帮助
if version >= 603
	set helplang=cn
	"set encoding=utf-8
endif
" 自动缩进
set autoindent
set cindent
" 防止insert模式下 #被自动移到行首，去掉缩进
set nosmartindent
set cinkeys-=0#
set indentkeys-=0#

" Tab键的宽度
set tabstop=2
" 统一缩进为2
set softtabstop=2
set shiftwidth=2
" 使用空格代替制表符
set expandtab
" 在行和段开始处使用制表符
"set smarttab
" 显示行号
set number
" 历史记录数
set history=1000
"搜索逐字符高亮
set hlsearch
set incsearch
"语言设置
set langmenu=zh_CN.UTF-8
set helplang=cn
" 总是显示状态行
set cmdheight=1
" 侦测文件类型
filetype on
" 载入文件类型插件
filetype plugin on
" 为特定文件类型载入相关缩进文件
filetype indent on
" 保存全局变量
set viminfo+=!
" 带有如下符号的单词不要被换行分割
set iskeyword+=_,$,@,%,#,-
" 字符间插入的像素行数目

"markdown配置
au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn}   set filetype=mkd
au BufRead,BufNewFile *.{go}   set filetype=go
au BufRead,BufNewFile *.{js}   set filetype=javascript
"rkdown to HTML  
"nmap md :!~/.vim/markdown.pl % > %.html <CR><CR>
"nmap fi :!firefox %.html & <CR><CR>
nmap \ \cc
vmap \ \cc

"将tab替换为空格
nmap tt :%s/\t/    /g<CR>
" remap command mode `tab sb`.
"cnoremap tb tab sb
cnoremap <C-t> tab sb<Enter>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""新文件标题
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"新建.c,.h,.sh,.java文件，自动插入文件头 
"autocmd BufNewFile *.cpp,*.[ch],*.sh,*.rb,*.java,*.py exec ":call SetTitle()" 
autocmd BufNewFile *.sh,*.rb,*.java,*.py exec ":call SetTitle()" 
""定义函数SetTitle，自动插入文件头 
func SetTitle() 
	"如果文件类型为.sh文件 
	if &filetype == 'sh' 
		call setline(1,"\#!/bin/bash") 
		call append(line("."), "") 
    elseif &filetype == 'python'
        call setline(1,"#!/usr/bin/env python")
        call append(line("."),"# coding=utf-8")
	    call append(line(".")+1, "") 

    elseif &filetype == 'ruby'
        call setline(1,"#!/usr/bin/env ruby")
        call append(line("."),"# encoding: utf-8")
	    call append(line(".")+1, "")

"    elseif &filetype == 'mkd'
"        call setline(1,"<head><meta charset=\"UTF-8\"></head>")
	else 
		call setline(1, "/*************************************************************************") 
		call append(line("."), "	> File Name: ".expand("%")) 
		call append(line(".")+1, "	> Author: ") 
		call append(line(".")+2, "	> Mail: ") 
		call append(line(".")+3, "	> Created Time: ".strftime("%c")) 
		call append(line(".")+4, " ************************************************************************/") 
		call append(line(".")+5, "")
	endif
	if expand("%:e") == 'cpp'
		call append(line(".")+6, "#include<iostream>")
		call append(line(".")+7, "using namespace std;")
		call append(line(".")+8, "")
	endif
	if &filetype == 'c'
		call append(line(".")+6, "#include<stdio.h>")
		call append(line(".")+7, "")
	endif
	if expand("%:e") == 'h'
		call append(line(".")+6, "#ifndef _".toupper(expand("%:r"))."_H")
		call append(line(".")+7, "#define _".toupper(expand("%:r"))."_H")
		call append(line(".")+8, "#endif")
	endif
	if &filetype == 'java'
		call append(line(".")+6,"public class ".expand("%:r"))
		call append(line(".")+7,"")
	endif
	"新建文件后，自动定位到文件末尾
endfunc 

autocmd BufNewFile * normal G


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"键盘命令
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
:nmap <silent> <F9> <ESC>:Tlist<RETURN>
" shift tab pages
map <S-Left> :tabp<CR>
map <S-Right> :tabn<CR>
map! <C-Z> <Esc>zzi
map! <C-O> <C-Y>,
map <C-A> ggVG$"+y
map <F12> gg=G
" 窗口切换
"map <C-w> <C-w>w " can not enable this because conflict with below
map <C-j> <C-w><C-j>
map <C-k> <C-w><C-k>
map <C-h> <C-w><C-h>
map <C-l> <C-w><C-l>
"imap <C-k> <C-y>,
"imap <C-t> <C-q><TAB>
"imap <C-j> <ESC>
" 选中状态下 Ctrl+c 复制
"map <C-v> "*pa
"imap <C-v> <Esc>"*pa
"inoremap <C-V> <C-R>+
"imap <C-V> <C-R>+
" 2018.09.16 use <C-b> to paste as C-V> seems conflict with system paste.
inoremap <C-b> <C-R>*
"noremap <C-V> <C-R>+
imap <C-a> <Esc>^
imap <C-e> <Esc>$
vmap <C-c> "+y
set mouse=v
"去空行  
"nnoremap <F2> :g/^\s*$/d<CR> 
"拷贝当前路径和文件名
noremap <silent> <F2> :let @*=expand("%:p")<CR>
"比较文件  
nnoremap <C-F2> :vert diffsplit 
"nnoremap <Leader>fu :CtrlPFunky<Cr>
"nnoremap <C-n> :CtrlPFunky<Cr>
"列出当前目录文件  
"map <F3> :NERDTreeToggle<CR>
"imap <F3> <ESC> :NERDTreeToggle<CR>
map tw :NERDTreeToggle<CR>
map tf :NERDTreeFind<CR>

"打开树状文件目录  
map <C-F3> \be  
:autocmd BufRead,BufNewFile *.dot map <F5> :w<CR>:!dot -Tjpg -o %<.jpg % && eog %<.jpg  <CR><CR> && exec "redr!"
"C，C++ 按F5编译运行
map <F5> :call CompileRunGcc()<CR>
func! CompileRunGcc()
	exec "w"
	if &filetype == 'c'
		exec "!g++ % -o %<"
		exec "!time ./%<"
	elseif &filetype == 'cpp'
		exec "!g++ % -o %<"
		exec "!time ./%<"
	elseif &filetype == 'java' 
		exec "!javac %" 
		exec "!time java %<"
	elseif &filetype == 'sh'
		:!time bash %
	elseif &filetype == 'python'
		exec "!time python2.7 %"
    elseif &filetype == 'html'
        exec "!firefox % &"
    elseif &filetype == 'go'
"        exec "!go build %<"
        exec "!time go run %"
    elseif &filetype == 'mkd'
        exec "!~/.vim/markdown.pl % > %.html &"
        exec "!firefox %.html &"
	endif
endfunc
"C,C++的调试
map <F8> :call Rungdb()<CR>
func! Rungdb()
	exec "w"
	exec "!g++ % -g -o %<"
	exec "!gdb ./%<"
endfunc


"代码格式优化化

map <F6> :call FormartSrc()<CR><CR>

"定义FormartSrc()
func FormartSrc()
    exec "w"
    if &filetype == 'c'
        exec "!astyle --style=ansi -a --suffix=none %"
    elseif &filetype == 'cpp' || &filetype == 'hpp'
        exec "r !astyle --style=ansi --one-line=keep-statements -a --suffix=none %> /dev/null 2>&1"
    elseif &filetype == 'perl'
        exec "!astyle --style=gnu --suffix=none %"
    elseif &filetype == 'py'||&filetype == 'python'
        exec "r !autopep8 -i --aggressive %"
    elseif &filetype == 'java'
        exec "!astyle --style=java --suffix=none %"
    elseif &filetype == 'jsp'
        exec "!astyle --style=gnu --suffix=none %"
    elseif &filetype == 'xml'
        exec "!astyle --style=gnu --suffix=none %"
    else
        exec "normal gg=G"
        return
    endif
    exec "e! %"
endfunc
"结束定义FormartSrc


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""实用设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("autocmd")
      autocmd BufReadPost *
          \ if line("'\"") > 0 && line("'\"") <= line("$") |
          \   exe "normal g`\"" |
          \ endif
endif
"当打开vim且没有文件时自动打开NERDTree
autocmd vimenter * if !argc() | NERDTree | endif
" 只剩 NERDTree时自动关闭
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" 设置当文件被改动时自动载入
set autoread
" quickfix模式
autocmd FileType c,cpp map <buffer> <leader><space> :w<cr>:make<cr>
"代码补全 
set completeopt=preview,menu 
"允许插件  
"filetype plugin on
"自动保存
set autowrite
"set ruler                   " 打开状态栏标尺
"set cursorline              " 突出显示当前行
set magic                   " 设置魔术
set guioptions-=T           " 隐藏工具栏
set guioptions-=m           " 隐藏菜单栏
""set foldcolumn=0
""set foldmethod=indent 
""set foldlevel=3 
" 不要使用vi的键盘模式，而是vim自己的
set nocompatible
" 去掉输入错误的提示声音
set noeb
" 在处理未保存或只读文件的时候，弹出确认
set confirm
"禁止生成临时文件
set nobackup
set noswapfile
"搜索忽略大小写
"set ignorecase




set linespace=0
" 增强模式中的命令行自动完成操作
set wildmenu
" 使回格键（backspace）正常处理indent, eol, start等
set backspace=2
" 允许backspace和光标键跨越行边界
set whichwrap+=<,>,h,l
" 可以在buffer的任何地方使用鼠标（类似office中在工作区双击鼠标定位）
set mouse=a
"set selection=exclusive
set selectmode=mouse,key
" 通过使用: commands命令，告诉我们文件的哪一行被改变过
set report=0
" 在被分割的窗口间显示空白，便于阅读
set fillchars=vert:\ ,stl:\ ,stlnc:\
" 高亮显示匹配的括号
set showmatch
" 匹配括号高亮的时间（单位是十分之一秒）
set matchtime=1
" 光标移动到buffer的顶部和底部时保持3行距离
set scrolloff=3
" 为C程序提供自动缩进
"自动补全
"":inoremap ( ()<ESC>i
"":inoremap ) <c-r>=ClosePair(')')<CR>
":inoremap { {<CR>}<ESC>O
":inoremap } <c-r>=ClosePair('}')<CR>
"":inoremap [ []<ESC>i
"":inoremap ] <c-r>=ClosePair(']')<CR>
"":inoremap " ""<ESC>i
"":inoremap ' ''<ESC>i
""function! ClosePair(char)
""	if getline('.')[col('.') - 1] == a:char
""		return "\<Right>"
""	else
""		return a:char
""	endif
""endfunction
filetype plugin indent on 
"打开文件类型检测, 加了这句才可以用智能补全
set completeopt=longest,menu
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CTags的设定  
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let Tlist_Sort_Type = "name"    " 按照名称排序  
let Tlist_Use_Right_Window = 1  " 在右侧显示窗口  
let Tlist_Compart_Format = 1    " 压缩方式  
let Tlist_Exist_OnlyWindow = 1  " 如果只有一个buffer，kill窗口也kill掉buffer  
""let Tlist_File_Fold_Auto_Close = 0  " 不要关闭其他文件的tags  
""let Tlist_Enable_Fold_Column = 0    " 不要显示折叠树  
"let Tlist_Show_One_File=1            "不同时显示多个文件的tag，只显示当前文件的
"设置tags  
set tags=tags;  
set autochdir 

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"其他东东
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"默认打开Taglist 
let Tlist_Auto_Open=0 
"""""""""""""""""""""""""""""" 
" Tag list (ctags) 
"""""""""""""""""""""""""""""""" 
let Tlist_Ctags_Cmd = '/usr/local/bin/ctags' 
let Tlist_Show_One_File = 1 "不同时显示多个文件的tag，只显示当前文件的 
let Tlist_File_Fold_Auto_Close = 1
let Tlist_Exit_OnlyWindow = 1 "如果taglist窗口是最后一个窗口，则退出vim 
"let Tlist_Use_Right_Window = 1 "在右侧窗口中显示taglist窗口
let Tlist_Use_Right_Window = 0 "在右侧窗口中不显示taglist窗口
" minibufexpl插件的一般设置
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1  
"nmap tl :Tlist<cr>
nmap tg :Tlist<cr>

"python补全
let g:pydiction_location = '~/.vim/after/complete-dict'
let g:pydiction_menu_height = 20
let Tlist_Ctags_Cmd='/usr/local/bin/ctags'
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1


let g:fencview_autodetect=1
map <F11> :FencView<CR>
"set iskeyword+=.
"set termencoding=utf-8
set encoding=utf-8
let &termencoding=&encoding
" 新建文件时文件编码默认为utf-8
set fileencoding=utf-8
" 打开文件时按照fileencodings指定的文件编码顺序进行检测
set fileencodings=utf-8,ucs-bom,gbk,cp936,gb2312,gb18030

autocmd FileType python set omnifunc=pythoncomplete#Complete
filetype plugin on
set omnifunc=syntaxcomplete#Complete

"set nocompatible               " be iMproved
"filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

" My Bundles here:
"
" original repos on github
Bundle 'tpope/vim-fugitive'
"Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
Bundle 'Yggdroot/indentLine'
"Bundle 'Valloric/YouCompleteMe'
Bundle 'hari-rangarajan/CCTree'
let g:indentLine_char = '┊'
"ndle 'tpope/vim-rails.git'
" vim-scripts repos
Bundle 'L9'
"Bundle 'FuzzyFinder'
" non github repos
"Bundle 'https://github.com/wincent/command-t.git'
Bundle 'Shougo/unite.vim'
Bundle 'Shougo/vimproc.vim'
"MRU Most Recently Used
Bundle 'Shougo/neomru.vim'
"Saves yank history includes unite.vim history/yank source.
Bundle 'Shougo/neoyank.vim'
Bundle 'Shougo/unite-outline'
"A source of unite.vim for history of command/search.
Bundle 'thinca/vim-unite-history'
Bundle 'devjoe/vim-codequery'
Bundle 'skwp/greplace.vim'
"Bundle 'Auto-Pairs'
Bundle 'extr15/Auto-Pairs'
Bundle 'python-imports.vim'
Bundle 'CaptureClipboard'
"Bundle 'ctrlp-modified.vim'
Bundle 'last_edit_marker.vim'
Bundle 'synmark.vim'
"Bundle 'Python-mode-klen'
"Bundle 'SQLComplete.vim'
"Bundle 'Javascript-OmniCompletion-with-YUI-and-j'
"Bundle 'JavaScript-Indent'
"Bundle 'Better-Javascript-Indentation'
"Bundle 'jslint.vim'
"Bundle "pangloss/vim-javascript"
Bundle 'Vim-Script-Updater'
"Bundle 'ctrlp.vim'
"Bundle 'tacahiroy/ctrlp-funky'
"Bundle 'jsbeautify'
Bundle 'The-NERD-Commenter'
Bundle 'fholgado/minibufexpl.vim'
Bundle 'rdnetto/YCM-Generator'
Bundle 'CodeFalling/fcitx-vim-osx'
Bundle 'lyuts/vim-rtags'
Bundle 'derekwyatt/vim-fswitch'
Bundle 'hynek/vim-python-pep8-indent'
Bundle 'LaTeX-Box-Team/LaTeX-Box'
Bundle 'mhinz/vim-hugefile'
Bundle 'elzr/vim-json'
Bundle 'Konfekt/FastFold'
Bundle 'octol/vim-cpp-enhanced-highlight'
Bundle 'rhysd/vim-clang-format'
Bundle 'airblade/vim-gitgutter'
Bundle 'mileszs/ack.vim'
Bundle 'inkarkat/vim-mark'
"Bundle 'c-support'
"django
"Bundle 'django_templates.vim'
"Bundle 'Django-Projects'

"Bundle 'FredKSchott/CoVim'
"Bundle 'djangojump'
Bundle 'iamcco/mathjax-support-for-mkdp'
Bundle 'iamcco/markdown-preview.vim'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'
Bundle 'majutsushi/tagbar'
Bundle 'shime/vim-livedown'

"Bundle 'godlygeek/tabular'
"Bundle 'plasticboy/vim-markdown'

Bundle 'gabrielelana/vim-markdown'
Bundle 'nelstrom/vim-visual-star-search'

Bundle 'junegunn/fzf', {'do' : {-> fzf#install() } }
Bundle 'junegunn/fzf.vim'
Bundle 'mkitt/tabline.vim'
Bundle 'rickhowe/diffchar.vim'

" ...
let g:html_indent_inctags = "html,body,head,tbody"
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"

let g:LatexBox_latexmk_options = " -pdflatex='xelatex -synctex=1 \%O \%S' "
let g:LatexBox_viewer = "/Applications/Skim.app/Contents/MacOS/Skim "
let g:tex_no_math = 1

" tagbar
"let g:tagbar_left = 1
" display more compact or more spacious.
let g:tagbar_indent = 0

nnoremap tb :TagbarToggle<CR>
" markdown-preview
let g:mkdp_refresh_slow = 0
" vim-surround. `q` means `quote`, this is for markdown file.
xmap q <Plug>VSurround`
:xnoremap S3 <esc>`<O<esc>S```<esc>`>o<esc>S```<esc>k$
"ack.vim, config to use ag
"let g:ackprg = 'ag --vimgrep'
let g:ackprg = 'ag '
nnoremap <Leader>a :Ack<Enter>

"override vim-gitgutter highlight.vim
highlight link diffRemoved String
" vim-mark
"let g:mwDefaultHighlightingPalette = 'extended'
"let g:mwDefaultHighlightingNum = 9
"let g:mwDefaultHighlightingPalette = [
"		\   { 'ctermbg':'Cyan',       'ctermfg':'Black', 'guibg':'#8CCBEA', 'guifg':'Black' },
"		\   { 'ctermbg':'Green',      'ctermfg':'Black', 'guibg':'#A4E57E', 'guifg':'Black' },
"		\   { 'ctermbg':'Yellow',     'ctermfg':'Black', 'guibg':'#FFDB72', 'guifg':'Black' },
"		\   { 'ctermbg':'Red',        'ctermfg':'Black', 'guibg':'#FF7272', 'guifg':'Black' },
"		\   { 'ctermbg':'Blue',       'ctermfg':'Black', 'guibg':'#9999FF', 'guifg':'Black' },
"		\   { 'ctermbg':'Blue',       'ctermfg':'White', 'guibg':'#0000FF', 'guifg':'#F0F0FF' },
"		\   { 'ctermbg':'DarkRed',    'ctermfg':'White', 'guibg':'#FF0000', 'guifg':'#FFFFFF' },
"		\   { 'ctermbg':'Magenta',    'ctermfg':'Black', 'guibg':'#FFA1C6', 'guifg':'#80005D' },
"\]

filetype plugin indent on     " required!
"
"ctrlp设置
"
"set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.png,*.jpg,*.gif     " MacOSX/Linux
"set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe,*.pyc,*.png,*.jpg,*.gif  " Windows

"unite
"let g:unite_source_rec_async_command='ag --path-to-ignore /Users/renyong/software/software_git/config/.agignore --nocolor --nogroup --ignore ".hg" --ignore ".svn" --ignore ".git" --ignore ".bzr" --hidden -g ""'
let g:unite_source_rec_async_command =
    \ ['ag', '-p ~/.agignore', '--follow', '--nogroup', '--nocolor', '--hidden', '-g', '']
nnoremap <silent> <leader>ug  :<C-u>Unite file_rec/git:--cached:--others:--exclude-standard<CR>
nnoremap <leader>ur :<C-u>Unite -start-insert -ignorecase file_rec/async<CR>
nnoremap <leader>uf :<C-u>Unite -ignorecase file<CR>
nnoremap <silent> <leader>ub :<C-u>Unite -ignorecase buffer bookmark<CR>
nnoremap <silent><leader>ul :<C-u>Unite -no-quit line<CR>
nnoremap <silent><leader>ui :<C-u>Unite -no-quit -ignorecase line<CR>

"in case of you input very slowly
"ref:https://github.com/Yggdroot/indentLine/issues/48
"'let g:indentLine_faster = 1' can make the performance better, but indentLine will display on the non leading spaces. In my frequent use, I don't have the performance issue, so I don't let it to be default
let g:indentLine_faster = 1

"let g:hugefile_trigger_size=30
"let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
"let g:ctrlp_custom_ignore = '\v\.(exe|so|dll)$'
"let g:ctrlp_extensions = ['funky']

let NERDTreeIgnore=['\.pyc']
let g:NERDTreeChDirMode = 2

"YCM
"let g:ycm_path_to_python_interpreter = 'python3'
let g:ycm_path_to_python_interpreter = '/usr/local/bin/python3'
let g:ycm_confirm_extra_conf = 0
let g:syntastic_always_populate_loc_list = 1
let g:ycm_error_symbol = '>>'
let g:ycm_warning_symbol = '>*'
let g:ycm_disable_for_files_larger_than_kb=500
let g:ycm_auto_hover=''
nnoremap gd :YcmCompleter GoTo<CR>
nnoremap gc :YcmCompleter GoToDeclaration<CR>
nmap <F4> :YcmDiags<CR>
map <F7> :YcmCompleter FixIt<CR>
" let g:ycm_filetype_whitelist = {'text':1}; this cmd will overwrite default
" set:  {'*':1}
"let g:ycm_filetype_whitelist = {'text':1,'txt':1,'*':1}
"let g:ycm_filetype_blacklist = {'notes': 1, 'markdown': 1, 'netrw': 1, 'unite': 1, 'tagbar': 1, 'pandoc': 1, 'mail': 1, 'vimwiki': 1, 'infolog': 1, 'qf': 1}
let g:ycm_filetype_blacklist = {'tex': 1, 'notes': 1, 'markdown': 1, 'netrw': 1, 'unite': 1, 'tagbar': 1, 'pandoc': 1, 'mail': 1, 'vimwiki': 1, 'infolog': 1, 'qf': 1}

"rtags
noremap <Leader>j :call rtags#JumpTo(g:SAME_WINDOW)<CR>
noremap <Leader>l :call rtags#JumpTo(g:SAME_WINDOW, { '--declaration-only' : '' })<CR>
noremap <Leader>b :call rtags#JumpBack()<CR>
noremap <Leader>i :call rtags#SymbolInfo()<CR>
noremap <Leader>f :call rtags#FindRefs()<CR>

"switch between .cpp & .h
nmap gs :FSHere<CR>

"FZF
nnoremap <silent> <C-p> :GFiles<CR>
nnoremap <silent> <Leader>ah :Ag <C-R><C-W><CR>
vnoremap <silent> <Leader>ah y:Ag <C-r>=fnameescape(@")<CR><CR>

function! s:with_git_root()
  let root = systemlist('git rev-parse --show-toplevel')[0]
  return v:shell_error ? {} : {'dir': root}
endfunction

command! -nargs=* AgGit
  \ call fzf#vim#ag(<q-args>, extend(s:with_git_root(), fzf#vim#with_preview()))

nnoremap <silent> <Leader>ag :AgGit <C-R><C-W><CR>
vnoremap <silent> <Leader>ag y:AgGit <C-r>=fnameescape(@")<CR><CR>
"Ctrl-A Ctrl-Q to select all and build quick fix
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'

"重定向命令输出到新窗口
" http://vim.wikia.com/wiki/Capture_ex_command_output
function! TabMessage(cmd)
  redir => message
  silent execute a:cmd
  redir END
  if empty(message)
    echoerr "no output"
  else
    " use "new" instead of "tabnew" below if you prefer split windows instead of tabs
    tabnew
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
    silent put=message
  endif
endfunction
command! -nargs=+ -complete=command TabMessage call TabMessage(<q-args>)

fixdel
set backspace=indent,eol,start
set showcmd "上一句showcmd好像被覆盖了
