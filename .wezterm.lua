local wezterm = require("wezterm")

local config = {
  font = wezterm.font("JetBrainsMono Nerd Font"),
  color_scheme = "Catppuccin Mocha",
  font_size = 16.0,
  window_frame = { font_size = 16.0 },
  ssh_domains = {
    {
      name = "cdd",
      remote_address = "10.0.0.60",
      username = "venky",
    },
  },
  default_domain = "cdd",
}

return config
