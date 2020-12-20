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
GEM="\U0001F48E"

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
    print -n "$GEM %{$fg[red]%}$(rvm-prompt i v g)%{$reset_color%}"
  else
    if which rbenv &> /dev/null; then
      print -n "$GEM %{$fg[red]%}$(rbenv version | sed -e "s/ (set.*$//")%{$reset_color%}"
    fi
  fi
}

at_git_branch() {
  local color ref
  is_dirty() {
    test -n "$(git status --porcelain --ignore-submodules)"
  }
  ref="$vcs_info_msg_0_"
  if [[ -n "$ref" ]]; then
    if is_dirty; then
      color=yellow
      ref="${ref} $PLUSMINUS"
    else
      color=green
      ref="${ref} "
    fi
    if [[ "${ref/.../}" == "$ref" ]]; then
      ref="$BRANCH $ref"
    else
      ref="$DETACHED ${ref/.../}"
    fi
    print -n "%{$fg[color]%}" 
    print -Pn " $ref"
  fi
}

at_conda_env () {
  print -n "$CONDA_PROMPT_MODIFIER"
}

## Prompt Generation
at_prompt_precmd() {
  vcs_info
  PROMPT='%{%f%b%k%}$(at_generate_prompt) '
}

at_generate_prompt() {
  print -n "╭─ $(at_conda_env) $(at_user_host) $(at_current_dir) $(at_rvm_ruby) $(at_git_branch)
╰─%B$%b "
  RPS1="$(at_return_code)"
}

at_prompt_setup() {
  ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
  ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"

  autoload -Uz add-zsh-hook
  autoload -Uz vcs_info

  prompt_opts=(cr subst percent)

  add-zsh-hook precmd at_prompt_precmd

  zstyle ':vcs_info:*' enable git
  zstyle ':vcs_info:*' check-for-changes false
  zstyle ':vcs_info:git*' formats '%b'
  zstyle ':vcs_info:git*' actionformats '%b (%a)'
}

## Fire!
at_prompt_setup "$@"
