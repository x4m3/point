# phil's zsh theme
# requires git plugin & ohmyz.sh
#
# Philippe Loctaux aka x4m3chki aka x4m3
# https://philippeloctaux.com

local current_dir="%{$terminfo[bold]$fg_bold[blue]%} %~%{$reset_color%}"
local ret_status="%(?:%{$fg_bold[green]%}$ :%{$fg_bold[red]%}$ )%{$reset_color%}"
local full_time="%{$fg_bold[cyan]%}%@ %w%{$reset_color%}"
local git_branch='$(git_prompt_info)%{$reset_color%}'
local host_name="%{$fg[cyan]%}$(hostname)%{$reset_color%}"

PROMPT="${current_dir} ${ret_status}%{$reset_color%}"
RPROMPT="${git_branch}%{$reset_color%} ${host_name}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[magenta]%}!"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[magenta]%}*"
