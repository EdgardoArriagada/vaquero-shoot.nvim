# vaquero-shoot.nvim

_The fastest selection in the west._

What is vaquero-shoot?

`vaquero-shoot` is a plugin that exposes some functions that helps you build mappings for quick inline selection of text surrounded with some characters like strings, arrays, objects etc.

You can quickly select text surrounded with any of these characters <br />
![complete-enclosing](./images/complete-enclosing.gif)

You can quickly select text surrounded with any of these quotes <br />
![complete-quotes](./images/complete-quotes.gif)

You can cycle selections until you hit the text you wanted to select!

## Demo

_All `vaquero-shoot` examples uses the mappings described in the [Usage](#usage) section_

(normal nvim) Trying to select in parentheses from column 1 😲 <br />
`vi(`
![viparent](./images/viparent.gif)

(vaquero-shoot) Trying to select in parentheses from column 1 _(and cycling selection)_ 🤯 <br />
`shift` + `w` + `w` + `w` + `w` + `w` + `w` + `w` + `w` + `w`
![vqsenclosing](./images/vqsenclosing.gif)

(vaquero-shoot) Same with strings 😍 <br />
`v'` + `'` + `'` + `'` + `'` + `'`
![cycle-strings](./images/cycle-strings.gif)

(normal nvim) Trying to select an invalid string 😔 <br />
`vi"`
![invalid-string](./images/invalid-string.gif)

(vaquero-shoot) Trying to select an invalid string 😌 <br />
`v'`
![fix-invalid-string](./images/fix-invalid-string.gif)

(normal nvim) Trying to select backwards _(did nothing)_ 🫥 <br />
`` vi` ``
![invalid-select-backwards](./images/invalid-selection-backwards.gif)

(vaquero-shoot) Trying to select backwards 😏 <br />
`v'`
![fix-invalid-selection-backwards](./images/fix-invalid-selection-backwards.gif)

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
-- init.lua:
{ 'EdgardoArriagada/vaquero-shoot.nvim' }

-- plugins/vaquero-shoot.lua:
return {
    'EdgardoArriagada/vaquero-shoot.nvim'
}
```

Using [vim-plug](https://github.com/junegunn/vim-plug)

```lua
Plug 'EdgardoArriagada/vaquero-shoot.nvim'
```

Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
    'EdgardoArriagada/vaquero-shoot.nvim'
}
```

## Usage

Using Lua:

```lua
local vqs = require("vaquero-shoot")

-- enclosing
vim.keymap.set("n", "E", vqs.beginEnclosingSelection)
vim.keymap.set("v", "E", vqs.cycleEnclosingSelection)
vim.keymap.set("n", "W", vqs.beginEnclosingSelectionBackwards)
vim.keymap.set("v", "W", vqs.cycleEnclosingSelectionBackwards)

-- quotes
vim.keymap.set({ "o", "v" }, "'", vqs.quotesSelection)
vim.keymap.set({ "o", "v" }, '"', vqs.quotesSelectionBackwards)
```

Using VimL:

```vim

" Enclosing
nnoremap E <cmd>VaqueroShoot beginEnclosingSelection<cr>
vnoremap E <cmd>VaqueroShoot cycleEnclosingSelection<cr>
nnoremap W <cmd>VaqueroShoot beginEnclosingSelectionBackwards<cr>
vnoremap W <cmd>VaqueroShoot cycleEnclosingSelectionBackwards<cr>

" Quotes
vnoremap ' <cmd>VaqueroShoot quotesSelection<cr>
vnoremap " <cmd>VaqueroShoot quotesSelectionBackwards<cr>
```

## Selections

there are two type of selections:

- Enclosing selection: items surrounded in one of these characters:

```bash
( ) [ ] { } < >
```

- Quotes selection: item surrounded in one of these characters

```bash
' ` "
```

## Actions

| action                           | description                                                                        |
| -------------------------------- | ---------------------------------------------------------------------------------- |
| enclosingSelection               | Perform Begin or Cycle enclosing selection depending if it has enclosing selection |
| enclosingSelectionBackwards      | Perform enclosingSelection backwards                                               |
| quotesSelection                  | Perform Begin or Cycle quotes selection depending if it has quotes selection       |
| quotesSelectionBackwards         | Perform quotesSelection backwards                                                  |
| beginEnclosingSelection          | Begin enclosing selection                                                          |
| beginEnclosingSelectionBackwards | Perform beginEnclosingSelection backwards                                          |
| beginQuotesSelection             | Begin quotes selection                                                             |
| beginQuotesSelectionBackwards    | Perform beginQuotesSelection backwards                                             |
| cycleEnclosingSelection          | Cycle enclosing selection                                                          |
| cycleEnclosingSelectionBackwards | Perform cycleEnclosingSelection backwards                                          |
| cycleQuotesSelection             | Cycle quotes selection                                                             |
| cycleQuotesSelectionBackwards    | Perform cycleQuotesSelection backwards                                             |

## Commands

There is only one command, `VaqueroShoot` which receives only one arg (action) which is describes in the table above
