# gvimtweak

Gvimtweak is a vim plugin for gvim. It is a fork of [movsb/gvim_fullscreen](https://github.com/movsb/gvim_fullscreen/).

## Advantage

Gvimtweak will save the size of gvim's window when toggle fullscreen, and it can restore the size when the window toggle normal.

## Usage

Put ```gvimtweak.dll``` into the directory where gvim.exe located.

The gvim's toolbar is off default. you can turn on it.

```vim
"Default:0
let g:gvimtweak#default_hud_show = 1
```

The gvim's transparency is 205 default.

```vim
"Default:205 (0~255)
let g:gvimtweak#default_transparency = 205
```

Other commands.

```vim
"Toggle HUD.
ToggleHUD
"Toggle maximum.
ToggleMaximum
"Toggle fullscreen.
ToggleFullscreen
"Toggle transparency.
ToggleTransparency
"Set transparency. (0~255)
SetTransparency 205
```

Set key mappings. You can put the code below on your ```_vimrc```.

```vim
if has('gui_running') && (has('win32') || has('win64'))
  "Key Mappings
  noremap <F10> :ToggleHUD<CR>
  noremap <C-F11> :ToggleMaximum<CR>
  noremap <F11> :ToggleFullscreen<CR>
  noremap <F12> :ToggleTransparency<CR>
endif
```

## Inspired and Thanks

[movsb/gvim_fullscreen](https://github.com/movsb/gvim_fullscreen/)

[zhmars/gvimtweak](https://github.com/zhmars/gvimtweak)
