-- fix for ghost boxes
return {
  "Saghen/blink.cmp",
  opts = {
    completion = {
      menu = {
        winblend = 0,

        -- only way to stop ghost border bug with blink.cmp
        border = "none", -- single, rounded, double, none
      },
      documentation = {
        window = {
          winblend = 0,
        },
      },
    },
  },
}
