# phil's zsh theme
# requires git plugin & ohmyz.sh
#
# Philippe Loctaux aka x4m3chki aka x4m3
# https://philippeloctaux.com

local current_dir="%{$terminfo[bold]$fg_bold[blue]%} %~%{$reset_color%}"
local ret_status="%(?:%{$fg_bold[green]%}$ :%{$fg_bold[red]%}$ )%{$reset_color%}"
local full_time="%{$fg_bold[cyan]%}%@ %w%{$reset_color%}"
local git_branch='$(git_prompt_info)%{$reset_color%}'

local host_name="$(hostname)"
local user_name="%n"
local separation_name="%{$fg_bold[cyan]%};%{$reset_color%}"
local full_name="${user_name}${separation_name}${host_name}"

PROMPT="${current_dir} ${ret_status}"
RPROMPT="${git_branch} ${full_name}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[magenta]%}!"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[magenta]%}*"
