" ==============================================================================
" Vim syntax file
" Language:        C Additions
" Original Author: Mikhail Wolfson <mywolfson@gmail.com>
" Maintainer:      bfrg <bfrg@users.noreply.github.com>
" Website:         https://github.com/bfrg/vim-cpp-modern
" Last Change:     Mar 24, 2018
"
" Extended C syntax highlighting including highlighting for user-defined
" functions.
"
" This syntax file is based on a previous work by Jon Haggblad:
"   https://github.com/octol/vim-cpp-enhanced-highlight
" ==============================================================================


" Highlight some additional keywords in the comments
syn keyword cTodo contained BUG NOTE

" Booleans
syn keyword cBoolean true false TRUE FALSE


" Default highlighting
hi def link cCustomFunc    Function
hi def link cBoolean       Boolean
hi def link cAnsiFunction  cFunction
hi def link cAnsiName      cIdentifier
hi def link cFunction      Function
hi def link cIdentifier    Identifier

" Operators
syn match cOperator "\(<<\|>>\|[-+*/%&^|<>!=]\)="
syn match cOperator "<<\|>>\|&&\|||\|++\|--\|->"
syn match cOperator "[.!~*&%<>^|=,+-]"
syn match cOperator "/[^/*=]"me=e-1
syn match cOperator "/$"
syn match cOperator "&&\|||"
syn match cOperator "[][]"

" Preprocs
syn keyword cDefined defined contained containedin=cDefine
hi def link cDefined cDefine

" Functions
syn match cUserFunction "\<\h\w*\>\(\s\|\n\)*("me=e-1 contains=cType,cDelimiter,cDefine
syn match cUserFunctionPointer "(\s*\*\s*\h\w*\s*)\(\s\|\n\)*(" contains=cDelimiter,cOperator
hi def link cUserFunction cFunction
hi def link cUserFunctionPointer cFunction
