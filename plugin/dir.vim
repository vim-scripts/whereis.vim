" Vim syntax file
" Language:	dir filename

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn match dir1Line      "[a-zA-Z0-9_\\:\.]\+\.vim$"
syn match dir2Line	"[a-zA-Z0-9_\\:\.]\+\.cpp$"
syn match dir3Line	"[a-zA-Z0-9_\\:\.]\+\.c$"
syn match dir4Line	"[a-zA-Z0-9_\\:\.]\+\.asm$"
syn match dir5Line	"[a-zA-Z0-9_\\:\.]\+\.asl$"
syn match dir6Line	"[a-zA-Z0-9_\\:\.]\+\.asi$"
syn match dir7Line	"[a-zA-Z0-9_\\:\.]\+\.app$"

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_dir_syntax_inits")
  if version < 508
    let did_dir_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  
  HiLink dir1Line	Number
  HiLink dir2Line	Comment
  HiLink dir3Line	Comment
  HiLink dir4Line	statement
  HiLink dir5Line	Number
  HiLink dir6Line	Number
  HiLink dir7Line	Number

  delcommand HiLink
endif

let b:current_syntax = "dir"

" vim: ts=8 sw=2
