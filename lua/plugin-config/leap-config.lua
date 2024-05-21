local M = {}

M.setup = function()
	-- Define equivalence classes for brackets and quotes, in addition to
	-- the default whitespace group.
	require("leap").opts.equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" }

	-- Override some old defaults - use backspace instead of tab (see issue #165).
	require("leap").opts.special_keys.prev_target = "<backspace>"
	require("leap").opts.special_keys.prev_group = "<backspace>"

	-- Use the traversal keys to repeat the previous motion without explicitly
	-- invoking Leap.
	require("leap.user").set_repeat_keys("<enter>", "<backspace>")
end

return M
