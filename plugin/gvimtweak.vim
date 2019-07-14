if exists('g:gvimtweak#loaded')
  finish
endif
let g:gvimtweak#loaded = 1

if !has('gui_running') || (!has('win32') && !has('win64'))
  finish
endif

function! s:IsMaximum()
  return libcallnr('gvimtweak.dll', 'IsMaximum', 0)
endfunction

function! s:ToggleFullscreenSimple()
  call libcallnr('gvimtweak.dll', 'ToggleFullscreen', 0)
endfunction

function s:SetTransparencySimple(trans)
  call libcallnr('gvimtweak.dll', 'SetTransparency', a:trans)
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
  let g:gvimtweak#default_transparency = a:trans
  let s:transparency = a:trans != 255
endfunction

function s:ToggleTransparency()
  if s:transparency == 0
    call s:SetTransparency(g:gvimtweak#default_transparency)
  else
    call s:SetTransparencySimple(255)
    let s:transparency = 0
  endif
endfunction

command! ToggleHUD call s:ToggleHUD()
command! ToggleMaximum call s:ToggleMaximum()
command! ToggleFullscreen call s:ToggleFullscreen()
command! ToggleTransparency call s:ToggleTransparency()
command! -nargs=1 SetTransparency call s:SetTransparency(0+<args>)

if !exists('g:gvimtweak#default_hud_show')
  let g:gvimtweak#default_hud_show = 0
endif

if g:gvimtweak#default_hud_show == 0
  set guioptions-=e
  call s:ToggleHUD()
endif

if !exists('g:gvimtweak#default_transparency')
  let g:gvimtweak#default_transparency = 205
endif

