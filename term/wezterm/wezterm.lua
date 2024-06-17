-- Pull in the wezterm API
local wezterm = require "wezterm"

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

function GetOS()
  -- source: https://gist.github.com/Zbizu/43df621b3cd0dc460a76f7fe5aa87f30
  local osname

  -- unix systems
  local fh = assert(io.popen("uname -o 2>/dev/null", "r"))
  if fh then
    osname = fh:read()
  end

  return osname or "Windows"
end

-- disable annoying bell sound
config.audible_bell = "Disabled"

-- default program when opening terminal
if GetOS() == "Windows" then
  config.default_prog = { "powershell.exe", "-NoLogo" }
else
  config.default_prog = { "zsh", "--login", "--interactive", "-l", "-c", "zellij" }
end

-- font size
local font_sizes = {
  ["GNU/Linux"] = 11,
  ["Darwin"] = 13,
  ["Windows"] = 10,
}
config.font_size = font_sizes[GetOS()]

-- window
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
config.native_macos_fullscreen_mode = true

if GetOS() == "GNU/Linux" then
  config.enable_wayland = false

  if config.enable_wayland == true then
    config.window_decorations = "NONE"
  end
end


config.keys = {
  -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
  { key = "LeftArrow",  mods = "OPT",  action = wezterm.action { SendString = "\x1bb" } },
  -- Make Option-Right equivalent to Alt-f; forward-word
  { key = "RightArrow", mods = "OPT",  action = wezterm.action { SendString = "\x1bf" } },
  -- Disable fullscreen with Alt-Enter
  { key = "Enter",      mods = "ALT",  action = wezterm.action.DisableDefaultAssignment },
  -- Pass Ctrl+Tab to terminal directly
  { key = "Tab",        mods = "CTRL", action = wezterm.action.DisableDefaultAssignment },
}

-- Integration with neovim plugin https://github.com/folke/zen-mode.nvim
wezterm.on("user-var-changed", function(window, pane, name, value)
  local overrides = window:get_config_overrides() or {}
  if name == "ZEN_MODE" then
    local incremental = value:find("+")
    local number_value = tonumber(value)
    if incremental ~= nil then
      while (number_value > 0) do
        window:perform_action(wezterm.action.IncreaseFontSize, pane)
        number_value = number_value - 1
      end
      overrides.enable_tab_bar = false
    elseif number_value < 0 then
      window:perform_action(wezterm.action.ResetFontSize, pane)
      overrides.font_size = nil
      overrides.enable_tab_bar = true
    else
      overrides.font_size = number_value
      overrides.enable_tab_bar = false
    end
  end
  window:set_config_overrides(overrides)
end)

return config
