return {
  'ray-x/lsp_signature.nvim',
  event = 'LspAttach',
  opts = {
    bind = true,
    handler_opts = { border = 'rounded' },
    floating_window = true,
    hint_enable = true,
    hint_prefix = {
      above = '↙ ', -- when the hint is on the line above the current line
      current = '← ', -- when the hint is on the same line
      below = '↖ ', -- when the hint is on the line below the current line
    },
    hi_parameter = 'LspSignatureActiveParameter',
  },
  config = function(_, opts)
    require('lsp_signature').setup(opts)
  end,
}
