Here is a very basic implementation in lua of the main feature of the vim VisIncr vim script plugin (https://github.com/vim-scripts/VisIncr)

I'm not sure this is the best or recommended way to do it, but it works.

The purpose is to test how easy it is to write (in lua), publish and consume a plugin for neovim.

As it is very basic (on purpose), there are some edge cases.

However I implemented a padding.

Note that you can easily increment numbers on a block selection NATIVELY in vim/neovim with g c-a (g ctrl-a)

Basic load through lazy.nvim :

```
return {
  {
    "lofic/dummyvisincr.nvim",
    event = "VeryLazy",
    config = function()
      vim.api.nvim_create_user_command("I", function()
        require("dummyvisincr").incr()
      end, { range = true, desc = "" })
    end,
  },
}
```

Select a column using visual-block (ctrl-v) and move the cursor.

`:I` Will use the first line's number as a starting point to build a column of increasing numbers.
