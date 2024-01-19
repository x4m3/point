-- Pull in the wezterm API
local wezterm = require "wezterm"

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.default_prog = { "zsh", "--login", "--interactive", "-l", "-c", "zellij" }
config.audible_bell = "Disabled"

-- source: https://gist.github.com/Zbizu/43df621b3cd0dc460a76f7fe5aa87f30
function GetOS()
  local osname

  -- unix systems
  local fh = assert(io.popen("uname -o 2>/dev/null", "r"))
  if fh then
    osname = fh:read()
  end

  return osname or "Windows"
end

-- font size
local font_size = 11
if GetOS() == "Darwin" then
  font_size = 13
end
config.font_size = font_size

-- window
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- use alt <- -> to go backwards / forwards of a word
config.keys = {
  -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
  { key = "LeftArrow",  mods = "OPT", action = wezterm.action { SendString = "\x1bb" } },
  -- Make Option-Right equivalent to Alt-f; forward-word
  { key = "RightArrow", mods = "OPT", action = wezterm.action { SendString = "\x1bf" } },
}

return config
