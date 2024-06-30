 # GoToTestFile.nvim

### Table of Contents

- [Requirements](#requirements)
- [Installation](#installation)

---

## Requirements
- Neovim >= **0.9.0**
- [fd](https://github.com/sharkdp/fd)
- git
- rg
- realpath

## Installation

Install the plugin with your preferred package manager.
```lua
{
    'jtzero/go-to-test-file.nvim',
    lazy = false,
    config = true,
    keys = {
      {
        '<M-T>',
        '<cmd>FindTestOrSrcCodeFileFolderOnFailure<CR>',
        mode = { "n" },
        desc = 'Opens a corresponding test file or source file if not found opens the test folder',
      },
    },
}
```
