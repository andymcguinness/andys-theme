# vim:ft=zsh ts=2 sw=2 sts=2
#
# Andy's Theme
# Inspired by Bira and agnoster
#
# Requires Powerline patched font


## Characters for Prompt
SEGMENT_SEPARATOR="\ue0b0"
PLUSMINUS="\u00b1"
BRANCH="\ue0a0"
DETACHED="\u27a6"
CROSS="\u2718"
LIGHTNING="\u26a1"
GEAR="\u2699"

## Create Prompt Segments
at_return_code() {
  print -n "%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
}

at_user_host() {
  print -n "%{$terminfo[normal]$fg[green]%}%n@%m%{$reset_color%}" 
}

at_current_dir() {
  print -n "%{$terminfo[normal]$fg[blue]%} %~%{$reset_color%}"
}

at_rvm_ruby() {
  if which rvm-prompt &> /dev/null; then
    print -n "%{$fg[red]%}$(rvm-prompt i v g)%{$reset_color%}"
  else
    if which rbenv &> /dev/null; then
      print -n "%{$fg[red]%}$(rbenv version | sed -e "s/ (set.*$//")%{$reset_color%}"
    fi
  fi
}

at_git_branch() {
  print -n "$BRANCH $(git_prompt_info)%{$reset_color%}"
}

## Prompt Generation
at_generate_prompt() {
  PROMPT="╭─$(at_user_host) $(at_current_dir) $(at_rvm_ruby) $(at_git_branch)
    ╰─%B$%b "
  RPS1="$(at_return_code)"
}

at_prompt_setup() {
  ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
  ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"

  at_generate_prompt
}

## Fire!
at_prompt_setup
