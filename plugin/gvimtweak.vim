" MIT License
" 
" Copyright (c) 2019 Keshi
" 
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
" 
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
" 
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
" SOFTWARE.

if exists('g:gvimtweak#loaded')
  finish
endif

let g:gvimtweak#loaded = 1

if !has('gui_running') || (!has('win32') && !has('win64'))
  finish
endif

let s:tweak_dll_path = expand('<sfile>:p:h:h').'\lib\gvimtweak_x'.(has('win64')? '64':'32').'.dll'

function! s:IsMaximum()
  return libcallnr(s:tweak_dll_path, 'IsMaximum', 0)
endfunction

function! s:ToggleFullscreenSimple()
  call libcallnr(s:tweak_dll_path, 'ToggleFullscreen', 0)
endfunction

function s:SetTransparencySimple(trans)
  call libcallnr(s:tweak_dll_path, 'SetTransparency', a:trans)
endfunction

let s:guihud = 1
let s:maximum = 0
let s:fullscreen = 0
let s:transparency = 0
let s:curlines = &lines
let s:curcolumns = &columns

function s:ToggleHUD()
  if s:fullscreen == 1
    return
  endif
  if s:guihud == 1
    let s:lastguioptions = &guioptions
    set guioptions=
    let s:guihud = 0
  else
    let &guioptions = s:lastguioptions
    let s:guihud = 1
  endif
endfunction

function s:ToggleMaximum()
  if s:fullscreen == 1
    return
  endif
  let s:maximum = s:IsMaximum()
  if s:maximum == 0
    let s:curlines = &lines
    let s:curcolumns = &columns
    simalt ~x
    let s:maximum = 1
  else
    simalt ~r
    let s:maximum = 0
  endif
endfunction

function s:ToggleFullscreen()
  if s:fullscreen == 0
    if s:guihud == 1
      let s:lastguioptions = &guioptions
      set guioptions=
    endif
    let s:maximum = s:IsMaximum()
    if s:maximum == 0
      let s:curlines = &lines
      let s:curcolumns = &columns
    endif
    call s:ToggleFullscreenSimple()
    let s:fullscreen = 1
  else
    call s:ToggleFullscreenSimple()
    let &lines = s:curlines
    let &columns = s:curcolumns
    if s:maximum == 1
      simalt ~x
    endif
    if s:guihud == 1
      let &guioptions = s:lastguioptions
    endif
    let s:fullscreen = 0
  endif
endfunction

function s:SetTransparency(trans)
  call s:SetTransparencySimple(a:trans)
  let s:current_transparency = a:trans
  let s:transparency = a:trans != 255
endfunction

function s:ToggleTransparency()
  if s:transparency == 0
    call s:SetTransparency(s:current_transparency)
  else
    call s:SetTransparencySimple(255)
    let s:transparency = 0
  endif
endfunction

command! GvimTweakToggleHUD call s:ToggleHUD()
command! GvimTweakToggleMaximum call s:ToggleMaximum()
command! GvimTweakToggleFullscreen call s:ToggleFullscreen()
command! GvimTweakToggleTransparency call s:ToggleTransparency()
command! -nargs=1 GvimTweakSetTransparency call s:SetTransparency(0+<args>)

let s:current_transparency = get(g:, 'gvimtweak#transparency_at_start', 205)

if !exists('g:gvimtweak#enable_hud_at_start') || g:gvimtweak#enable_hud_at_start == 0
  set guioptions-=e
  call s:ToggleHUD()
endif

