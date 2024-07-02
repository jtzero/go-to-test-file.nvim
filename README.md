 # GoToTestFile.nvim

### Table of Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Known Issues](#known-issues)
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

## Known Issues
- Doesn't handle [Maven style directory layout](https://maven.apache.org/guides/introduction/introduction-to-the-standard-directory-layout.html)
