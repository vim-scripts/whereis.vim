" File: whereis.vim
" Author: Lechee.Lai 
" Version: 1.1
" 
" goal:
"   make it easy to find file in deep struct directory like BIOS develop  
" which inlcude hundread of directory and thousand of file for one BIOS
" project. So env(bhome) is porject for looking.
"
" TODO:
"   of course remember last search directory is better for env(bhome) could 
" someone give me a hint 
"   directory complete in input() is possible ?
"
" 
" ============ Output Format =====================
" C:\vim\vim62\plugin\vgrep.vim
" C:\vim\vim62\plugin\whereis.vim
" ================================================
"
" Command :Whereis 
"         :Vwhereis View whereis result and select by ENTER
"
" Change Vwhereis_Key as you want
" dir.vim is syntax for whereis output add dir.vim in your filetype.vim 
" and copy dir.vim to syntax directory
" ==== filetype.vim =====
" " Directory files
" au BufNewFile,BufRead *.dir                     setf dir
"
" 1.1 
"   Fixed Win9x have different output with Bare mode
"
if exists("loaded_whereis") || &cp
    finish
endif
let loaded_whereis = 1

if !exists("Vwhereis_Key")
    let Vwhereis_Key = 'În'   " Alt-F7
endif

if !exists("Whereis_Output")
	let Whereis_Output = 'c:\fte.dir'
endif
 
if !exists("WhereisDir")
       if $bhome == "" 
         let WhereisDir = getcwd()
       else
       	 let WhereisDir = $bhome
       endif
endif       

if !exists("Whereis_Null_Device")
    if has("win32") || has("win16") || has("win95")
        let Whereis_Null_Device = 'NUL'
    else
        let Whereis_Null_Device = '/dev/null'
    endif
endif
 
exe "nnoremap <unique> <silent> " . Vwhereis_Key . " :call <SID>RunVwhereis()<CR>"

" RunWhereisCmd()
" Run the specified whereis command using the supplied pattern
function! s:RunWhereisCmd(cmd, pattern)
    let Whereis_Output = g:Whereis_Output
    let del_str = 'del ' . Whereis_Output
    let cmd_del = system(del_str)   
    let cmd_output = system(a:cmd)

    if filereadable(Whereis_Output)
      exe "redir! > " . g:Whereis_Null_Device
      silent echon cmd_del
      redir END
    endif

    if cmd_output == ""
        echohl WarningMsg | 
        \ echomsg "Error: File " . a:pattern . " not found" | 
        \ echohl None
        return
    endif

    let tmpfile = Whereis_Output

    exe "redir! > " . tmpfile
    silent echon cmd_output
    redir END

endfunction

" EditFile()
"
function! s:EditFile()
    let fname = getline('.')
    echo "has nothing"
    if !has("win32")
    " for win9x        
      let i = strlen(fname)
      let ix = stridx(fname," ")
      if i != ix  && ix != -1
         let name = strpart(fname,0,ix)
         let ext = strpart(fname,ix,i-ix)
         let j = 0
         let done = 0
         while done == 0
            let A = ext[j]  
            if A == " "
                let j = j + 1
            else
                let done = 1    
            endif	  
         endwhile
         let ext = strpart(fname,ix+j,i-ix-j)        
"         echo i ."..". ix ."[".name . "." . ext . "]" 
         exe 'edit ' . name .".". ext
      else 
         exe 'edit ' . fname     
      endif
    endif
    if has("win32")
    " for winNT        
       exe 'edit ' . fname  
    endif
endfunction	


" RunWhereis()
" Run the specified whereis command
function! s:RunWhereis(...)
    " No argument supplied. Get the identifier and file list from user
    let Whereis_Output = g:Whereis_Output
    let pattern = input("Whereis: ")
    if pattern == ""
	echo "Cancelled."    
        return
    endif
                  
    let WhereisDir = input("Start DIRs: ", g:WhereisDir)
    if WhereisDir == ""
	    echo "Cancelled."    
	    return
    endif            
    " Here is Win32 Mode only use internal 'dir' command search through 
    " subdirectory 
    let cmd = 'dir ' . pattern . '/S /B'  " in Bare mode

    if isdirectory (WhereisDir) 
      let last_cd = getcwd()
      exe 'cd ' . WhereisDir
      call s:RunWhereisCmd(cmd, pattern)
      exe 'cd ' . last_cd
    else 
      echomsg "Invaild directory"
      return       
    endif
    if filereadable(Whereis_Output)
        setlocal modifiable 
        exe 'edit ' . Whereis_Output
        setlocal nomodifiable
    endif 
    nnoremap <buffer> <silent> <CR> :call <SID>EditFile()<CR>
endfunction

function! s:RunVwhereis()
    let Whereis_Output = g:Whereis_Output    
    setlocal modifiable
    exe 'edit ' . Whereis_Output
    nnoremap <buffer> <silent> <CR> :call <SID>EditFile()<CR>
    setlocal nomodifiable
endfunction

" Define the set of Whereis commands
command! -nargs=* Whereis call s:RunWhereis(<q-args>)
command! Vwhereis call s:RunVwhereis()
