# GoToTestFile.nvim

### Table of Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Folder Patterns](#folder-patterns)
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
        '<cmd>FindTestOrSourceCodeFileWithFallback<CR>',
        mode = { "n" },
        desc = 'Opens a corresponding test file or source file if not found opens the test folder',
      },
    },
}
```

## Supported Folder Patterns

(Note this is language agnostic)

```

 fake_in_module_tests_project
 └── go_to_test_file
     ├── shopping_cart
     │   └── main.lua
     ├── shopping_cart.lua
     └── tests
         ├── shopping_cart
         │   └── main_spec.lua
         └── shopping_cart_spec.lua
 fake-peer-dunder-tests-project
 └── src
     ├── app.js
     └── __tests__
         ├── app.js
         └── app.test.js
 fake-peer-dunder-tests-project-differing-ext
 └── src
     ├── app.vue
     └── __tests__
         └── app.js
 fake-peer-dunder-tests-project-infix
 └── src
     ├── app.js
     └── __tests__
         └── app.test.js
 fake-peer-project
 └── src
     └── go-to-test-file
         ├── fake-source-code-file.test.ts
         └── fake-source-code-file.ts
 fake_pytest_project
 └── go_to_test_file
     ├── shopping_cart
     │   ├── _base.py
     │   └── __init__.py
     └── tests
         └── test_shopping_cart.py
 fake_root_tests_project
    ├── src
    │   └── go_to_test_file
    │       ├── shopping_cart
    │       │   └── main.lua
    │       └── shopping_cart.lua
    └── tests
        └── go_to_test_file
            ├── shopping_cart
            │   └── main_spec.lua
            └── shopping_cart_spec.lua
```

## Known Issues

- Doesn't handle [Maven style directory layout](https://maven.apache.org/guides/introduction/introduction-to-the-standard-directory-layout.html)

## Similar Projects
- https://github.com/reprehensible/nvim-test-file
