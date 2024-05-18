

#===========================================================================================#
# ******************************************************************************************#
# **************THEME WAS ASSEMBLED FROM PARTS TAKEN FROM DIFFERENT AUTHORS.****************#
# ******************************************************************************************#
#                                                                                           #
#                                PERSONAL THANKS TO:                                        #
#                                                                                           #
#-------------------------------------------------------------------------------------------#
# @Heapbytes for "PROMPT"                                                                   #
# https://github.com/heapbytes/heapbytes-zsh/blob/main/heapbytes.zsh-theme                  #
#-------------------------------------------------------------------------------------------#
# @zakaziko99 for "git_prompt"                                                              #
# https://github.com/zakaziko99/agnosterzak-ohmyzsh-theme/blob/master/agnosterzak.zsh-theme #
#-------------------------------------------------------------------------------------------#
# @AmrMKayid for "git_time_since_commit"                                                    #
# https://github.com/AmrMKayid/KayidmacOS/blob/master/kayid.zsh-theme                       #
#===========================================================================================#


NEWLINE=$'\n'

git_time_since_commit() {
	# Only proceed if there is actually a commit.
	if last_commit=$(git log --pretty=format:'%at' -1 2> /dev/null); then
        now=$(date +%s)
        seconds_since_last_commit=$((now-last_commit))

        # Totals:
        minutes=$((seconds_since_last_commit / 60))
        hours=$((seconds_since_last_commit/3600))
		month=$((seconds_since_last_commit/2592000))

        # Sub-hours and sub-minutes:
        days=$((seconds_since_last_commit / 86400))
        sub_hours=$((hours % 24))
        sub_minutes=$((minutes % 60))

	if   [ $month -ge 12 ]; then
	    years=$((${month}/12));
            commit_age="$fg_bold[red]${years}y"
        elif [ $month -lt 12 ] && [ $month -ge 1 ]; then
            commit_age="$fg_bold[red]${month}M"
        elif [ $month -lt 1 ] && [ $days -ge 7 ]; then
            commit_age="$fg_bold[red]${days}d"
        elif [ $days -lt 7 ] && [ $days -ge 3 ]; then
            commit_age="$fg_bold[yellow]${days}d"
        elif [ $days -lt 3 ] && [ $days -ge 1 ]; then
            commit_age="$fg_bold[green]${days}d"
        elif [ $days -lt 1 ] && [ $hours -ge 1 ]; then
		    commit_age="$fg_bold[green]${hours}h"
        else
            commit_age="$fg_bold[green]${minutes}m"
        fi

		echo " %{$reset_color%}[Updated: $commit_age%{$reset_color%} ago]"
    fi
}

git_prompt() {
#«»±˖˗‑‐‒ ━ ✚‐↔←↑↓→↭⇎⇔⋆━◂▸◄►◆☀★☗☊✔✖❮❯⚑⚙
  local PL_BRANCH_CHAR
  () {
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"
    PL_BRANCH_CHAR=" "
  }
  local ref dirty mode repo_path clean has_upstream
  local modified untracked added deleted tagged stashed
  local ready_commit git_status bgclr fgclr
  local commits_diff commits_ahead commits_behind has_diverged to_push to_pull

  repo_path=$(git rev-parse --git-dir 2>/dev/null)

  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    dirty=$(parse_git_dirty)
    git_status=$(git status --porcelain 2> /dev/null)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"
    if [[ -n $dirty ]]; then
      clean=''
      bgclr='yellow'
      fgclr='magenta'
    else
      clean=" $fg[green]"
      bgclr='green'
      fgclr='white'
    fi

    local upstream=$(git rev-parse --symbolic-full-name --abbrev-ref @{upstream} 2> /dev/null)
    if [[ -n "${upstream}" && "${upstream}" != "@{upstream}" ]]; then has_upstream=true; fi

    local current_commit_hash=$(git rev-parse HEAD 2> /dev/null)

    local number_of_untracked_files=$(\grep -c "^??" <<< "${git_status}")
    if [[ $number_of_untracked_files -gt 0 ]]; then untracked=" $number_of_untracked_files*"; fi

    local number_added=$(\grep -c "^A" <<< "${git_status}")
    if [[ $number_added -gt 0 ]]; then added=" $number_added\+"; fi

    local number_modified=$(\grep -c "^.M" <<< "${git_status}")
    if [[ $number_modified -gt 0 ]]; then
      modified=" !$number_modified\m" 
      bgclr='red'
      fgclr='white'
    fi

    local number_added_modified=$(\grep -c "^M" <<< "${git_status}")
    local number_added_renamed=$(\grep -c "^R" <<< "${git_status}")
    if [[ $number_modified -gt 0 && $number_added_modified -gt 0 ]]; then
      modified="$modified $((number_added_modified+number_added_renamed))m"
    elif [[ $number_added_modified -gt 0 ]]; then
      modified=" $((number_added_modified+number_added_renamed))m"
    fi

    local number_deleted=$(\grep -c "^.D" <<< "${git_status}")
    if [[ $number_deleted -gt 0 ]]; then
      deleted=" !$number_deleted‒"
      bgclr='red'
      fgclr='white'
    fi

    local number_added_deleted=$(\grep -c "^D" <<< "${git_status}")
    if [[ $number_deleted -gt 0 && $number_added_deleted -gt 0 ]]; then
      deleted="$deleted $number_added_deleted‒"
    elif [[ $number_added_deleted -gt 0 ]]; then
      deleted=" $number_added_deleted‒"
    fi

    local tag_at_current_commit=$(git describe --exact-match --tags $current_commit_hash 2> /dev/null)
    if [[ -n $tag_at_current_commit ]]; then tagged="$fg[white] TAG:$tag_at_current_commit"; fi

    local number_of_stashes="$(git stash list -n1 2> /dev/null | wc -l)"
    if [[ $number_of_stashes -gt 0 ]]; then
      stashed=" ${number_of_stashes##*(  )}⚙"
      bgclr='magenta'
      fgclr='white'
    fi

    if [[ $number_added -gt 0 || $number_added_modified -gt 0 || $number_added_deleted -gt 0 ]]; then ready_commit=' ⇡'; fi

    local upstream_prompt=''
    if [[ $has_upstream == true ]]; then
      commits_diff="$(git log --pretty=oneline --topo-order --left-right ${current_commit_hash}...${upstream} 2> /dev/null)"
      commits_ahead=$(\grep -c "^<" <<< "$commits_diff")
      commits_behind=$(\grep -c "^>" <<< "$commits_diff")
      upstream_prompt="$(git rev-parse --symbolic-full-name --abbrev-ref @{upstream} 2> /dev/null)"
      upstream_prompt=$(sed -e 's/\/.*$/\//g' <<< "$upstream_prompt")
    fi

    has_diverged=false
    if [[ $commits_ahead -gt 0 && $commits_behind -gt 0 ]]; then has_diverged=true; fi
    if [[ $has_diverged == false && $commits_ahead -gt 0 ]]; then
      if [[ $bgclr == 'red' || $bgclr == 'magenta' ]] then
        to_push=" $fg_bold[cyan]↑$commits_ahead$fg_bold[$fgclr]"
      else
        to_push=" $fg_bold[cyan]↑$commits_ahead$fg_bold[$fgclr]"
      fi
    fi
    if [[ $has_diverged == false && $commits_behind -gt 0 ]]; then to_pull=" $fg_bold[magenta]↓$commits_behind$fg_bold[$fgclr]"; fi

    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      mode=" <B>"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      mode=" >M<"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      mode=" >R>"
    fi

    print -n "${ref/refs\/heads\// $fg[magenta]$PL_BRANCH_CHAR$upstream_prompt}$fg[white]${mode}$to_push$to_pull$clean$tagged$stashed$fg_bold[blue]$untracked$fg_bold[yellow]$modified$fg_bold[red]$deleted$fg_bold[green]$added$fg_bold[white]$ready_commit$reset_color"
  fi
}

PROMPT='%(?,,%{$fg[red]%}FAIL${NEWLINE}%{$reset_color%})\
┌─[%F{blue}%~%f] [%F{green}%D{%H:%M:%S}%f]$(git_prompt)$(git_time_since_commit)
└─▶ '
