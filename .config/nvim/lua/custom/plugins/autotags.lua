return {
  'windwp/nvim-ts-autotag',
  event = 'InsertEnter',
  config = function()
    require('nvim-ts-autotag').setup {
      opts = {
        enable_closed = true, -- Automatically close tags
        enable_rename = true, -- Automatically rename tags
        enable_close_on_slash = true, -- Automatically close tags on slash
      },
      per_filetype = {
        ['html'] = {
          enable_closed = true,
          enable_rename = true,
          enable_close_on_slash = true,
        },
      },
    }
  end,
}
