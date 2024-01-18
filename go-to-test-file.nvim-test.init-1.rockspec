package = "go-to-test-file.nvim"
version = "test.init-1"
source = {
   url = "git+ssh://git@github.com/jtzero/go-to-test-file.nvim.git"
}
description = {
   homepage = "*** please enter a project homepage ***",
   license = "*** please specify a license ***"
}
dependencies = {
   "lua >= 5.1, < 5.2",
   "vusted >= 2.3.4-1, < 3",
   "plenary.nvim >= scm-1"
}
build = {
   type = "builtin",
   modules = {
      ["go-to-test-file"] = "lua/go-to-test-file.lua",
      ["go-to-test-file.cmd"] = "lua/go-to-test-file/cmd.lua",
      ["go-to-test-file.git"] = "lua/go-to-test-file/git.lua",
      ["go-to-test-file.list"] = "lua/go-to-test-file/list.lua",
      ["go-to-test-file.matrix"] = "lua/go-to-test-file/matrix.lua",
      ["go-to-test-file.path"] = "lua/go-to-test-file/path.lua",
      ["go-to-test-file.peer"] = "lua/go-to-test-file/peer.lua",
      ["go-to-test-file.project_generic"] = "lua/go-to-test-file/project_generic.lua",
      ["go-to-test-file.root_tests"] = "lua/go-to-test-file/root_tests.lua",
      ["go-to-test-file.str"] = "lua/go-to-test-file/str.lua",
      ["go-to-test-file.system"] = "lua/go-to-test-file/system.lua"
   }
}
