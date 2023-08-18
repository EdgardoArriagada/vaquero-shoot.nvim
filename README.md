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
vim.keymap.set("n", "W", function()
    vqs.beginEnclosingSelection()
end)

vim.keymap.set("v", "W", function()
    vqs.cycleEnclosingSelection()
end)

-- quotes
vim.keymap.set({ "o", "v" }, "'", function()
    if vqs.hasQuotesSelection() then
        vqs.cycleQuotesSelection()
    else
        vqs.beginQuotesSelection()
    end

    -- or siply vqs.quotesSelection()
end)
```

Using VimL:

```vim

" Enclosing
nnoremap W <cmd>VaqueroShoot beginEnclosingSelection<cr>
vnoremap W <cmd>VaqueroShoot cycleEnclosingSelection<cr>

" Quotes
vnoremap ' <cmd>VaqueroShoot cycleQuotesSelection<cr>
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

## Functions

| function                | description                                                                        | return  |
| ----------------------- | ---------------------------------------------------------------------------------- | ------- |
| beginEnclosingSelection | Begin enclosing selection                                                          | nil     |
| cycleEnclosingSelection | Cycle enclosing selection                                                          | nil     |
| enclosingSelection      | Perform Begin or Cycle enclosing selection depending if it has enclosing selection | nil     |
| beginQuotesSelection    | Begin quotes selection                                                             | nil     |
| cycleQuotesSelection    | Cycle quotes selection                                                             | nil     |
| quotesSelection         | Perform Begin or Cycle quotes selection depending if it has enclosing selection    | nil     |
| hasEnclosingSelection   | Check if has enclosing selection                                                   | boolean |
| hasQuotesSelection      | Check if has quotes selection                                                      | boolean |
| hasVqsSelection         | Check if has quotes or enclosing selection                                         | boolean |

## Commands

there is only one command, `VaqueroShoot`

that command recives only one arg (action) which is describes in the table below

| action                  | description                                                                        |
| ----------------------- | ---------------------------------------------------------------------------------- |
| beginEnclosingSelection | Begin enclosing selection                                                          |
| cycleEnclosingSelection | Cycle enclosing selection                                                          |
| enclosingSelection      | Perform Begin or Cycle enclosing selection depending if it has enclosing selection |
| beginQuotesSelection    | Begin quotes selection                                                             |
| cycleQuotesSelection    | Cycle quotes selection                                                             |
| quotesSelection         | Perform Begin or Cycle quotes selection depending if it has enclosing selection    |
