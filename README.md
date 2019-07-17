# gvimtweak

Gvimtweak is a vim plugin for gvim. It is a fork of [movsb/gvim_fullscreen](https://github.com/movsb/gvim_fullscreen/).

Supported platforms:

- Windows 32/64bit (Compiled by Visual Studio 2017)

## Advantage

Gvimtweak will save the size of gvim's window when toggle fullscreen, and it can restore the size when the window toggle normal.

## Installation

Vim-Plug: ``` Plug 'KeshiSmith/gvimtweak' ```

## Usage

The gvim's toolbar is off default. you can turn on it.

```vim
"Default:0
let g:gvimtweak#enable_hud_at_start = 1
```

The gvim's transparency is 205 default.

```vim
"Default:205 (0~255)
let g:gvimtweak#transparency_at_start = 205
```

Other commands.

```vim
"Toggle HUD.
GvimTweakToggleHUD
"Toggle maximum.
GvimTweakToggleMaximum
"Toggle fullscreen.
GvimTweakToggleFullscreen
"Toggle transparency.
GvimTweakToggleTransparency
"Set transparency. (0~255)
GvimTweakSetTransparency 205
```

Set key mappings. You can put the code below on your ```_vimrc```.

```vim
if has('gui_running') && (has('win32') || has('win64'))
  "Key Mappings
  noremap <F10> :GvimTweakToggleHUD<CR>
  noremap <C-F11> :GvimTweakToggleMaximum<CR>
  noremap <F11> :GvimTweakToggleFullscreen<CR>
  noremap <F12> :GvimTweakToggleTransparency<CR>
endif
```

## Inspired and Thanks

[movsb/gvim_fullscreen](https://github.com/movsb/gvim_fullscreen/)

[zhmars/gvimtweak](https://github.com/zhmars/gvimtweak)
