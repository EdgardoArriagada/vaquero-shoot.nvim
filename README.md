# vaquero-shoot.nvim

The fastest selection in the west.

What is vaquero-shoot?

`vaquero-shoot` is a shortcut for quick inline selection of item surrounded with some character(s) like strings, arrays, objects etc.

## Demo

_All vaquero shoot examples uses the mappings described in the [Usage](#Usage) section_

Trying to select with `vi(`
![viparent](./images/viparent.gif)

With vaquero-shoot
`shift` + `w` + `w` + `w`
![vqsenclosing](./images/vqsenclosing.gif)

Same with strings, and you can cycle them forever
`v'` + `'` + `'` + `'` + `'` + `'`
![cycle-strings](./images/cycle-strings.gif)

Tring to select an invalid string with `vi"`

![invalid-string](./images/invalid-string.gif)

Tring to select an invalid string with vaquero-shoot `v'`

![fix-invalid-string](./images/fix-invalid-string.gif)

Trying to select backwards with `` vi` ``

![invalid-select-backwards](./images/invalid-selection-backwards.gif)

Trying to select backwards with vaquero-shoot `vi'`

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
end)
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

| function                  | description                                |
| ------------------------- | ------------------------------------------ |
| `beginEnclosingSelection` | Begin enclosing selection                  |
| `cycleEnclosingSelection` | Cycle enclosing selection                  |
| `beginQuotesSelection`    | Begin quotes selection                     |
| `cycleQuotesSelection`    | Cycle quotes selection                     |
| `hasEnclosingSelection`   | Check if has enclosing selection           |
| `hasQuotesSelection`      | Check if has quotes selection              |
| `hasVqsSelection`         | Check if has quotes or enclosing selection |
