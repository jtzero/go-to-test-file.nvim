package = "go-to-test-file.nvim"
version = "1.0.3-1"
source = {
   url = "git://github.com/jtzero/go-to-test-file.nvim.git"
}
description = {
   homepage = "https://github.com/jtzero/go-to-test-file.nvim.git",
   license = "MIT"
}
dependencies = {
   "lua >= 5.1, < 5.2",
   "vusted >= 2.3.4-1, < 3",
   "plenary.nvim >= scm-1"
}
build = {
   type = "builtin",
   modules = {
      ["go_to_test_file"] = "lua/go_to_test_file.lua",
      ["go_to_test_file.cmd"] = "lua/go_to_test_file/cmd.lua",
      ["go_to_test_file.git"] = "lua/go_to_test_file/git.lua",
      ["go_to_test_file.list"] = "lua/go_to_test_file/list.lua",
      ["go_to_test_file.matrix"] = "lua/go_to_test_file/matrix.lua",
      ["go_to_test_file.path"] = "lua/go_to_test_file/path.lua",
      ["go_to_test_file.peer"] = "lua/go_to_test_file/peer.lua",
      ["go_to_test_file.peer_dunder_tests"] = "lua/go_to_test_file/peer_dunder_tests.lua",
      ["go_to_test_file.project_generic"] = "lua/go_to_test_file/project_generic.lua",
      ["go_to_test_file.root_tests"] = "lua/go_to_test_file/root_tests.lua",
      ["go_to_test_file.str"] = "lua/go_to_test_file/str.lua",
      ["go_to_test_file.system"] = "lua/go_to_test_file/system.lua"
   }
}
